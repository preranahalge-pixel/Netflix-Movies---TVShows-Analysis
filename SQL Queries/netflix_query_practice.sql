CREATE DATABASE netflix;

DROP TABLE IF EXISTS netflix;

CREATE TABLE netflix(
	show_id VARCHAR(10),
	title TEXT,
	type VARCHAR(200),
	director TEXT,
	actors TEXT,
	country TEXT,
	date_added TEXT,
	release_year INT,
	rating VARCHAR(10),
	duration VARCHAR(50),
	listed_in VARCHAR(100),
	description TEXT
);

SELECT * FROM netflix;

COPY netflix(show_id, type, title, director, actors, country, date_added, release_year, rating, duration, listed_in, description)
FROM 'C:\MyFolder\netflix_cleaned.csv'
CSV HEADER;

TRUNCATE TABLE netflix RESTART IDENTITY;

-- Level 1: Basic SQL

-- 1. Display all records from the table.
SELECT * FROM netflix;

-- 2. Show only the title, type, and release_year columns.
SELECT title, type, release_year FROM netflix;

-- 3. Find all content released after 2020.
SELECT title, type, release_year FROM netflix
WHERE release_year > 2020;

-- 4. Show all movies only.
SELECT title, type 
FROM netflix
WHERE type = 'Movie';

-- 5. Show all TV Shows only.
SELECT title, type 
FROM netflix
WHERE type = 'TV Show';

-- 6. Find Netflix content with rating 'PG-13'.
SELECT title, type, rating
FROM netflix
WHERE rating = 'PG-13';

-- 7. Display movies released between 2015 and 2022.
SELECT title, type, release_year 
FROM netflix
WHERE type = 'Movie'
	AND release_year  BETWEEN '2015' AND '2022';

-- 8. Find content added after January 1, 2021.
SELECT title, type, date_added
FROM netflix
WHERE date_added > '01-01-2021';

-- 9. Sort all titles alphabetically.
SELECT title, type
FROM netflix
GROUP BY title, type
ORDER BY title;

-- 10. Display top 10 newest releases.
SELECT title, type, release_year 
FROM netflix
ORDER BY release_year DESC
LIMIT 10;

-- Level 2: Filtering & Conditions

-- 11. Find content from India.
SELECT title, type, country
FROM netflix
WHERE country = 'India';

-- 12. Find content from United States.
SELECT title, type, country
FROM netflix
WHERE country ='United States'; 

-- 13. Show titles where the type is Movie and release year is after 2018.
SELECT title, type, release_year 
FROM netflix
WHERE type = 'Movie'
	AND release_year > 2018;

-- 14. Find TV Shows with rating TV-MA.
SELECT title, type, rating
FROM netflix
WHERE type = 'TV Shows'
	AND	rating = 'TV-MA';

-- 15. Show content where director name is missing (NULL).
SELECT title, type, director
FROM netflix
WHERE director is NULL;

SELECT title, type, director
FROM netflix
WHERE director = 'Unknown';

-- 16. Find titles containing the word "Love".
SELECT title, type
FROM netflix
WHERE title LIKE '%Love%';

-- 17. Find titles starting with letter A.
SELECT title, type
FROM netflix
WHERE title LIKE 'A%';

-- 18. Find descriptions containing "family".
SELECT title, type, description
FROM netflix
WHERE description LIKE '%family%';

-- 19. Display records where country is not null.
SELECT title, type, country
FROM netflix
WHERE country IS NOT NULL
	AND country <> 'Unknown';
	
-- 20. Find content added in December.
SELECT title, type, date_added
FROM netflix
WHERE date_added <> 'Unknown'
  AND EXTRACT(MONTH FROM CAST(date_added AS DATE)) = 12;


-- Level 3: Aggregate Functions
-- 21. Count total Netflix records.
SELECT COUNT(*) AS total_records
FROM netflix;

-- 22. Count total Movies and TV Shows.
SELECT type, COUNT(*) AS total_count
FROM netflix
GROUP BY type;

-- 23. Find the average release year.
SELECT AVG(release_year) AS average_release_year
FROM netflix;

