/*
Pregunta: Cuales son los mejores trabajos en la industria del data analisis
-Identificar el top 10 que estan disponibles en remoto
-Voy a hacer incapie en posteos sobre salarios espeficicos (removiendo NULLS)
*/

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
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10