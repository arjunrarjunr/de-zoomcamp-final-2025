terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
# Create an ECR repository for the Lambda function
# This repository will store the Docker image for the Lambda function
# The image will be built from the Dockerfile in the specified GitHub repository
# The image will be tagged with the latest version
# The repository will be created with the specified name and tags
# The image will be scanned for vulnerabilities on push
resource "aws_ecr_repository" "my_ecr_repo" {
  name = var.ingestion_image_name
  tags = {
    Name        = var.ingestion_image_name
    Environment = "dev"
  }
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket" "my_s3_bucket" {
  bucket = var.s3_bucket_name

  tags = {
    Name        = var.s3_bucket_name
    Environment = "dev"
  }
  lifecycle {
    prevent_destroy = true
  }
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "Lambda_${aws_s3_bucket.my_s3_bucket.bucket}_Role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "Service": "lambda.amazonaws.com" },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "Lambda_KaggleHub_S3_Policy"
  description = "Policy for Lambda to access Secrets Manager, S3, and CloudWatch Logs"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "secretsmanager:GetSecretValue",
      "Resource": "${var.kaggle_key_arn}"
    },
    {
      "Effect": "Allow",
      "Action": ["s3:PutObject"],
      "Resource": "${aws_s3_bucket.my_s3_bucket.arn}/*"
    },
    {
      "Effect": "Allow",
      "Action": ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_lambda_function" "my_lambda_function" {
  function_name = var.lambda_function_name
  description   = "Ingest dataset from Kaggle to S3"
  package_type  = "Image"
  image_uri     = "${var.aws_account_id}.dkr.ecr.us-east-1.amazonaws.com/${var.ingestion_image_name}:latest"
  role          = aws_iam_role.lambda_role.arn
  memory_size   = 3008

  environment {
    variables = {
      S3_BUCKET_NAME = aws_s3_bucket.my_s3_bucket.bucket
    }
  }

  tags = {
    Name        = var.lambda_function_name
    Environment = "dev"
  }

}

# EventBridge Rule for Daily 6 AM IST
resource "aws_cloudwatch_event_rule" "lambda_schedule_rule" {
  name                = "lambda-daily-6am-ist"
  description         = "Trigger Lambda at 6 AM IST daily"
  schedule_expression = "cron(30 0 * * ? *)" # 6 AM IST (India Standard Time)
}

# Permission to Allow EventBridge to Invoke Lambda
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_schedule_rule.arn
}

# Attach the EventBridge Rule to the Lambda Function
resource "aws_cloudwatch_event_target" "trigger_lambda" {
  rule      = aws_cloudwatch_event_rule.lambda_schedule_rule.name
  target_id = "lambda"
  arn       = aws_lambda_function.my_lambda_function.arn
}


# Create SNS Topic
resource "aws_sns_topic" "weather_dataset_stage_topic" {
  name = "snowflake-stage-notifications"
  tags = {
    Name        = "snowflake-stage-notifications"
    Environment = "dev"
  }
}

# Create SQS Queue
resource "aws_sqs_queue" "weather_dataset_stage_queue" {
  name = "snowflake-stage-queue"
  tags = {
    Name        = "snowflake-stage-queue"
    Environment = "dev"
  }
}

# Subscribe SQS Queue to SNS Topic
resource "aws_sns_topic_subscription" "weather_dataset_stage_subscription" {
  topic_arn = aws_sns_topic.weather_dataset_stage_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.weather_dataset_stage_queue.arn
}

# Allow SNS to send messages to SQS queue
resource "aws_sqs_queue_policy" "weather_dataset_allow_sns_publish" {
  queue_url = aws_sqs_queue.weather_dataset_stage_queue.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "Allow-SNS-SendMessage",
        Effect = "Allow",
        Principal = {
          Service = "sns.amazonaws.com"
        },
        Action   = "sqs:SendMessage",
        Resource = aws_sqs_queue.weather_dataset_stage_queue.arn,
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.weather_dataset_stage_topic.arn
          }
        }
      }
    ]
  })
}


resource "aws_s3_bucket_notification" "weather_dataset_notification" {
   bucket = aws_s3_bucket.my_s3_bucket.id

  queue {
    queue_arn     = aws_sqs_queue.weather_dataset_stage_queue.arn
    events        = ["s3:ObjectCreated:*"]
    filter_suffix = ".csv"
    filter_prefix = var.weather_dataset_prefix
  }

  depends_on = [aws_sqs_queue_policy.weather_dataset_allow_sns_publish]
}


resource "aws_iam_role" "snowflake_role" {
  name = "snowflake_s3_access_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "${var.snowflake_iam_user_arn}"  # This is the STORAGE_AWS_IAM_USER_ARN from Snowflake
        },
        Action = "sts:AssumeRole",
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.snowflake_external_id  # This is the STORAGE_AWS_EXTERNAL_ID from Snowflake
          }
        }
      }
    ]
  })
}


resource "aws_iam_policy" "snowflake_s3_policy" {
  name        = "snowflake-s3-policy"
  description = "Policy for Snowflake to access S3, SQS, and publish to SNS"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          "${aws_s3_bucket.my_s3_bucket.arn}",
          "${aws_s3_bucket.my_s3_bucket.arn}/${var.weather_dataset_prefix}*"
        ]
      },
      {
        Effect = "Allow",
        Action = ["sns:Publish"],
        Resource = [
          aws_sns_topic.weather_dataset_stage_topic.arn
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ],
        Resource = [
          aws_sqs_queue.weather_dataset_stage_queue.arn
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.snowflake_role.name
  policy_arn = aws_iam_policy.snowflake_s3_policy.arn
}