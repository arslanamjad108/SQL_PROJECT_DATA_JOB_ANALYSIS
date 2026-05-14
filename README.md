# 📊 Data Analyst Job Market Analysis — SQL Project

> A deep-dive into the data analyst job market using SQL: uncovering the top-paying roles, the skills behind them, and the most strategic skills to learn.

---

## 🔎 Introduction

The data job market moves fast, and as someone building a career in data analytics I wanted to cut through the noise and let the data speak for itself. This project uses SQL to explore real-world job-posting data and answer the questions that actually matter to a job seeker: **Where are the high-paying roles? What skills do they require? And which skills give the best return on the time invested in learning them?**

All of the SQL queries that power this analysis live in the [`project_sql`](/project_sql/) folder.

---

## 📖 Background

This project was built while working through an SQL course for data analytics, with the goal of turning classroom concepts into a portfolio-quality analysis. The motivation was simple: instead of guessing which skills to prioritise, I wanted to **pinpoint the top-paid and in-demand skills** so that anyone — including me — could navigate the job market more effectively.

### The data

The dataset contains thousands of job postings and includes details such as job titles, salaries, locations, work-from-home status, and the specific skills attached to each role. It is organised into four related tables:

| Table | Description |
| ----- | ----------- |
| `job_postings_fact` | The central fact table — one row per job posting (title, location, salary, posted date, etc.) |
| `company_dim` | Company details, joined via `company_id` |
| `skills_dim` | The master list of skills and their type |
| `skills_job_dim` | A bridge table linking each job to its required skills |

### The questions I wanted to answer

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most *optimal* skills to learn — high demand **and** high pay?

---

## 🛠️ Tools I Used

To carry out this analysis I relied on a focused, industry-standard toolkit:

- **SQL** — the backbone of the project, used to query the database and surface insights.
- **PostgreSQL** — the database engine chosen to host and manage the job-posting data.
- **Visual Studio Code** — my editor of choice for writing and running SQL queries.
- **Git & GitHub** — for version control, tracking changes, and sharing the project publicly.

---

## 📈 The Analysis

Each query in this project targets one specific question about the data analyst job market. Here is how I approached each one.

> **Note:** All result tables below come from running the queries against the PostgreSQL database; the raw output is saved in [`project_sql/Queries_Output`](/project_sql/Queries_Output/).

### 1. Top-Paying Data Analyst Jobs

To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote ("Anywhere") jobs. This query highlights the top-paying opportunities in the field.

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_location = 'Anywhere'
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```

**Results:**

| Job Title | Company | Location | Schedule | Avg. Salary |
| --------- | ------- | -------- | -------- | ----------- |
| Data Analyst | Mantys | Anywhere | Full-time | $650,000 |
| Director of Analytics | Meta | Anywhere | Full-time | $336,500 |
| Associate Director- Data Insights | AT&T | Anywhere | Full-time | $255,830 |
| Data Analyst, Marketing | Pinterest Job Advertisements | Anywhere | Full-time | $232,423 |
| Data Analyst (Hybrid/Remote) | Uclahealthcareers | Anywhere | Full-time | $217,000 |
| Principal Data Analyst (Remote) | SmartAsset | Anywhere | Full-time | $205,000 |
| Director, Data Analyst - HYBRID | Inclusively | Anywhere | Full-time | $189,309 |
| Principal Data Analyst, AV Performance Analysis | Motional | Anywhere | Full-time | $189,000 |
| Principal Data Analyst | SmartAsset | Anywhere | Full-time | $186,000 |
| ERM Data Analyst | Get It Recruit - Information Technology | Anywhere | Full-time | $184,000 |

> **Insights:**
> - **Wide salary range:** the top 10 remote data analyst roles span from $184,000 all the way to $650,000 — Mantys sits as a striking outlier at the very top.
> - **Diverse employers:** household names like Meta, AT&T, and Pinterest appear alongside specialised firms such as SmartAsset (which lands twice) and Motional, showing high pay is not limited to big tech.
> - **Seniority drives pay:** the titles range from plain "Data Analyst" to "Principal Data Analyst" and "Director of Analytics" — the more senior the role, the higher the ceiling.

### 2. Skills for Top-Paying Jobs

To understand *what* makes those top roles pay so well, I used a CTE to take the top-paying jobs from Query 1 and joined them to the skills tables, revealing the specific skills employers attach to high-salary postings.

```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg
    FROM
        job_postings_fact
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_location = 'Anywhere'
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)
SELECT
    top_paying_jobs.job_id,
    job_title,
    salary_year_avg,
    skills
