import os
import boto3
import zipfile
import shutil


# AWS Clients
s3_client = boto3.client('s3')


# Constants
S3_BUCKET = "de-zoomcamp-2025-kaggle-dataset-storage"
KAGGLE_DATASET_LINK = "https://www.kaggle.com/api/v1/datasets/download/nelgiriyewithana/global-weather-repository"
S3_PREFIX = "global-weather-repository/"
dataset_raw_path = "/tmp/kaggle_dataset"
dataset_unzip_path = "/tmp/kaggle_dataset/unzip"


def download_dataset():
    """Download dataset using the Kaggle API."""
    
    os.makedirs(dataset_raw_path, exist_ok=True)
    os.makedirs(dataset_unzip_path, exist_ok=True)


    os.system(f"curl -L -o {dataset_raw_path}/global-weather-repository.zip  {KAGGLE_DATASET_LINK}")
    with zipfile.ZipFile(f"{dataset_raw_path}/global-weather-repository.zip", 'r') as zip_ref:
        zip_ref.extractall(dataset_unzip_path)

    

    return dataset_unzip_path

def clean_non_csv_files(dataset_path):
    """
    Remove all files in the dataset directory that are not .csv files.
    
    Args:
        dataset_path (str): Path to the directory containing the dataset files.
    """
    for root, _, files in os.walk(dataset_path):
        for file in files:
            if not file.endswith(".csv"):  # Check if the file is not a .csv file
                file_path = os.path.join(root, file)  # Get the full path of the file
                os.remove(file_path)  # Delete the file
                print(f"Deleted non-CSV file: {file_path}")

def upload_to_s3(dataset_path):
    clean_non_csv_files(dataset_path)
    """Upload all dataset files to S3."""
    for root, _, files in os.walk(dataset_path):
        for file in files:
            local_path = os.path.join(root, file)
            s3_key = f"{S3_PREFIX}{file}"

            s3_client.upload_file(local_path, S3_BUCKET, s3_key)
            print(f"Uploaded {file} to s3://{S3_BUCKET}/{s3_key}")

def lambda_handler(event, context):
    try:
    

        # Step 1: Download dataset using Curl
        dataset_path = download_dataset()

        # Step 2: Upload extracted dataset to S3
        upload_to_s3(dataset_path)

        # Cleanup
        shutil.rmtree(dataset_path, ignore_errors=True)

        return {"statusCode": 200, "body": "Dataset uploaded successfully!"}

    except Exception as e:
        return {"statusCode": 500, "body": str(e)}
