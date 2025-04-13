

terraform {
  required_providers {
    snowflake = {
      source = "Snowflake-Labs/snowflake"
    }
  }
}

# A simple configuration of the provider with private key authentication.
provider "snowflake" {
  organization_name        = "GBVTYCG"
  account_name             = "YIB31062"
  user                     = "terraform_user"
  role                     = "TERRAFORM_ADMIN"
  authenticator            = "SNOWFLAKE_JWT"
  private_key              = file("./.ssh/sf_tf_user_private_key.p8")
  preview_features_enabled = ["snowflake_table_resource", "snowflake_storage_integration_resource", "snowflake_file_format_resource", "snowflake_stage_resource", "snowflake_pipe_resource"]
}

resource "snowflake_database" "kaggle_datasets" {
  name                        = "KAGGLE_DATASETS"
  comment                     = "Database for Kaggle datasets"
  data_retention_time_in_days = 1
}


resource "snowflake_schema" "weather" {
  name     = "WEATHER"
  database = snowflake_database.kaggle_datasets.name
  comment  = "Schema for weather datasets"
}

resource "snowflake_account_role" "data_engineer_role" {
  name    = "DATA_ENGINEER_ROLE"
  comment = "Role for data engineers"

}


resource "snowflake_grant_privileges_to_account_role" "weather_dataset_table_privileges" {
  account_role_name = snowflake_account_role.data_engineer_role.name
  on_schema {
    schema_name = snowflake_schema.weather.fully_qualified_name
  }
  all_privileges    = true
  with_grant_option = false
}






resource "snowflake_warehouse" "data_engineer_warehouse" {
  name                  = "DATA_ENGINEER_WAREHOUSE"
  warehouse_size        = "XSMALL"
  auto_suspend          = 60
  auto_resume           = true
  initially_suspended   = true
  max_concurrency_level = 10
  min_cluster_count     = 1
  max_cluster_count     = 10
  scaling_policy        = "ECONOMY"

}



resource "snowflake_user" "data_engineer" {
  name              = "DATA_ENGINEER"
  default_role      = snowflake_account_role.data_engineer_role.name
  default_namespace = "${snowflake_database.kaggle_datasets.name}.${snowflake_schema.weather.name}"
  comment           = "User for data engineers"
  default_warehouse = snowflake_warehouse.data_engineer_warehouse.name
}

resource "snowflake_storage_integration" "s3_kaggle_weather_dataset_integration" {
  name                      = "S3_KAGGLE_WEATHER_DATASET_INTEGRATION"
  storage_provider          = "S3"
  enabled                   = true
  storage_aws_role_arn      = var.iam_role_arn
  storage_allowed_locations = ["s3://${var.kaggle_bucket_name}/${var.weather_dataset_prefix}"]
}



resource "snowflake_file_format" "weather_dataset_csv_format" {
  name            = "WEATHER_DATASET_CSV_FORMAT"
  format_type     = "CSV"
  database        = snowflake_database.kaggle_datasets.name
  schema          = snowflake_schema.weather.name
  field_delimiter = ","
  skip_header     = 1
}

resource "snowflake_stage" "weather_dataset_s3_stage" {
  name                = "WEATHER_DATASET_S3_STAGE"
  url                 = "s3://${var.kaggle_bucket_name}/${var.weather_dataset_prefix}"
  storage_integration = snowflake_storage_integration.s3_kaggle_weather_dataset_integration.name
  file_format         = "FORMAT_NAME = '${snowflake_file_format.weather_dataset_csv_format.fully_qualified_name}'"

  database = snowflake_database.kaggle_datasets.name
  schema   = snowflake_schema.weather.name
  comment  = "Stage for weather datasets"
}

resource "snowflake_table" "weather_dataset_raw" {
  name     = "WEATHER_DATASET_RAW"
  database = snowflake_database.kaggle_datasets.name
  schema   = snowflake_schema.weather.name
  comment  = "Raw weather dataset table"

  column {
    name = "country"
    type = "STRING"
  }

  column {
    name = "location_name"
    type = "STRING"
  }

  column {
    name = "latitude"
    type = "FLOAT"
  }

  column {
    name = "longitude"
    type = "FLOAT"
  }

  column {
    name = "timezone"
    type = "STRING"
  }

  column {
    name = "last_updated_epoch"
    type = "NUMBER"
  }

  column {
    name = "last_updated"
    type = "TIMESTAMP_NTZ"
  }

  column {
    name = "temperature_celsius"
    type = "FLOAT"
  }

  column {
    name = "temperature_fahrenheit"
    type = "FLOAT"
  }

  column {
    name = "condition_text"
    type = "STRING"
  }

  column {
    name = "wind_mph"
    type = "FLOAT"
  }

  column {
    name = "wind_kph"
    type = "FLOAT"
  }

  column {
    name = "wind_degree"
    type = "NUMBER"
  }

  column {
    name = "wind_direction"
    type = "STRING"
  }

  column {
    name = "pressure_mb"
    type = "FLOAT"
  }

  column {
    name = "pressure_in"
    type = "FLOAT"
  }

  column {
    name = "precip_mm"
    type = "FLOAT"
  }

  column {
    name = "precip_in"
    type = "FLOAT"
  }

  column {
    name = "humidity"
    type = "NUMBER"
  }

  column {
    name = "cloud"
    type = "NUMBER"
  }

  column {
    name = "feels_like_celsius"
    type = "FLOAT"
  }

  column {
    name = "feels_like_fahrenheit"
    type = "FLOAT"
  }

  column {
    name = "visibility_km"
    type = "FLOAT"
  }

  column {
    name = "visibility_miles"
    type = "FLOAT"
  }

  column {
    name = "uv_index"
    type = "FLOAT"
  }

  column {
    name = "gust_mph"
    type = "FLOAT"
  }

  column {
    name = "gust_kph"
    type = "FLOAT"
  }

  column {
    name = "air_quality_carbon_monoxide"
    type = "FLOAT"
  }

  column {
    name = "air_quality_ozone"
    type = "FLOAT"
  }

  column {
    name = "air_quality_nitrogen_dioxide"
    type = "FLOAT"
  }

  column {
    name = "air_quality_sulphur_dioxide"
    type = "FLOAT"
  }

  column {
    name = "air_quality_pm2_5"
    type = "FLOAT"
  }

  column {
    name = "air_quality_pm10"
    type = "FLOAT"
  }

  column {
    name = "air_quality_us_epa_index"
    type = "NUMBER"
  }

  column {
    name = "air_quality_gb_defra_index"
    type = "NUMBER"
  }

  column {
    name = "sunrise"
    type = "STRING"
  }

  column {
    name = "sunset"
    type = "STRING"
  }

  column {
    name = "moonrise"
    type = "STRING"
  }

  column {
    name = "moonset"
    type = "STRING"
  }

  column {
    name = "moon_phase"
    type = "STRING"
  }

  column {
    name = "moon_illumination"
    type = "NUMBER"
  }
}


resource "snowflake_pipe" "weather_dataset_snowpipe" {
  name        = "WEATHER_DATASET_SNOWPIPE"
  database    = snowflake_database.kaggle_datasets.name
  schema      = snowflake_schema.weather.name
  auto_ingest = true

  copy_statement = <<EOT
COPY INTO ${snowflake_table.weather_dataset_raw.fully_qualified_name}
FROM @${snowflake_stage.weather_dataset_s3_stage.fully_qualified_name}
FILE_FORMAT = (FORMAT_NAME = '${snowflake_file_format.weather_dataset_csv_format.fully_qualified_name}');
EOT


}