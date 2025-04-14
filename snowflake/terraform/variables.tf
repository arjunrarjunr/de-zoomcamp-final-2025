variable "kaggle_bucket_arn" {
  default = "arn:aws:s3:::de-zoomcamp-2025-kaggle-dataset-storage"
}

variable "weather_dataset_prefix" {
  default = "global-weather-repository/"
}

variable "iam_role_arn" {
  default = "arn:aws:iam::314146310890:role/snowflake_s3_access_role"

}

variable "kaggle_bucket_name" {
  default = "de-zoomcamp-2025-kaggle-dataset-storage"

}
