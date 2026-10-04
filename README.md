# Netflix Movies and TV shows Data Analysis using SQL

![Netflix_logo](https://github.com/Hari22346/Netflix_SQL_Project/blob/main/Netflix.logo.png)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
DROP TABLE IF EXISTS netflix_db1;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
select 
	type,count(*) as total_content
from netflix
group by type;
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
select
	type,
	rating
from
(
Select 
	type,
	rating,
	count(*),
	rank() over(partition by type order by count(*) desc) as ranking
from netflix
group by 1,2
) as t1
where ranking=1;
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
select * from netflix
	where type='Movie'
	and release_year=2020;
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
select
	unnest(string_to_array(country, ',')) as new_country,
	count(show_id) as total_content
from netflix
group by 1
order by 2 desc
limit 5;
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
SELECT * 
FROM netflix
WHERE TO_DATE(date_added, 'DD-Mon-YY') >= CURRENT_DATE - INTERVAL '5 years';
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
select * from netflix
where director ILIKE '%Rajiv Chilaka%'
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
select * from netflix
where 
	type='TV Show'
	AND
	split_part(duration, ' ',1)::numeric > 5;
```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
select
	unnest(string_to_array(listed_in, ',')) as genre,
	count(show_id) as total_content
from netflix
group by 1;
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql
select 
	extract(year from to_date(date_added, 'DD-Mon_YY')) as year,
	count(*),
	round(count(*)::numeric/(select count(*) from netflix where country='India')::numeric * 100,2) as avg_content_per_year
from netflix
where country='India'
group by 1
;
```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries

```sql
select * from netflix
where listed_in ILIKE '%documentaries%';
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
select * from netflix
where director is null;
```

**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
select * from netflix
where
	casts LIKE '%Salman Khan%'
	AND 
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
select
	unnest(STRING_TO_ARRAY(casts, ',')) as actor,
	count(*) as total_content
from netflix
where country ILIKE '%india'
group by 1
order by 2 desc
LIMIT 10
;
```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
--Based on Movies and TV shows
select
    category,
	type,
    count(*) as content_count
from (
    select
		*,
        case 
            when description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            else 'Good'
        END as category
    from netflix
) as categorized_content
group by 1,2
order by 2
```

```sql
--Based on total
with new_table
as
(
select *,
 	case
	 when 
	 	description ILIKE '%kill%' or
		 description ILIKE '%violence%' then 'Bad'
		 else 'Good'
	end category
from netflix
)
select category,
	count(8) as total_content
from new_table
group by 1
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.

## 👨‍💻 Author

**R Hari Prasanth**

Electronics and Communication Engineering Graduate

- LinkedIn: www.linkedin.com/in/r-hari-prasanth-54369a376
- GitHub:   https://github.com/Hari22346

---

## ⭐ Project

If you find this project useful, consider giving the repository a **star ⭐**.

---

## 📄 License

This project is created for **educational and portfolio purposes**.
