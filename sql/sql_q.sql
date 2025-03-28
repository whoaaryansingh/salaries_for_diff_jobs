-- ======================
-- STEP 1: DATA CLEANING
-- ======================

-- Handle null or missing values
UPDATE ds_salaries
SET salary_in_usd = 0
WHERE salary_in_usd IS NULL;

-- Standardizing text formats (e.g., experience levels)
UPDATE ds_salaries
SET experience_level = UPPER(TRIM(experience_level));

-- Correcting data inconsistencies in country codes
UPDATE ds_salaries
SET employee_residence = 'Unknown'
WHERE employee_residence = '';

-- ======================
-- STEP 2: EMPLOYEE DISTRIBUTION BY RESIDENCE
-- ======================

SELECT 
    employee_residence,
    COUNT(*) AS total_employees
FROM 
    ds_salaries
GROUP BY 
    employee_residence
ORDER BY 
    total_employees DESC;

-- ======================
-- STEP 3: AVERAGE SALARY BY COUNTRY AND JOB TITLE
-- ======================

SELECT 
    employee_residence AS country,
    job_title,
    ROUND(AVG(salary_in_usd), 2) AS avg_salary_usd
FROM 
    ds_salaries
GROUP BY 
    employee_residence, job_title
ORDER BY 
    country ASC, avg_salary_usd DESC;

-- ======================
-- STEP 4: EXPERIENCE LEVEL DISTRIBUTION (WITH PERCENTAGE)
-- ======================

SELECT 
    experience_level,
    COUNT(*) AS total_employees,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage,
    ROUND(AVG(salary_in_usd), 2) AS avg_salary_usd
FROM 
    ds_salaries
GROUP BY 
    experience_level
ORDER BY 
    total_employees DESC;

-- ======================
-- STEP 5: AVERAGE SALARY BY EXPERIENCE LEVEL AND EMPLOYMENT TYPE
-- ======================

SELECT 
    experience_level,
    employment_type,
    ROUND(AVG(salary_in_usd), 2) AS avg_salary_usd
FROM 
    ds_salaries
GROUP BY 
    experience_level, employment_type
ORDER BY 
    experience_level, avg_salary_usd DESC;

-- ======================
-- STEP 6: TOP-PAYING ROLES (OPTIONAL BONUS)
-- ======================

SELECT 
    job_title,
    ROUND(AVG(salary_in_usd), 2) AS avg_salary_usd
FROM 
    ds_salaries
GROUP BY 
    job_title
ORDER BY 
    avg_salary_usd DESC
LIMIT 10;