FROM
    top_paying_jobs
    INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;
```

**Results:** (skill frequency across the 8 top-paying jobs that list skills)

| Skill | Count among top-paying jobs |
| ----- | --------------------------- |
| SQL | 8 |
| Python | 7 |
| Tableau | 6 |
| R | 4 |
| Excel | 3 |
| Snowflake | 3 |
| Pandas | 3 |
| Azure, AWS, Power BI, Oracle, Go, NumPy, GitLab, Bitbucket, Atlassian, Jira, Confluence | 2 each |

> **Insights:**
> - **SQL is the common thread:** it appears in every single one of the top-paying jobs that list skills — it is effectively the price of entry.
> - **Python and Tableau follow closely** (7 and 6 mentions), confirming a core "query → analyse → visualise" stack behind high salaries.
> - **A long tail of specialised tools** — Snowflake, AWS, Azure, Git-family tools — shows the highest earners often pair analyst fundamentals with engineering-adjacent skills.

### 3. Most In-Demand Skills for Data Analysts

This query counts how often each skill appears across data analyst postings, surfacing the five skills with the highest demand in the market.

```sql
SELECT
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM
    job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst'
GROUP BY
    skills_dim.skills
ORDER BY
    demand_count DESC
LIMIT 5;
```

**Results:**

| Skill | Demand Count |
| ----- | ------------ |
| SQL | 92,628 |
| Excel | 67,031 |
| Python | 57,326 |
| Tableau | 46,554 |
| Power BI | 39,468 |

> **Insights:**
> - **SQL is in a league of its own** — with 92,628 mentions it is the single most requested skill by a wide margin.
> - **Excel is still essential**, sitting comfortably in second place and proving that classic tools have not gone anywhere.
> - **Programming and BI tools round out the top five** — Python, Tableau, and Power BI — showing employers want analysts who can both manipulate data and present it.

### 4. Skills Based on Salary

Here I calculated the average salary associated with each individual skill to reveal which skills are the most financially rewarding to acquire.

```sql
SELECT
    skills_dim.skills AS skill,
    ROUND(AVG(job_postings_fact.salary_year_avg), 2) AS avg_salary
FROM
    job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst'
    AND job_postings_fact.salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skills
ORDER BY
    avg_salary DESC;
```

**Results (top 10 of 178 skills):**

| Skill | Average Salary |
| ----- | -------------- |
| SVN | $400,000 |
| Solidity | $179,000 |
| Couchbase | $160,515 |
| DataRobot | $155,486 |
| Golang | $155,000 |
| MXNet | $149,000 |
| dplyr | $147,633 |
| VMware | $147,500 |
| Terraform | $146,734 |
| Twilio | $138,500 |

> **Insights:**
> - **The top-paying skills are highly specialised** — version control internals (SVN), blockchain (Solidity), big-data stores (Couchbase), ML platforms (DataRobot, MXNet) and DevOps tooling (Terraform, VMware).
> - **These are not everyday analyst tools.** They tend to come from engineering, machine learning, and infrastructure work — and several (like SVN at $400,000) sit on small sample sizes, so the figures should be read as directional rather than typical.
> - **The takeaway:** raw salary alone is a misleading guide to what to learn — which is exactly why Query 5 exists.

### 5. The Most Optimal Skills to Learn

The final query combines demand and salary into a single view. Using two CTEs — one for demand count and one for average salary — it identifies skills that are both highly requested **and** well paid: the strategic sweet spot for career development.

```sql
WITH skills_demand AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM
        job_postings_fact
        INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
        INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_postings_fact.job_title_short = 'Data Analyst'
        AND job_postings_fact.salary_year_avg IS NOT NULL
        AND job_postings_fact.job_work_from_home = TRUE
    GROUP BY
        skills_dim.skill_id
),
average_salary AS (
    SELECT
        skills_job_dim.skill_id,
        AVG(job_postings_fact.salary_year_avg) AS avg_salary
    FROM
        job_postings_fact
        INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    WHERE
        job_postings_fact.job_title_short = 'Data Analyst'
        AND job_postings_fact.salary_year_avg IS NOT NULL
        AND job_postings_fact.job_work_from_home = TRUE
    GROUP BY
        skills_job_dim.skill_id
)
SELECT
    skills_demand.skills,
    skills_demand.demand_count,
    ROUND(average_salary.avg_salary, 2) AS avg_salary
