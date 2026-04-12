-- Creating the Table for Data Science Jobs
CREATE TABLE data_science_jobs(
    job_id INT PRIMARY KEY,
    job_title TEXT,
    company_name TEXT,
    post_date DATE
);


-- Inserting Three Job Postings into the Data Science Jobs
INSERT INTO data_science_jobs (
    job_id,
    job_title,
    company_name,
    post_date
)
VALUES (
    1,
    'Data Scientist',
    'Tech Innovations',
    '2023-01-01'
),
(
    2,
    'Machine Learning Engineer',
    'Data Driven Co',
    '2023-01-15'
),
(
    3,
    'AI Specialist',
    'Future Tech',
    '2023-02-01'
);


-- Altering the Data Science Table to add a new boolean column (uses True or False values) named remote.
ALTER TABLE data_science_jobs
ADD remote BOOLEAN

-- Renaming the post_date to posted_on
ALTER TABLE data_science_jobs
RENAME COLUMN post_date to posted_on;

-- Modify the remote column so that it defaults to FALSE in the data_science_jobs table.
ALTER Table data_science_jobs
ALTER COLUMN remote SET DEFAULT FALSE;

-- insert a new row with the following:
INSERT INTO data_science_jobs (job_id, job_title, company_name, posted_on) VALUES (4, 'Data Scientist', 'Google', '2023-02-05');

-- Drop the company_name column from the data_science_jobs table.
ALTER TABLE data_science_jobs
DROP COLUMN company_name;

-- Updating the job posting with the job_id = 2. Update the remote column for this job posting to True in data_science_jobs.
UPDATE data_science_jobs
SET remote = TRUE
WHERE job_id = 2;

-- Dropping the data_science_jobs TABLE
DROP TABLE data_science_jobs;

-- Dropping jobs_applied_table
DROP TABLE job_applied;

-- Outputs every row from the table
SELECT *
FROM data_science_jobs;