-- 24. Find the oldest movie release year.
SELECT MIN(release_year) AS oldest_movie
FROM netflix;

-- 25. Find the latest release year.
SELECT MAX(release_year) AS latest_movie
FROM netflix;

-- 26. Count content available in each rating category.
SELECT rating, COUNT(*) AS total_content
FROM netflix
GROUP BY rating
ORDER BY total_content DESC;

-- 27. Count how many titles belong to India.
SELECT country, COUNT(*) AS total_titles
FROM netflix
WHERE country LIKE '%India%'
GROUP BY country;

SELECT COUNT(*) AS total_titles_india
FROM netflix
WHERE country LIKE '%India%';

-- 28. Find total number of Movies.
SELECT COUNT(*) AS total_movies
FROM netflix
WHERE type = 'Movie';
 
-- 29. Find total number of TV Shows.
SELECT COUNT(*) AS total_TV_Shows
FROM netflix
WHERE type = 'TV Show';

-- 30. Find how many titles were added each year.
SELECT EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year_added,
       COUNT(*) AS total_titles
FROM netflix
WHERE date_added <> 'Unknown'
GROUP BY year_added
ORDER BY year_added;

-- Level 4: GROUP BY & HAVING
-- 31. Count titles by country.
SELECT country, COUNT(*) AS total_titles
FROM netflix
WHERE country <> 'Unknown'
GROUP BY country
ORDER BY  total_titles DESC;

-- 32. Find the top 10 countries with most content.
SELECT country, COUNT(*) AS total_CONTENT 
FROM netflix
WHERE country <> 'Unknown'
GROUP BY country
ORDER BY  total_CONTENT DESC
LIMIT 10;

-- 33. Count movies released each year.
SELECT title, type, EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year_added
FROM netflix
WHERE type = 'Movie'
GROUP BY title, type, date_added
ORDER BY date_added DESC;

-- 34. Find years having more than 50 releases.
SELECT release_year,
       COUNT(*) AS total_releases
FROM netflix
GROUP BY release_year
HAVING COUNT(*) > 50
ORDER BY release_year;

-- 35. Count content by rating.
SELECT rating, COUNT(*) AS total_content
FROM netflix
GROUP BY rating
ORDER BY total_content DESC ;

-- 36. Find directors who created more than 5 titles.
SELECT director, COUNT(*) total_title
FROM netflix
WHERE director <> 'Unknown'
GROUP BY director
HAVING COUNT(*) > 5
ORDER BY total_title DESC;

-- 37. Find top 10 directors with maximum content.
SELECT director, COUNT(*) total_title
FROM netflix
WHERE director <> 'Unknown' 
GROUP BY director
ORDER BY total_title DESC
LIMIT 10;

-- 38. Find content count by type.
SELECT type, COUNT(*) AS total_content
FROM netflix
GROUP BY type
ORDER BY total_content DESC;

-- 39. Find years with more than 100 Netflix additions.
SELECT EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD,YYYY')) AS year_added,
			COUNT(*) AS total_addition
FROM netflix
WHERE date_added IS NOT NULL
	AND date_added != 'Unknown'
GROUP BY year_added
HAVING COUNT(*) > 100
ORDER BY total_addition DESC;

-- 40. Find ratings having more than 20 shows.
SELECT rating, type, COUNT(*) AS total_shows
FROM netflix
WHERE type = 'TV Show'
GROUP BY type, rating
HAVING COUNT(*) > 20
ORDER BY total_shows DESC;

-- Level 5: String Functions
-- 41. Convert all titles into uppercase.
SELECT UPPER(title) AS uppercase_title
FROM netflix;

-- 42. Find length of each movie title.
SELECT title,
		LENGTH(title) AS title_length
FROM netflix
WHERE type = 'Movie';

-- 43. Extract first 5 characters of title.
SELECT title,
		LEFT(title, 5) AS short_title
FROM netflix;

-- 44. Replace word "Love" with "Romance" in title.
SELECT title,
		REPLACE(title, 'Love', 'Romance') AS replace_title
FROM netflix
WHERE title LIKE '%Love%';

-- 45. Find titles ending with "Man".
SELECT title
FROM netflix
WHERE title LIKE '%Man'; 

