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