/*
**Question: What are the most in-demand skills for data analysts?**

- Identify the top 5 in-demand skills for a data analyst.
- Focus on all job postings.
- Why? Retrieves the top 5 skills with the highest demand in the job market,
  providing insights into the most valuable skills for job seekers.
*/

-- What my Section of the SQL Code does
/*
1. Finds all Data Analyst job postings
2. Connects those jobs to required skills
3. Counts how many times each skill appears
4. Sorts skills from highest demand to lowest
5. Shows the top 5
*/

-- Identifies the top 5 most demanded skills for the Data Analyst job postings
SELECT
  skills_dim.skills,
  COUNT(skills_job_dim.job_id) AS demand_count
FROM
  job_postings_fact
  INNER JOIN
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
  INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
  -- Filters job titles for 'Data Analyst' roles
  job_postings_fact.job_title_short = 'Data Analyst'
	-- AND job_work_from_home = True -- optional to filter for remote jobs
GROUP BY
  skills_dim.skills
ORDER BY
  demand_count DESC
LIMIT 5;

-- The above section of the SQL Code can be modified/rectified to get the other
-- information like for Software Engineer, Business Analyst, Data Scientist etc.