-- 46. Count number of characters in descriptions.
SELECT title, description,
       LENGTH(description) AS description_length
FROM netflix;

-- 47. Extract release decade (Example: 1990s, 2000s).
SELECT title, release_year,
			CONCAT((release_year / 10)* 10, 's') AS decade
FROM netflix;

-- 48. Show titles and director names together.
SELECT CONCAT(title, ' - ', director) AS titlr_dir
FROM netflix; 

-- 49. Remove spaces from title.
SELECT title,
	REPLACE(title, ' ', '') AS no_space
FROM netflix;

-- 50. Find number of words in description.
SELECT title,
       LENGTH(description)
	   - LENGTH(REPLACE(title, ' ', ''))+1
	   AS word_count
FROM netflix;

-- Level 6: Date Functions
-- 51. Extract year from date_added.
SELECT EXTRACT(YEAR FROM TO_DATE(date_added, 'Month, DD YYYY')) AS year_added
FROM netflix
WHERE date_added IS NOT NULL
	AND date_added <> 'Unknown';
	
-- 52. Extract month from date_added.
SELECT TO_CHAR(TO_DATE(date_added, 'Month, DD YYYY'), 'MONTH') AS month_added
FROM netflix
WHERE date_added IS NOT NULL
	AND date_added <> 'Unknown';
	
-- 53. Find content added in 2022.
SELECT title, date_added
FROM netflix
WHERE EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) = 2021
AND date_added <> 'Unknown';
	
-- 54. Count content added each month.
SELECT TO_CHAR(TO_DATE(date_added, 'Month DD, YYYY'), 'Month') AS Month_added,
		COUNT(*) AS total_content
FROM netflix
WHERE date_added <> 'Unknown'
GROUP BY date_added
ORDER BY total_content DESC;

-- 55. Find the latest content added to Netflix.
SELECT title, date_added
FROM netflix
WHERE date_added <> 'Unknown'
AND TO_DATE(date_added, 'Month DD, YYYY') =
(
    SELECT MAX(
        TO_DATE(date_added, 'Month DD, YYYY')
    )
    FROM netflix
    WHERE date_added <> 'Unknown'
);

-- 56. Find how many titles were added on weekends.
SELECT COUNT(*) AS weekend_titles
FROM netflix
WHERE date_added <> 'Unknown'
AND EXTRACT(DOW FROM TO_DATE(date_added, 'Month DD, YYYY'))
IN (0, 6);

-- 57. Find difference between current year and release year.
SELECT title,
       release_year,
       EXTRACT(YEAR FROM CURRENT_DATE)
       - release_year AS year_difference
FROM netflix;

-- 58. Show content added in the last 3 years.
SELECT title, date_added
FROM netflix
WHERE date_added <> 'Unknown'
AND TO_DATE(date_added, 'Month DD, YYYY')
>= CURRENT_DATE - INTERVAL '5 years';

-- 59. Find oldest content added on Netflix.
SELECT title, date_added
FROM netflix
WHERE date_added <> 'Unknown'
AND TO_DATE(date_added, 'Month DD, YYYY') =
(
    SELECT MIN(
        TO_DATE(date_added, 'Month DD, YYYY')
    )
    FROM netflix
    WHERE date_added <> 'Unknown'
);

-- 60. Display content added in January.
SELECT *
FROM netflix
WHERE date_added <> 'Unknown'
AND EXTRACT(MONTH FROM TO_DATE(date_added, 'Month DD, YYYY')) = 1;

-- Level 7: CASE WHEN
-- 61. Categorize release years:
/* Old (<2000)
Mid (2000–2015)
New (>2015) */
SELECT title, release_year,
	CASE 
		WHEN release_year < 2000 THEN 'OLD'
		WHEN release_year BETWEEN 2000 AND 2015 THEN 'MID'
		WHEN release_year > 2015 THEN 'NEW' 
	END AS category_release
FROM netflix;

-- 62. Create a column:
-- Movie → Film
-- TV Show → Series
SELECT title, type,
	CASE 
		WHEN type = 'Movie' THEN 'Flim'
		WHEN type = 'TV Show'THEN 'Series'
	END AS content_type
