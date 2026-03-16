# Healthcare Data Platform – dbt Implementation

## 1. Overview

This project implements a **modern data platform for Healthcare QA laboratory data** using **dbt and DuckDB**. The goal is to transform raw laboratory QA data into a **structured analytical star schema** to support reporting, analytics, and quality monitoring.

The pipeline follows **modern data engineering best practices**, including:

* Medallion architecture
* Modular data modeling
* Dimensional modeling (Star Schema)
* Automated data quality testing
* Version-controlled transformations

---

# 2. Architecture

## High-Level Architecture

```
Raw Dataset
     │
     ▼
Seeds (Bronze Layer)
     │
     ▼
Staging Models (Standardization)
     │
     ▼
Intermediate Models (Data Cleaning)
     │
     ▼
Dimensional Models
     │
     ▼
Fact Tables (Analytics Layer)
```

---

## Medallion Data Architecture

| Layer  | Purpose                          | Implementation                |
| ------ | -------------------------------- | ----------------------------- |
| Bronze | Raw data ingestion               | dbt Seeds                     |
| Silver | Cleaned and standardized data    | Staging + Intermediate models |
| Gold   | Business-ready analytical models | Dimensional + Fact models     |

---

## Logical Data Flow

```
healthcare_lab_dataset (seed)
        │
        ▼
stg_lab_results
        │
        ▼
int_lab_results_cleaned
        │
 ┌──────┼──────────┐
 ▼      ▼          ▼
dim_product  dim_method  dim_status
       ▼
   dim_batch
       ▼
    dim_test
       │
       ▼
   fct_qa_tests
```

---

# 3. Technology Stack

| Component                | Technology           |
| ------------------------ | -------------------- |
| Transformation Framework | dbt                  |
| Local Analytical Engine  | DuckDB               |
| Data Storage             | DuckDB file database |
| Data Modeling            | SQL                  |
| Version Control          | Git / GitHub         |
| Development Environment  | VS Code              |
| Data Quality             | dbt tests            |

---

# 4. Repository Structure

```
healthcare-data-platform_dbt
│
├── seeds
│     healthcare_lab_dataset.csv
│
├── models
│
│   ├── staging
│   │   └── lab
│   │        stg_lab_results.sql
│   │
│   ├── intermediate
│   │   └── lab
│   │        int_lab_results_cleaned.sql
│   │
│   └── marts
│
│       ├── dimensions
│       │
│       │   dim_product.sql
│       │   dim_method.sql
│       │   dim_status.sql
│       │   dim_batch.sql
│       │   dim_test.sql
│       │
│       └── facts
│           fct_qa_tests.sql
│
├── tests
│     lab_tests.yml
│
├── macros
│
└── dbt_project.yml
```

---

# 5. Data Modeling Strategy

The analytical model follows a **Star Schema** design to optimize query performance and simplify analytical queries.

## Dimension Tables

| Table       | Description                              |
| ----------- | ---------------------------------------- |
| dim_product | Product and product grade information    |
| dim_method  | Testing method and stage information     |
| dim_status  | Result status and reporting indicators   |
| dim_batch   | Batch information for laboratory samples |
| dim_test    | Test metadata                            |

---

## Fact Table

| Table        | Description                           |
| ------------ | ------------------------------------- |
| fct_qa_tests | Core QA test results and measurements |

The fact table connects all dimensions through **surrogate keys**.

---

# 6. Data Pipeline Layers

## Bronze Layer

**Purpose**

Store raw source data.

Implementation:

```
dbt seeds
```

Source dataset:

```
healthcare_lab_dataset.csv
```

Loaded into DuckDB as:

```
healthcare_lab_dataset
```

---

## Staging Layer

**Purpose**

Standardize raw data.

Transformations include:

* column renaming
* datatype conversion
* light normalization

Example model:

```
stg_lab_results
```

---

## Intermediate Layer

**Purpose**

Clean and prepare data for analytics.

Transformations include:

* duplicate removal
* null handling
* data corrections
* column normalization

Example model:

```
int_lab_results_cleaned
```

---

## Gold Layer

Business-ready data models.

Includes:

* dimension tables
* fact tables
* analytical relationships

---

# 7. Migration Strategy

## Legacy Architecture

Original system used:

```
PySpark / Databricks pipelines
```

Data transformations were implemented using:

* PySpark DataFrames
* Notebook pipelines
* Delta tables

---

## Migration Goals

| Goal                             | Description            |
| -------------------------------- | ---------------------- |
| Reduce infrastructure complexity | Use lightweight DuckDB |
| Standardize transformations      | Use dbt SQL models     |
| Improve maintainability          | Modular data models    |
| Enable version control           | Git-based development  |
| Improve testing                  | dbt automated tests    |

---

## Migration Approach

### Step 1 – Identify transformation logic

Extract PySpark transformations such as:

* duplicates removal
* column cleaning
* null handling
* schema standardization

---

### Step 2 – Convert transformations to SQL

Example:

PySpark:

```
df = df.dropDuplicates()
df = df.withColumn("status", trim("status"))
```

Converted to SQL:

```
select distinct
    trim(status)
from dataset
```

---

### Step 3 – Implement dbt layers

```
Seeds → Staging → Intermediate → Marts
```

---

### Step 4 – Validate results

Validation methods:

* row count comparison
* sample data validation
* dbt tests

---

# 8. Data Quality Testing

dbt tests ensure:

| Test          | Purpose                     |
| ------------- | --------------------------- |
| not_null      | Prevent missing values      |
| unique        | Ensure dimension uniqueness |
| relationships | Validate foreign keys       |

Example:

```
dbt test
```

---

# 9. Deployment Strategy

For production environments, dbt can run through:

| Tool           | Use                    |
| -------------- | ---------------------- |
| Airflow        | Pipeline orchestration |
| GitHub Actions | CI/CD pipelines        |
| dbt Cloud      | Managed dbt execution  |

Typical pipeline execution:

```
dbt seed
dbt run
dbt test
dbt docs generate
```

---

# 10. Data Governance

Key governance principles:

* version-controlled transformations
* documented models
* tested data pipelines
* traceable lineage

dbt automatically provides:

* model documentation
* dependency graphs
* lineage tracking

---

# 11. Data Lineage

dbt generates a DAG showing model dependencies.

Example lineage:

```
seed_healthcare_lab_dataset
        │
        ▼
stg_lab_results
        │
        ▼
int_lab_results_cleaned
        │
        ▼
dim_tables
        │
        ▼
fct_qa_tests
```

---

# 12. Performance Optimization

Optimization strategies include:

* dimension normalization
* query pruning
* view vs table materialization
* incremental fact tables (future enhancement)

---

# 13. Future Enhancements

Possible improvements:

* incremental fact table loading
* CI/CD pipeline automation
* data observability monitoring
* dashboard integration
* production data warehouse deployment

Potential warehouse targets:

* Snowflake
* BigQuery
* Databricks
* Redshift

---

# 14. How to Run the Pipeline

Run the entire pipeline:

```
dbt seed
dbt run
dbt test
```

Inspect data:

```
duckdb healthcare.duckdb
```

Example query:

```
select * from fct_qa_tests limit 10;
```

---

# 15. Key Benefits

This architecture provides:

* modular transformations
* scalable analytics models
* improved data quality
* version-controlled pipelines
* simplified analytics development