FROM
    skills_demand
    INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
ORDER BY
    demand_count DESC,
    avg_salary DESC
LIMIT 10;
```

**Results:** (remote roles with listed salaries)

| Skill | Demand Count | Average Salary |
| ----- | ------------ | -------------- |
| SQL | 398 | $97,237 |
| Excel | 256 | $87,288 |
| Python | 236 | $101,397 |
| Tableau | 230 | $99,288 |
| R | 148 | $100,499 |
| Power BI | 110 | $97,431 |
| SAS | 63 | $98,902 |
| PowerPoint | 58 | $88,701 |
| Looker | 49 | $103,795 |

> **Insights:**
> - **SQL is the safest bet** — the highest demand by far (398 postings) paired with a healthy ~$97K average salary.
> - **Python is the standout all-rounder** — strong demand (236) combined with one of the highest average salaries (~$101K).
> - **Looker pays the most** (~$103.8K) but with much lower demand, while **Excel and PowerPoint are widely requested but pull the average salary down** — common tools rarely command a premium.
> - **The sweet spot:** SQL + Python + a BI tool (Tableau or Power BI) covers high demand *and* above-average pay.

---

## 🧠 What I Learned

This project pushed my SQL well beyond the basics. Along the way I became comfortable with:

- **Complex joins** — confidently combining the fact and dimension tables to connect jobs, companies, and skills.
- **Common Table Expressions (CTEs)** — using the `WITH` clause to break complex problems into readable, reusable building blocks, especially in Queries 2 and 5.
- **Aggregate functions and grouping** — using `COUNT()`, `AVG()`, `ROUND()` and `GROUP BY` to turn thousands of rows into clear, summarised insight.
- **Filtering with purpose** — applying `WHERE` conditions to focus the analysis on exactly the right subset of data (remote roles, postings with listed salaries, specific job titles).
- **Turning questions into queries** — the most valuable skill of all: translating a real business question into structured SQL that actually answers it.

---

## ✅ Conclusions

This analysis turned a raw job-postings database into a practical guide for navigating the data analyst job market. The results paint a clear picture of where the high-paying roles are, what skills sit behind them, and — most importantly — which skills are worth prioritising because they combine strong demand with strong pay.

> **Final summary:** If there is one recommendation for an aspiring data analyst, it is this: **master SQL first.** It tops the demand charts (92,628 mentions), appears in every high-paying role analysed, and offers a solid salary floor. From there, **Python is the highest-leverage second skill** — strong demand and one of the best average salaries — and pairing it with a visualisation tool like **Tableau or Power BI** covers the bulk of the high-value market. The genuinely top-*paying* skills (SVN, Solidity, DataRobot, and the like) are tempting on paper, but their tiny sample sizes and niche use cases make them a poor starting point. The smart play is to build on the high-demand, high-salary core revealed by Query 5, then specialise later.

More broadly, this project was a reminder that SQL is not just about syntax — it is about asking sharp questions and being disciplined about how you answer them. It strengthened my problem-solving and analytical foundations, and gave me a repeatable framework I can point at any dataset in the future.

---

### 📁 Project Structure

```
SQL_PROJECT_DATA_JOB_ANALYSIS/
├── project_sql/                 # The 5 analysis queries
│   ├── 1_top_paying_jobs.sql
│   ├── 2_top_paying_job_skills.sql
│   ├── 3_top_demanded_skills.sql
│   ├── 4_top_paying_skills.sql
│   ├── 5_optimal_skills.sql
│   └── Queries_Output/          # CSV result sets for each query
├── sql_load/                    # Database & table setup scripts
├── csv_files/                   # Raw dataset
├── Basic_SQL_Practice/          # Fundamentals practice
├── Advanced_SQL_Practice/       # Advanced topics practice
└── README.md
```
