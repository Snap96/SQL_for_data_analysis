-- WINDOWS FUNCTIONS
-- Window functions are used to apply a function to a window of data
-- Windows are essentially groups of rows of data\

-- How are window function different from GROUP BY?
-- Aggregate functions collapse the rows in each group and apply a calculation
-- Windows functions leave the rows they are and apply calculations by window
USE maven_advanced_sql;

-- Aggregate functions
SELECT
    country,
    AVG(happiness_score) AS avg_hs
FROM maven_advanced_sql.happiness_scores
GROUP BY country;

-- Window functions
SELECT
	country, year, happiness_score,
    ROW_NUMBER() OVER
    (
		PARTITION BY country
		ORDER BY year
	) AS row_num
FROM  maven_advanced_sql.happiness_scores;

-- PART 2
-- Aggregate function
SELECT country, year, happiness_score
FROM  maven_advanced_sql.happiness_scores;

-- Window function
SELECT
	country, year, happiness_score,
    ROW_NUMBER() OVER() AS row_num
FROM  maven_advanced_sql.happiness_scores;

-- PART 3
SELECT 
	country, year, happiness_score,
    ROW_NUMBER() OVER(PARTITION BY country) AS row_num
FROM  maven_advanced_sql.happiness_scores;


-- Return all row numbers within each window
-- where the rows are ordered by happiness score
SELECT 
	country, year, happiness_score,
    ROW_NUMBER() 
    OVER
    (
		PARTITION BY country
        ORDER BY happiness_score DESC
	) AS row_num
FROM  maven_advanced_sql.happiness_scores;

-- 2. ROW_NUMBER vs RANK vs DENSE RANK
CREATE TABLE baby_girl_names(
	name VARCHAR(50),
    babies INT
);

INSERT INTO baby_girl_names (name, babies) VALUES
('Olivia', 99),
('Emma', 80),
('Charlotte', 80),
('Amelia', 75),
('Sophia', 72),
('Isabella', 70),
('Ava', 70),
('Mia', 64);

-- View the table
SELECT * FROM baby_girl_names; 

-- Compare ROW_NUMBER vs RANK vs DENSE RANK
SELECT
	name, babies,
    ROW_NUMBER() OVER() AS baby_rn,
    RANK() OVER(ORDER BY babies DESC) AS baby_rank,
    DENSE_RANK() OVER(ORDER BY babies DESC) AS baby_rn
FROM baby_girl_names;

-- FIRST_VALUE, LAST_VALUE AND NTH_VALUE
CREATE TABLE baby_names(
	gender VARCHAR(10),
    name VARCHAR(50),
    babies INT
);

INSERT INTO baby_names (gender, name, babies) VALUES
('Female', 'Charlotte', 80),
('Female', 'Emma', 82),
('Female', 'Olivia', 99),
('Male', 'James', 85),
('Male', 'Liam', 110),
('Male', 'Noah', 95);

-- View the table
SELECT * FROM baby_names;

-- Return the first name in each windows
SELECT
	gender, name, babies,
    FIRST_VALUE(name) OVER(PARTITION BY gender ORDER BY babies) AS 'Top_name'
FROM baby_names;

-- Return the top name for each gender
SELECT * FROM
(
	SELECT
		gender, name, babies,
		FIRST_VALUE(name) OVER(PARTITION BY gender ORDER BY babies DESC) AS 'Top_name'
	FROM baby_names
) AS top_name
WHERE name = top_name;

-- AS CTE
WITH top_name AS
(
	SELECT
		gender, name, babies,
		FIRST_VALUE(name) OVER(PARTITION BY gender ORDER BY babies DESC) AS 'Top_name'
	FROM baby_names
) 
SELECT *
FROM top_name
WHERE name = top_name;

-- Return the second name in each window
SELECT
	gender, name, babies,
	NTH_VALUE(name, 2) OVER(PARTITION BY gender ORDER BY babies DESC) AS 'second_name'
FROM baby_names;

-- Return the 2nd most popular name for each gender
SELECT * FROM
(
	SELECT
		gender, name, babies,
		NTH_VALUE(name, 2) OVER(PARTITION BY gender ORDER BY babies DESC) AS 'second_name'
	FROM baby_names
) AS second_name
WHERE name = second_name;

-- Alternative using ROW_NUMBER
-- Number all the rows within each window
SELECT
	gender, name, babies,
	ROW_NUMBER() OVER(PARTITION BY gender ORDER BY babies DESC) AS 'popularity'
FROM baby_names;

-- Return the 2nd most popular name for each gender
SELECT * FROM
(
SELECT
	gender, name, babies,
	ROW_NUMBER() OVER(PARTITION BY gender ORDER BY babies DESC) AS 'popularity'
FROM baby_names
) AS pop
WHERE popularity = 2;

-- VALUE RELATIVE TO A ROW
-- LEAD() and LAG() allow you to return the value from the next and previous row, respectively within each window

-- Return the prior year's happiness score
SELECT 
	country, year, happiness_score,
    LAG(happiness_score) OVER(PARTITION BY country ORDER BY year) AS prior_happiness_score
FROM happiness_scores;

-- Calculate the difference in happiness scores over time, by country
WITH hs_prior AS
(
	SELECT 
	country, year, happiness_score,
    LAG(happiness_score) OVER(PARTITION BY country ORDER BY year) AS prior_happiness_score
	FROM happiness_scores
)
SELECT
	country, year, happiness_score, prior_happiness_score,
    happiness_score - prior_happiness_score AS hs_change
FROM hs_prior