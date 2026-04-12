SELECT job_posted_date
FROM job_postings_fact
LIMIT 10;


-- Checking the date queries
SELECT 
        '2023-02-19'::DATE,
        '123'::INTEGER,
        'true'::BOOLEAN,
        '3.14'::REAL;


-- Running SQL queries on the actual database being uploaded
SELECT
	job_title_short AS title,
	job_location AS location,
	job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date--Format the date
FROM
	job_postings_fact
ORDER BY
    job_posted_date::DATE
LIMIT 5;


-- Extracting Months from the job_posted_date
SELECT
	job_title_short AS title,
	job_location AS location,
	job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date_time,--Format the date
    EXTRACT(MONTH FROM job_posted_date) AS date_month,
    EXTRACT(YEAR FROM job_posted_date) AS date_year
FROM
	job_postings_fact
LIMIT 5;

-- Counting the number of jobs posted for each month
SELECT
    COUNT(job_id) AS job_posted_count,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM 
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    month
ORDER BY
    job_posted_count DESC;




