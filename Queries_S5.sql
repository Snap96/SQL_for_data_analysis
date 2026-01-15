-- A subquery is a nested query within a main query , and is typically used for solving a problem in multiple steps

-- An example
USE maven_advanced_sql;

SELECT AVG(happiness_score)
FROM happiness_scores;

SELECT 
	year, country, region, happiness_score
FROM happiness_scores
WHERE happiness_score >
(
	SELECT AVG(happiness_score)
    FROM happiness_scores
);

-- Subqueries can occur in multiple places within a query:
-- Calculations in a SELECT clause
-- As part of a JOIN in the FROM clause
-- Flitering in the WHERE and HAVING clauses

-- Example

SELECT
	country,
    happiness_score - (SELECT AVG(happiness_score) FROM happiness_scores) AS diff_from_avg
FROM happiness_scores;

-- Connect to database
USE maven_advanced_sql;

-- 1. Subqueries in the SELECT clause
SELECT *
FROM happiness_scores;

-- Average happiness score
SELECT
	year, country, happiness_score,
    (SELECT AVG(happiness_score) FROM happiness_scores) AS global_avg,
    happiness_score - (SELECT AVG(happiness_score) FROM happiness_scores) AS STD_DV
FROM happiness_scores;

-- Happiness score deviation from the average


-- Assignment
SELECT 
	product_id, product_name, unit_price,
    (SELECT AVG(unit_price) FROM products) AS avg_unit_price,
    unit_price - (SELECT AVG(unit_price) FROM products) AS diff_price
FROM products
ORDER BY unit_price DESC;

-- 2. Subqueries in the FROM clause
SELECT * FROM happiness_scores;

-- Average happiness score for each country
SELECT country, AVG(happiness_score) AS avg_hs_by_country
FROM happiness_scores
GROUP BY country;

/*
	Return a country's happiness score for the year as well as
    the average happiness score for the country across years
*/
SELECT 
	hs.year, hs.country, hs.happiness_score,
    country_hs.avg_hs_by_country
FROM maven_advanced_sql.happiness_scores AS hs
LEFT JOIN
(
	SELECT country, AVG(happiness_score) AS avg_hs_by_country
	FROM maven_advanced_sql.happiness_scores
	GROUP BY country
) AS country_hs
ON hs.country = country_hs.country;

-- View one country
SELECT 
	hs.year, hs.country, hs.happiness_score,
    country_hs.avg_hs_by_country
FROM maven_advanced_sql.happiness_scores AS hs
LEFT JOIN
(
	SELECT country, AVG(happiness_score) AS avg_hs_by_country
	FROM maven_advanced_sql.happiness_scores
	GROUP BY country
) AS country_hs
ON hs.country = country_hs.country
WHERE hs.country = 'United States';

-- 3. Multiple Subqueries
-- Return happiness score for 2015-2024
SELECT DISTINCT year FROM maven_advanced_sql.happiness_scores;
SELECT * FROM maven_advanced_sql.happiness_scores_current;

SELECT year, country, happiness_score FROM happiness_scores
UNION ALL
SELECT 2024, country, ladder_score FROM happiness_scores_current;

/*
	Return a country's happiness score for the year as well as
    the average happiness score for the country across years
*/

SELECT 
	hs.year, hs.country, hs.happiness_score,
    country_hs.avg_hs_by_country
FROM
(
	SELECT year, country, happiness_score FROM happiness_scores
	UNION ALL
	SELECT 2024, country, ladder_score FROM happiness_scores_current
) 
AS hs
LEFT JOIN
(
	SELECT country, AVG(happiness_score) AS avg_hs_by_country
	FROM maven_advanced_sql.happiness_scores
	GROUP BY country
) AS country_hs
ON hs.country = country_hs.country;

/*
	Return years where the happiness score is a whole point
    greater than the country's average happiness score
*/
SELECT * FROM
(
	SELECT 
		hs.year, hs.country, hs.happiness_score,
		country_hs.avg_hs_by_country
	FROM
	(
		SELECT year, country, happiness_score FROM happiness_scores
		UNION ALL
		SELECT 2024, country, ladder_score FROM happiness_scores_current
	) 
	AS hs
	LEFT JOIN
	(
		SELECT country, AVG(happiness_score) AS avg_hs_by_country
		FROM maven_advanced_sql.happiness_scores
		GROUP BY country
	) AS country_hs
	ON hs.country = country_hs.country
)
AS hs_country_hs
WHERE happiness_score > avg_hs_by_country + 1;