FROM netflix;
		
-- 63. Categorize ratings:
-- Family G, PG, TV-Y, TV-Y7, TV-G
-- Teen PG-13, TV-PG, TV-14
-- Adult R, NC-17, TV-MA
SELECT title, rating,
	CASE
		WHEN rating IN ('G', 'PG', 'TV-Y', 'TV-Y7', 'TV-G') THEN 'Family'
		WHEN rating IN ('PG-13', 'TV-PG', 'TV-14') THEN 'Teen'
		ELSE 'Adult'
	END AS audience_catrgory
FROM netflix;

-- 64. Create a popularity category based on release year.
/*Example logic:
Trending → after 2020
Popular → 2010–2020
Classic → before 2010 */
SELECT  title, release_year,
	CASE 
		WHEN release_year > 2020 THEN 'Trending' 
		WHEN release_year BETWEEN 2010 AND 2020 THEN 'Popular'
		ELSE 'Classic'
	END AS popularity_category
FROM netflix;

-- 65. Mark titles as Classic if released before 2000.
SELECT title, release_year,
    CASE
        WHEN release_year < 2000 THEN 'Classic'
        ELSE 'Modern'
     END AS movie_category
FROM netflix;

-- Level 8: Subqueries
-- 66. Find movies released after average release year.
SELECT type, release_year
FROM netflix 
WHERE type = 'Movie'
	AND release_year >
	(
		SELECT AVG(release_year)
		FROM netflix
		WHERE type = 'Movie'
	);
	
-- 67. Find titles having longest duration.
SELECT title, duration
FROM netflix
WHERE CAST(SPLIT_PART(duration, ' ', 1) AS INT)
=
(
    SELECT MAX(
        CAST(SPLIT_PART(duration, ' ', 1) AS INT)
    )
    FROM netflix
    WHERE type = 'Movie'
);

-- 68. Find countries with above-average content.
SELECT country,
			COUNT(*) AS total_titles
FROM netflix 
WHERE country <> 'Unknown'
GROUP BY country
HAVING COUNT(*) >
(
	SELECT AVG(country_count)
	FROM 
	(
		SELECT COUNT(*) country_count
		FROM netflix 
		WHERE country <> 'Unknown'
		GROUP BY country
	)sub
);


-- 69. Find directors with maximum titles.
SELECT director,
       COUNT(*) AS total_titles
FROM netflix
WHERE director IS NOT NULL
AND director <> 'Unknown'
GROUP BY director
HAVING COUNT(*)
=
(
    SELECT MAX(total_count)
    FROM
    (
        SELECT COUNT(*) AS total_count
        FROM netflix
        WHERE director IS NOT NULL
        AND director <> 'Unknown'
        GROUP BY director
    ) sub
);

-- 70. Find titles released in the same year as oldest movie.
SELECT title,
       release_year
FROM netflix
WHERE release_year =
(
    SELECT MIN(release_year)
    FROM netflix
    WHERE type = 'Movie'
);

-- 71. Find ratings having highest number of titles.
SELECT rating,
       COUNT(*) AS total_titles
FROM netflix
GROUP BY rating
HAVING COUNT(*) =
(
    SELECT MAX(rating_count)
    FROM
    (
        SELECT COUNT(*) AS rating_count
        FROM netflix
        GROUP BY rating
    ) AS rating_table
);


-- 72. Find movies longer than average duration.
SELECT title,
       duration
FROM netflix
WHERE type = 'Movie'
AND CAST(REPLACE(duration, ' min', '') AS INT)
>
(
    SELECT AVG(
        CAST(REPLACE(duration, ' min', '') AS INT)
    )
    FROM netflix
    WHERE type = 'Movie'
);

-- 73. Find titles added in same year as latest addition.
SELECT title, date_added
FROM netflix
WHERE date_added <> 'Unknown'
AND EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD, YYYY'))
=
(
    SELECT EXTRACT(YEAR FROM MAX(TO_DATE(date_added, 'Month DD, YYYY')))
    FROM netflix
    WHERE date_added <> 'Unknown'
);

