-- Netflix Project
drop table if exists netflix;

create table netflix(
show_id varchar(6),
type varchar(10),
title varchar(150),
director varchar(208),
casts varchar(1000),
country varchar(150),
date_added varchar(50),
release_year int,
rating varchar(10),
duration varchar(15),
listed_in varchar(100),
description varchar(250)
);

select * from netflix;

select count(*) as total_content from netflix;

select distinct type from netflix;


select * from netflix

-- 15 Business problems

--1. count the number of movies vs TV shows

select 
	type,count(*) as total_content
from netflix
group by type


-- 2.Find the most common rating for movies and TV shows
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
where ranking=1


-- 3. List all movies released in a specific year(e.g., 2020)

select * from netflix
	where type='Movie'
	and release_year=2020



-- 4. Find the top 5 countries with the most content on Netfix

select
	unnest(string_to_array(country, ',')) as new_country,
	count(show_id) as total_content
from netflix
group by 1
order by 2 desc
limit 5

-- 5. Identify the longest movie

select * from netflix
where 
	type='Movie'
	and
	duration = (select max(duration) from netflix)

-- 6. Find content added in last 5 years

SELECT * 
FROM netflix
WHERE TO_DATE(date_added, 'DD-Mon-YY') >= CURRENT_DATE - INTERVAL '5 years'


-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'

select * from netflix
where director ILIKE '%Rajiv Chilaka%'


-- 8. List all Tv shows with more than 5 seasons

select * from netflix
where 
	type='TV Show'
	AND
	split_part(duration, ' ',1)::numeric > 5


-- 9. Count the number of content items in each genre

select
	unnest(string_to_array(listed_in, ',')) as genre,
	count(show_id) as total_content
from netflix
group by 1



-- 10. Find each year and the average numbers of content release by India on netflix.
-- return top 5 year with highest avg content release!

select 
	extract(year from to_date(date_added, 'DD-Mon_YY')) as year,
	count(*),
	round(count(*)::numeric/(select count(*) from netflix where country='India')::numeric * 100,2) as avg_content_per_year
from netflix
where country='India'
group by 1


-- 11. List all movies that are documentaries

select * from netflix
where listed_in ILIKE '%documentaries%'


-- 12. Find all content without a director

select * from netflix
where director is null


-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

select * from netflix
where
	casts LIKE '%Salman Khan%'
	AND 
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10
	



-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

select
	unnest(STRING_TO_ARRAY(casts, ',')) as actor,
	count(*) as total_content
from netflix
where country ILIKE '%india'
group by 1
order by 2 desc
LIMIT 10


/*
15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.
*/

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
)