-- Assignment
SELECT * FROM products;
SELECT * FROM orders;

SELECT 
	pt.factory, pt.product_name, np.units AS num_product
FROM 
(
	SELECT *
    FROM orders
) AS np
LEFT JOIN
(
	SELECT 
		product_id, factory, product_name
    FROM products
) AS pt
ON np.product_id = pt.product_id;

-- second attempt
SELECT *
FROM products
ORDER BY factory;

SELECT COUNT(factory), division 
FROM products
GROUP BY division;

SELECT factory, division 
FROM products
-- GROUP BY division
ORDER BY factory;

SELECT 
	factory, product_name, division
FROM products
ORDER BY factory, product_name;

SELECT 
	p.factory, p.product_name, num_products.num_count, p.division
FROM 
(
	SELECT COUNT(factory) AS num_count, division 
	FROM products
	GROUP BY division
) AS num_products
LEFT JOIN
(
	SELECT 
	factory, product_name, division
	FROM products
) AS p
ON num_products.division = p.division
ORDER BY factory, num_count asc;

-- Solution Answer
-- All factories and products
USE maven_advanced_sql;

SELECT factory, product_name
FROM products;

SELECT factory, COUNT(product_id)
FROM products
GROUP BY factory;

-- Final draft
SELECT 
	fp.factory, fp.product_name, fn.num_products
FROM
(
	SELECT factory, product_name
	FROM products
) AS fp
LEFT JOIN
(
	SELECT factory, COUNT(product_id) AS num_products
	FROM products
	GROUP BY factory
) AS fn
ON fp.factory = fn.factory
ORDER BY fp.factory;

-- 4. Subqueries in the WHERE and HAVING clauses

-- Above Average happiness score (WHERE)

SELECT *
FROM happiness_scores
WHERE happiness_score > 
(
		SELECT 
			AVG(happiness_score) 
		FROM happiness_scores
);

-- Above Average happiness score for each region (HAVING)
SELECT region, AVG(happiness_score) AS avg_hs
FROM happiness_scores
GROUP BY region
HAVING avg_hs >
(
		SELECT 
			AVG(happiness_score) 
		FROM happiness_scores
);

-- 5. ANY and ALL

SELECT AVG(happiness_score) 
FROM happiness_scores;

SELECT *
FROM happiness_scores;

SELECT *
FROM happiness_scores_current;

-- Scores that are greater than ANY 2024 scores
USE maven_advanced_sql;

SELECT *
FROM happiness_scores
WHERE happiness_score >
	ANY(
		SELECT ladder_score
        FROM happiness_scores_current
    );
    
-- Scores that are greater than ALL 2024 scores
SELECT *
FROM happiness_scores
WHERE happiness_score >
	ALL(
		SELECT ladder_score
        FROM happiness_scores_current
    );
    
-- EXISTS
-- Example
SELECT *
FROM happiness_scores h
WHERE EXISTS
(
	SELECT i.country_name
    FROM inflation_rates i
    WHERE i.country_name = h.country
);


-- Rewriting this as a Inner Join
SELECT *
FROM happiness_scores h
INNER JOIN inflation_rates i
ON h.country = i.country_name
AND h.year = i.year;

-- 6. EXISTS
SELECT *
FROM happiness_score;

SELECT *
FROM inflation_rates;

/*
	Return happiness scores of countries
    that exist in the inflation rates tables
*/
-- EXISTS focused on readable
SELECT *
FROM happiness_scores h
WHERE EXISTS
(
	SELECT i.country_name
    FROM inflation_rates i
    WHERE i.country_name = h.country
);

-- Alternative to EXISTS : INNER JOIN focused on speed
SELECT *
FROM happiness_scores h
INNER JOIN inflation_rates i
ON h.country = i.country_name
AND h.year = i.year;

-- Assignment
SELECT *
FROM products;

