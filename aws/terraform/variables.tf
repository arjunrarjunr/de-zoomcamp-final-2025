variable "region" {
  default = "us-east-1"
}

variable "s3_bucket_name" {
  default = "de-zoomcamp-2025-kaggle-dataset-storage"
}


variable "lambda_function_name" {
  default = "ingest-dataset"
}

variable "github_repo_url" {
  default = "https://github.com/arjunrarjunr/de-zoomcamp-final-2025.git"
}

variable "ingestion_image_name" {
  default = "lambda-ingestion"
}

variable "kaggle_key_arn" {
  default = "arn:aws:secretsmanager:us-east-1:314146310890:secret:my_kaggle_key-cOdud8"

}

variable "aws_account_id" {
  default = "314146310890"
}

variable "weather_dataset_prefix" {
  default = "global-weather-repository/"

}


variable "sf_s3_access_weather_dataset_access_role" {
  default = "Snowflake_S3_Weather_Dataset_Access_Role"

}

variable "snowpipe_trigger_weather_dataset_staging_topic" {
  default = "snowpipe_trigger_weather_dataset_staging_topic"
}

variable "snowflake_iam_user_arn" {
  default = "arn:aws:iam::118006903233:user/zqry0000-s"

}

variable "snowflake_external_id" {
  default = "RXB66470_SFCRole=61_j+SRNEMakR4t4mLFGYoLeQeb/fo="

}