-- Data Cleaning

Select * 
FROM layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the Data (fix spellings, etc.)
-- 3. Null or Blank Values
-- 4. Remove Columns/Rows that are unecessary

-- 1. Remove Duplicates
Select * 
from layoffs;

CREATE TABLE layoffs_staging
LIKE layoffs;

Select * 
FROM layoffs_staging;

INSERT layoffs_staging
SELECT * FROM layoffs;

Select *, 
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) as row_num
FROM layoffs_staging;

WITH duplicate_cte as 
(
Select *, 
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_staging
)
Select * 
from duplicate_cte 
where row_num > 1;

Select * 
FROM layoffs_staging
WHERE company = 'Casper';

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

Select * 
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
Select *, 
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_staging;

Select * 
FROM layoffs_staging2
WHERE row_num > 1;

DELETE 
FROM layoffs_staging2
WHERE row_num > 1;

Select * 
FROM layoffs_staging2;

-- 2. Standardizing Data

SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoffs_staging2;

UPDATE layoffs_staging2 # makes all instance of crypto currency just 'Crypto'
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

Select distinct country, TRIM(TRAILING '.' FROM country) 
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2 # Remove United States with period at the end
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

Select `date`,
STR_TO_DATE(`date`, '%m/%d/%Y') 
from layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y'); # change each date from text to date

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE; # Change whole column to date column

-- 3. Null or Blank Values

Select * 
FROM layoffs_staging2
WHERE total_laid_off is NULL
AND percentage_laid_off is NULL;

UPDATE layoffs_staging2 # convert all blank values into null values
SET industry = null
WHERE industry = '';

Select *
FROM layoffs_staging2
WHERE industry is NULL
OR industry = '';

Select *
FROM layoffs_staging2
WHERE company = 'Airbnb';

SELECT t1.industry, t2.industry # giving us industries where there's more than one company and one industry is null while the other has an industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE t1.industry is NULL
AND t2.industry is not NULL;

UPDATE layoffs_staging2 t1 # Now populate all null industries with the appropriate industry
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry is NULL
AND t2.industry is not NULL;

Select * 
FROM layoffs_staging2;

-- 4. Remove Columns/Rows that are unecessary

Select * 
FROM layoffs_staging2
WHERE total_laid_off is NULL
AND percentage_laid_off is NULL;

DELETE 
FROM layoffs_staging2
WHERE total_laid_off is NULL
AND percentage_laid_off is NULL;

Select * 
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num; # Removes column