SELECT AVG(unit_price)
FROM products
WHERE factory = "Wicked Choccy's";

 SELECT *
 FROM products
 WHERE unit_price <
 ALL
 (
	SELECT unit_price
	FROM products
	WHERE factory = "Wicked Choccy's" 
 );

-- ASSIGNMENT 3: Subqueries in the WHERE clause Answers
-- View all products from Wicked Choccy's
SELECT *
FROM products
WHERE factory = "Wicked Choccy's"; 
-- Return products where the unit price is less than
-- the unit price of all products from Wicked Choccy's
SELECT *
 FROM products
 WHERE unit_price <
 ALL
 (
	SELECT unit_price
	FROM products
	WHERE factory = "Wicked Choccy's" 
 );
 
 -- COMMON TABLE EXPRESSION
 -- A common table expression(CTE) creates a named, temporary output that can be referenced within another query
WITH country_hs AS 
 (
	SELECT
		country,
        AVG(happiness_score) AS avg_hs_by_country
    FROM happiness_scores
    GROUP BY country
 )
SELECT
	hs.year, hs.country, hs.happiness_score,
    country_hs.avg_hs_by_country
FROM happiness_scores hs
LEFT JOIN country_hs
ON hs.country = country_hs.country;

-- 7. CTEs: Readability
/*
	SUBQUERY: Return the happiness scores along with 
    the average happpiness score for each country
*/

SELECT 
	hs.year, hs.country, hs.happiness_score,
    country_hs.avg_hs_by_country
FROM maven_advanced_sql.happiness_scores AS hs
LEFT JOIN
(
	SELECT country, AVG(happiness_score) AS avg_hs_by_country
	FROM maven_advanced_sql.happiness_scores
	GROUP BY country
) AS country_hs
ON hs.country = country_hs.country;

/*
	CTE: Return the happiness score along with
    the average happiness score for each country
*/
WITH country_hs AS
(
	SELECT country, AVG(happiness_score) AS avg_hs_by_country
	FROM maven_advanced_sql.happiness_scores
	GROUP BY country
)

SELECT 
	hs.year, hs.country, hs.happiness_score,
    country_hs.avg_hs_by_country
FROM maven_advanced_sql.happiness_scores AS hs
LEFT JOIN country_hs
ON hs.country = country_hs.country;

-- 8. CTEs: Reusability
-- SUBQUERY: Compare the happiness scores within each region in 2023
SELECT *
FROM happiness_scores
WHERE year = 2023;

SELECT *
FROM happiness_scores hs1
INNER JOIN happiness_scores hs2
ON hs1.region = hs2.region;

SELECT 
	hs1.region, hs1.country, hs1.happiness_score,
    hs2.country, hs2.happiness_score
FROM happiness_scores hs1
INNER JOIN happiness_scores hs2
ON hs1.region = hs2.region;

SELECT 
	hs1.region, hs1.country, hs1.happiness_score,
    hs2.country, hs2.happiness_score
FROM 
(
	SELECT *
    FROM happiness_scores
    WHERE year = 2023
) hs1
INNER JOIN 
(
	SELECT *
    FROM happiness_scores
    WHERE year = 2023
) hs2
ON hs1.region = hs2.region;

-- CTE: Compare the happiness scores within each region in 2023
WITH hs AS (
	SELECT *
    FROM happiness_scores
    WHERE year = 2023
)

SELECT 
	hs1.region, hs1.country, hs1.happiness_score,
    hs2.country, hs2.happiness_score
FROM hs hs1
INNER JOIN hs hs2
ON hs1.region = hs2.region
WHERE hs1.country < hs2.country;

-- Assignment
SELECT * FROM orders;
SELECT * FROM products;

WITH ts_spend AS 
(
	SELECT 
	o.order_id,
    SUM(o.units * p.unit_price) AS total_amount_spend
	FROM orders o
	LEFT JOIN products p
	ON o.product_id = p.product_id
	GROUP BY order_id
	HAVING total_amount_spend > 200
	ORDER BY total_amount_spend DESC
)

SELECT COUNT(*)
FROM ts_spend;