-- 74. Find countries with least content.
SELECT country,
       COUNT(*) AS total_content
FROM netflix
WHERE country <> 'Unknown'
GROUP BY country
HAVING COUNT(*) =
(
    SELECT MIN(country_count)
    FROM
    (
        SELECT COUNT(*) AS country_count
        FROM netflix
        WHERE country <> 'Unknown'
        GROUP BY country
    ) AS country_table
);

-- 75. Find top-rated content category.
SELECT type, rating, COUNT(*) AS total_titles
FROM netflix
GROUP BY type, rating
HAVING COUNT(*) = (
    SELECT MAX(title_count)
    FROM (
        SELECT COUNT(*) AS title_count
        FROM netflix
        GROUP BY type, rating
    ) AS sub
);

-- Level 9: Window Functions (Advanced SQL)
-- 76. Rank movies by release year.
SELECT title, release_year,
       RANK() OVER(ORDER BY release_year DESC) AS movie_rank
FROM netflix
WHERE type = 'Movie';

-- 77. Find top 5 newest movies using ROW_NUMBER().
SELECT * 
FROM 
(
	SELECT title, release_year,
		ROW_NUMBER() OVER(ORDER BY release_year DESC) AS rn
	FROM netflix
	WHERE type = 'Movie'
)sub
WHERE rn <= 5;

-- 78. Rank directors based on content count.
SELECT director, COUNT(*) AS total_titles,
	RANK() OVER(ORDER BY COUNT(*) DESC) AS director_rank
FROM netflix
WHERE director <> 'Unknown'
GROUP BY director;
	
-- 79. Find cumulative count of releases year-wise.
SELECT release_year, COUNT(*) AS yearly_release,
	SUM(COUNT(*)) OVER(ORDER BY release_year) AS cumulative_count
FROM netflix
GROUP BY release_year
ORDER BY release_year; 

-- 80. Find previous and next release year using LAG() and LEAD().
SELECT title, release_year,
	LAG(release_year) OVER(ORDER BY release_year) AS previous_year,
	LEAD(release_year) OVER(ORDER BY release_year) AS next_year
FROM netflix;

-- 81. Find dense rank of movies by release year.
SELECT title, release_year,
	DENSE_RANK() OVER (ORDER BY release_year) AS densc_rank
FROM netflix
WHERE type = 'Movie';

-- 82. Show running total of content added.
SELECT title, date_added,
	COUNT(*) OVER(ORDER BY TO_DATE(date_added, 'Month DD, YYYY')) AS running_total
FROM netflix
WHERE date_added <> 'Unknown'; 

-- 83. Partition ratings and rank within rating.
SELECT title, rating, release_year, 
	RANK() OVER(PARTITION BY rating ORDER BY release_year DESC) AS rating_rank
FROM netflix;

-- 84. Find top movie in each year.
SELECT title, release_year
FROM
(
		SELECT title, release_year,
		ROW_NUMBER() OVER(PARTITION BY release_year ORDER BY title) AS rn
		FROM netflix
		WHERE type = 'Movie'
)sub
WHERE rn = 1; 

-- 85. Find latest content from each country.
SELECT country, title, release_year
FROM
(
	SELECT country,title, release_year, 
	ROW_NUMBER() OVER(PARTITION BY country ORDER BY release_year DESC) AS rn
	FROM netflix
	WHERE country <> 'Unknown'
)sub
WHERE rn = 1; 

-- Level 10: Expert Level Challenges
-- 86. Find top genre (listed_in) in Netflix.
SELECT listed_in, COUNT(*) AS total_title
FROM netflix
GROUP BY  listed_in
ORDER BY total_title DESC;

-- 87. Find actor appearing most frequently.
SELECT actors, COUNT(*) AS appearances
FROM netflix
WHERE actors <> 'Not Available'
GROUP BY actors
ORDER BY appearances DESC
LIMIT 1;

-- 88. Find director with highest average release year.
SELECT director,
		AVG(release_year) AS avg_release_year
FROM netflix
WHERE director <> 'Unknown'
GROUP BY director
ORDER BY avg_release_year DESC
LIMIT 1;
