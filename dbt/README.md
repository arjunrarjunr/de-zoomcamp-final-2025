##### Terraform not supported in trial

# DBT Weather Data Pipeline

This DBT project processes and transforms raw weather data into clean, structured, and analytics-ready tables. The pipeline is designed to handle data ingestion, cleaning, standardization, and aggregation for downstream analytics and reporting.

---

## High-Level Overview of the DBT Process

1. **Raw Data Source**:
   - The raw weather data is ingested from the `kaggle_datasets.weather_dataset_raw` source table.

2. **Staging Models (`stg_weather`)**:
   - The raw data is cleaned and standardized.
   - Columns are renamed, formatted, and type-cast for consistency.
   - A surrogate key (`rec_id`) is generated, and duplicate records are handled.

3. **Intermediate Models (`int_weather`)**:
   - The staging data is further processed to standardize country and city names.
   - Deduplication is performed by selecting the first record for each combination of `date`, `country`, and `city`.
   - The cleaned data is prepared for use in fact tables.

4. **Fact Models (`fct_weather`)**:
   - The intermediate data is loaded into a fact table.
   - Incremental loading ensures only new or updated data is processed.
   - The fact table serves as the final dataset for analytics and reporting.

---

## Block Diagram of Models

```mermaid
flowchart TD
    A[Raw Data Source] --> B[stg_weather --- (Staging Model) --- - Data cleaning --- - Type casting --- - Surrogate key]
    B --> C[int_weather --- (Intermediate Model) --- - Standardization --- - Deduplication]
    C --> D[fct_weather --- (Fact Model) --- - Incremental load --- - Analytics-ready]
```



---

## Key Features of the Pipeline

- **Data Cleaning and Standardization**:
  - Ensures consistent column names, formats, and values.
  - Handles multilingual and inconsistent country/city names.

- **Deduplication**:
  - Removes duplicate records to ensure data accuracy.

- **Incremental Loading**:
  - Optimizes performance by processing only new or updated data.

- **Analytics-Ready Data**:
  - Provides a clean and structured dataset for downstream analytics and reporting.

---

## How to Run the Pipeline

1. **Set Up DBT**:
   - Ensure DBT is installed and configured with your Snowflake connection.

2. **Run Models**:
   - Execute the models in sequence:
     ```bash
     dbt run --select stg_weather
     dbt run --select int_weather
     dbt run --select fct_weather
     ```

3. **Test Models**:
   - Validate the models using DBT tests:
     ```bash
     dbt test
     ```

4. **Incremental Updates**:
   - For incremental updates, simply run:
     ```bash
     dbt run --select fct_weather
     ```

---

This pipeline ensures efficient and reliable processing of weather data, making it ready for advanced analytics and reporting.