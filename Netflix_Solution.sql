DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    types        VARCHAR(10),
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
--> ALTER table netflix modify listed_in varchar(55) ; 
-->Info of datatypes of columns
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'netflix' AND TABLE_NAME = 'netflix';
---------------------------------- 
-->exported data into sql by using vs code pandas
select count(*) from netflix   
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'netflix' AND TABLE_NAME = 'netflix'; 

select count(*) as total_count from netflix ;
select * from netflix

select distinct type from netflix 
-- 15 Business Problems & Solutions

1. Count the number of Movies vs TV Shows
select  type , count(*) as total_content from netflix 
group by type ;

--- 2. Find the most common rating for movies and TV shows
select type,rating
from
( select type , rating, 
count(*) ,
rank() over(partition by type order by count(*) desc) as ranking
from netflix 
group by type,rating 
order by count(rating) desc ) as Table1 
where ranking = 1

-- 3. List all movies released in a specific year (e.g., 2020)
select * from netflix
where release_year=2020 and type = 'Movie'

-- 4. Find the top 5 countries with the most content on Netflix

 CREATE TABLE numbers (n INT);
-- Insert enough numbers to cover the maximum number of elements in the delimited strings
INSERT INTO numbers (n) VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10);

 SELECT 
    SUBSTRING_INDEX(SUBSTRING_INDEX(country, ',', numbers.n), ',', -1) AS country_part , count(show_Id) as total_content
FROM 
    netflix
JOIN 
    numbers 
ON 
    CHAR_LENGTH(country) - CHAR_LENGTH(REPLACE(country, ',', '')) >= numbers.n - 1 
    group by country_part 
    order by total_content desc limit 5 
    
-- 5. Identify the longest movie
select  * from netflix
where type ='Movie' and 
duration = (select max(duration) from netflix) 


----- 6. Find content added in the last 5 years
SELECT DATE_SUB(CURRENT_DATE, INTERVAL 5 YEAR) AS date_sub_result;
SELECT * 
from netflix
where STR_TO_DATE(date_added,'%M %d, %Y') >= DATE_SUB(CURRENT_DATE, INTERVAL 5 YEAR);

------ 7. Find all the movies/TV shows by director 'Rajiv Chilaka'! ;
select * from netflix 
where director like '%Rajiv Chilaka%' ;

-- 8. List all TV shows with more than 5 seasons 
select * from netflix
where duration >= '5 Seasons' and type = 'TV Show' ;
-- select substring_index(duration,' ',1) as Season from netflix
select * from netflix 
where type ='TV Show' and
substring_index(duration , ' ',1) >=5

9. Count the number of content items in each genre 

 SELECT 
    show_Id, 
    SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', numbers.n), ',', -1) AS Genre
FROM 
    netflix 
JOIN 
    numbers 
ON 
    CHAR_LENGTH(listed_in) - CHAR_LENGTH(REPLACE(listed_in, ',', '')) >= numbers.n - 1
    
 
-- 10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

select  
extract(year from STR_TO_DATE(date_added,'%M %d, %Y')) as Year 
,count(*), 
Round(count(*)/(select count(*) from netflix where country ='India')*100,2) as Avg_content
from netflix 
where country = 'India'
group by Year 
order by count(*) desc limit 5;

--- 11.List all movies that are documentaries 

select * from netflix
where listed_in like '%Documentaries%'  ;

-- 12 Find all content without a director
select * from netflix 
where director is null

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
select * 
from netflix 
where cast like '%Salman Khan%' and
release_year >=  EXTRACT(YEAR FROM DATE_SUB(CURRENT_DATE, INTERVAL 10 YEAR)) 

SELECT EXTRACT(YEAR FROM DATE_SUB(CURRENT_DATE, INTERVAL 10 YEAR)) AS Years ;

SELECT 
    EXTRACT(YEAR FROM DATE_SUB(CURRENT_DATE, INTERVAL 10 YEAR)) AS Years;

14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
-- 15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category 
with table1 
as 
(select *,
CASE
  WHEN 
    description like '%kill%' or
    description like '%violence%' 
    THEN 'Bad Content' 
    ELSE 'Good Content'
    END Category 
From netflix )
select 
category , count(*) as Total_content
from table1 
group by category ;

