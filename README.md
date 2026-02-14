# Introducción

📊 Analziando el mercado laboral de datos!  Este proyecto explora:

💰 Los trabajos mejor remunerados  
🔥 Las habilidades más demandadas  
📈 Dónde se cruzan la alta demanda y los altos salarios en analítica de datos  

🔍 Querys SQL? Podés verlas aca: [proyecto_sql_folder](/querys/)

---

# Contexto

Impulsado por el objetivo de comprender mejor el mercado laboral para Analistas de Datos, este proyecto nace del deseo de identificar las habilidades mejor pagadas y más demandadas, facilitando el camino para encontrar oportunidades laborales óptimas.

---

# Herramientas Utilizadas

Para este análisis profundo del mercado laboral de Analistas de Datos, utilicé las siguientes herramientas clave:

- **SQL:** La base de todo el análisis, permitiéndome consultar la base de datos y extraer insights relevantes.
- **PostgreSQL:** El sistema de gestión de base de datos elegido, ideal para manejar datos de ofertas laborales.
- **Visual Studio Code:** Mi herramienta principal para gestionar la base de datos y ejecutar consultas SQL.
- **Git & GitHub:** Esenciales para el control de versiones y compartir mis scripts SQL y análisis, asegurando seguimiento y colaboración.

---

# El Análisis

Cada consulta de este proyecto tuvo como objetivo investigar un aspecto específico del mercado laboral de Analistas de Datos.

---

## 1. Trabajos Mejor Pagados para Analistas de Datos

Para identificar los roles con mayor salario, filtré posiciones de Data Analyst por salario anual promedio y ubicación, enfocándome en trabajos remotos.

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
    job_title_short = 'Data Analyst' AND 
    job_location = 'Anywhere' AND 
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```

### Resultados destacados:

- **Amplio rango salarial:** Los 10 puestos mejor pagos van desde $184.000 hasta $650.000 anuales.
- **Empresas diversas:** Compañías como SmartAsset, Meta y AT&T ofrecen salarios elevados.
- **Variedad de títulos:** Desde Data Analyst hasta Director of Analytics, mostrando distintas especializaciones.

---

## 2. Habilidades para los Trabajos Mejor Pagados

Para entender qué habilidades se requieren en los puestos mejor remunerados, uní las ofertas laborales con la tabla de habilidades por medio de un JOIN.

```sql
WITH top_paying_jobs AS (
    SELECT	
        job_id,
        job_title,
        salary_year_avg,
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
)

SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;
```

### Habilidades más repetidas:

- **SQL** (8 menciones)
- **Python** (7 menciones)
- **Tableau** (6 menciones)

Otras habilidades relevantes: **R**, **Snowflake**, **Pandas**, **Excel**.

---

## 3. Habilidades Más Demandadas

```sql
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' 
    AND job_work_from_home = True 
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;
```

| Habilidad | Demanda |
|-----------|---------|
| SQL       | 7291    |
| Excel     | 4611    |
| Python    | 4330    |
| Tableau   | 3745    |
| Power BI  | 2609    |

### Conclusión:

- **SQL y Excel** siguen siendo fundamentales.
- **Python, Tableau y Power BI** reflejan la importancia del análisis técnico y la visualización.

---

## 4. Habilidades Mejor Pagadas

```sql
SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True 
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;
```

| Habilidad     | Salario Promedio ($) |
|--------------|---------------------:|
| pyspark      | 208,172 |
| bitbucket    | 189,155 |
| couchbase    | 160,515 |
| watson       | 160,515 |
| datarobot    | 155,486 |
| gitlab       | 154,500 |
| swift        | 153,750 |
| jupyter      | 152,777 |
| pandas       | 151,821 |
| elasticsearch| 145,000 |

### Insights:

- Alto valor en **Big Data y Machine Learning**
- Importancia creciente del **Cloud Computing**
- Cruce fuerte entre análisis y **Data Engineering**

---

## 5. Habilidades Más Óptimas para Aprender

```sql
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True 
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
```

| Skill ID | Habilidad | Demanda | Salario Promedio ($) |
|----------|------------|----------|---------------------:|
| 8        | go         | 27       | 115,320 |
| 234      | confluence | 11       | 114,210 |
| 97       | hadoop     | 22       | 113,193 |
| 80       | snowflake  | 37       | 112,948 |
| 74       | azure      | 34       | 111,225 |
| 77       | bigquery   | 13       | 109,654 |
| 76       | aws        | 32       | 108,317 |

---