-- 9. CTEs: Multiple CTEs
-- Step 1: Compare 2023 vs 2024 happiness scores side by side
WITH hs23 AS 
(
	SELECT *
    FROM happiness_scores
    WHERE year = 2023
),
hs24 AS
(
	SELECT *
    FROM happiness_scores_current
)

SELECT 
	hs23.country,
    hs23.happiness_score AS hs_2023,
    hs24.ladder_score AS hs_2024
FROM hs23
INNER JOIN hs24
ON hs23.country = hs24.country;

-- Step 2: Return the countries where the score increased
SELECT * FROM
(
	WITH hs23 AS
    (
		SELECT *
        FROM happiness_scores
        WHERE year = 2023
    ),
    hs24 AS 
    (
		SELECT *
        FROM happiness_scores_current
    )
    
    SELECT
		hs23.country,
        hs23.happiness_score AS hs_2023,
        hs24.ladder_score AS hs_2024
	FROM hs23
    INNER JOIN hs24
    ON hs23.country = hs24.country
) AS hs_23_24
WHERE hs_2023 < hs_2024;

-- Alternative method
WITH hs23 AS
(
	SELECT *
    FROM happinesss_scores 
    WHERE year = 2023
),
hs24 AS
(
	SELECT *
    FROM happiness_scores_current
),
hs_23_24 AS
(
	SELECT
		hs23.country, 
        hs24.happiness_score AS hs_2023,
        hs24.ladder-score AS hs_2024
    FROM hs23 LEFT JOIN hs24
    ON hs23.country = hs24.country
)
SELECT *
FROM hs_23_24
WHERE hs_2024 > hs_2023;

-- ASSIGNMENT 5: CTEs

-- Assignment 2 solution
SELECT 
	fp.factory, fp.product_name, fn.num_products
FROM
(
	SELECT factory, product_name
	FROM products
) AS fp
LEFT JOIN
(
	SELECT factory, COUNT(product_id) AS num_products
	FROM products
	GROUP BY factory
) AS fn
ON fp.factory = fn.factory
ORDER BY fp.factory;

-- Rewrite the assignment 2 subquery solution with CTEs instead
WITH fp AS
(
	SELECT factory, product_name
	FROM products
),
fn AS
(
	SELECT factory, COUNT(product_id) AS num_products
	FROM products
	GROUP BY factory
)

SELECT 
	fp.factory, fp.product_name, fn.num_products
FROM fp
LEFT JOIN fn
ON fp.factory = fn.factory
ORDER BY fp.factory, fp.product_name;


-- Learning recursive CTEs
-- Return daily stock prices, including dates with missing dates
-- Generate a column of dates
WITH RECURSIVE my_dates(dt) AS
(
	SELECT '2024-11-01'
    UNION ALL
    SELECT dt + INTERVAL 1 DAY
    FROM mydates
    WHERE dt < '2024-11-06'
)
SELECT * FROM my_dates;

-- Return the reporting chain for each employee
USE maven_advanced_sql;

SELECT *
FROM employees;

WITH RECURSIVE employee_hierarchy AS
(
	SELECT
		employee_id, employee_name, manager_id,
        employee_name AS hierarchy
    FROM employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    SELECT 
		e.employee_id, e.employee_name, e.manager_id,
        CONCAT(eh.hierarchy, ' > ', e.employee_name) AS hierarchy
    FROM employees e
    INNER JOIN employee_hierarchy eh
    ON e.manager_id = eh.employee_id
)
SELECT 
	employee_id, employee_name, manager_id, hierarchy
FROM employee_hierarchy
ORDER BY employee_id;

-- Temp tables and views
-- Both subqueries and CTEs only exist for the duration of the query
-- Temp tables exist for a session and views continue to exist until modified or dropped

-- Temp table
CREATE TEMPORARY TABLE my_temp_table AS
SELECT year, country, happiness_score 
FROM happiness_scores
UNION ALL
SELECT 2024, country, ladder_score
FROM happiness_scores_current;

SELECT * FROM my_temp_table;

CREATE VIEW my_view AS
SELECT year, country, happiness_score 
FROM happiness_scores
UNION ALL
SELECT 2024, country, ladder_score
FROM happiness_scores_current;

SELECT * FROM my_view;