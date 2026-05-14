 
 /*
 Question: What are the top skills based on salary?** 

- Look at the average salary associated with each skill for Data Analyst positions.
- Focuses on roles with specified salaries, regardless of location.
- Why? It reveals how different skills impact salary levels for Data Analysts
  and helps identify the most financially rewarding skills to acquire or improve.
*/

-- I solved this query problem step-wise, and this is what I followed
/*
1. Find the Data Analyst job postings
2. Connects them to required skills
3. Calculate the average salary for each skill
4. Sort skills by highest average salary
*/
-- Calculates the average salary for job postings by individual skill 
SELECT
  skills_dim.skills AS skill, 
  ROUND(AVG(job_postings_fact.salary_year_avg),2) AS avg_salary
FROM
  job_postings_fact
	INNER JOIN
	  skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
	INNER JOIN
	  skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
  job_postings_fact.job_title_short = 'Data Analyst' 
  AND job_postings_fact.salary_year_avg IS NOT NULL 
	-- AND job_work_from_home = True  -- optional to filter for remote jobs
GROUP BY
  skills_dim.skills 
ORDER BY
  avg_salary DESC;

-- Top Paying skills for the Data Analyst Role
