"""
This script is an AWS Lambda function designed to download a dataset from Kaggle, process it, and upload it to an S3 bucket.
Modules:
    - os: Provides functions to interact with the operating system.
    - boto3: AWS SDK for Python to interact with AWS services.
    - zipfile: Provides tools to work with ZIP archives.
    - shutil: High-level file operations like copying and removal.
    - datetime: Provides classes for manipulating dates and times.
Functions:
    - download_dataset(): Downloads a dataset from Kaggle using the Kaggle API, extracts it, and returns the path to the extracted files.
    - clean_non_csv_files(dataset_path): Removes all non-CSV files from the specified dataset directory.
    - upload_to_s3(dataset_path): Uploads CSV files from the dataset directory to an S3 bucket, renaming them with the current date as a prefix.
    - lambda_handler(event, context): AWS Lambda entry point that orchestrates the dataset download, processing, and upload to S3.
Constants:
    - S3_BUCKET: Name of the S3 bucket where the dataset will be uploaded.
    - KAGGLE_DATASET_LINK: URL to download the dataset from Kaggle.
    - S3_PREFIX: Prefix for the S3 keys when uploading files.
    - dataset_raw_path: Temporary path for storing the downloaded dataset.
    - dataset_unzip_path: Temporary path for storing the extracted dataset.
Usage:
    This script is intended to be deployed as an AWS Lambda function. It downloads a dataset from Kaggle, processes it to retain only CSV files, and uploads the processed files to an S3 bucket with a date-prefixed filename.
"""
import os
import boto3
import zipfile
import shutil
from datetime import datetime



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

    current_date = datetime.now().strftime("%Y%m%d") 

    for root, _, files in os.walk(dataset_path):
        for file in files:
            if file.endswith(".csv"):
                local_path = os.path.join(root, file)

                # Split filename and extension
                filename, ext = os.path.splitext(file)
                renamed_file = f"{current_date}_{filename}{ext}" 

                # S3 key with renamed file
                s3_key = f"{S3_PREFIX}{renamed_file}"

                s3_client.upload_file(local_path, S3_BUCKET, s3_key)
                print(f"Uploaded {renamed_file} to s3://{S3_BUCKET}/{s3_key}")

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
