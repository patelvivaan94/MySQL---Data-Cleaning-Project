**World Layoffs Data Cleaning (MySQL)**

Overview
This project implements a data cleaning pipeline in MySQL using a real-world dataset on global layoffs. The raw data contained common production issues such as duplicate records, inconsistent text formatting, incorrect data types, and missing values. All transformations were performed using staging tables to preserve the original data.

Dataset
- Source: Public World Layoffs dataset
- Size: 2,361 rows
- Domain: Companies, industries, countries, funding stages, and layoff metrics

Key Cleaning Steps
- Removed duplicate records using ROW_NUMBER() window functions in the absence of a primary key.
- Standardized text fields by trimming whitespace and unifying categorical values (e.g., industry names, country formatting).
- Converted date values from TEXT to DATE using STR_TO_DATE().
- Handled null and blank values, including populating missing categorical data via self-joins where reliable matches existed.
- Deleted rows with no meaningful layoff data and removed temporary helper columns.

Technical Focus
- MySQL staging-table workflow
- Window functions and CTEs
- Safe, incremental data transformations
- Schema cleanup and data validation

Outcome
- The final dataset is clean, consistently formatted, and ready for analysis or downstream use, while preserving the raw source data.

Technologies
- MySQL
- SQL (CTEs, window functions, joins)
- MySQL Workbench
