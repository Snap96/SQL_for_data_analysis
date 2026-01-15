-- We will focus on JOINs and Basics of Unions
-- BASIC JOINS

SELECT *
FROM happiness_scores hs
INNER JOIN country_stats cs
ON hs.country = cs.country;

-- Connect to the database
USE maven_advanced_sql;

-- 1. Basic joins
SELECT * FROM happiness_scores;
SELECT * FROM country_stats;

SELECT 
	happiness_scores.year, happiness_scores.country, happiness_scores.happiness_score,
    country_stats.country, country_stats.continent
FROM happiness_scores
INNER JOIN country_stats
ON happiness_scores.country = country_stats.country; 

-- 2. Join Types

SELECT 
	hs.year, hs.country, hs.happiness_score,
    cs.country, cs.continent
FROM happiness_scores hs
INNER JOIN country_stats cs
ON hs.country = cs.country;

SELECT 
	hs.year, hs.country, hs.happiness_score,
    cs.country, cs.continent
FROM happiness_scores hs
LEFT JOIN country_stats cs
ON hs.country = cs.country
WHERE cs.country IS NULL;

SELECT 
	hs.year, hs.country, hs.happiness_score,
    cs.country, cs.continent
FROM happiness_scores hs
RIGHT JOIN country_stats cs
ON hs.country = cs.country
WHERE hs.country IS NULL;


-- Assignment
USE maven_advanced_sql;

SELECT *
FROM products;

SELECT * 
FROM orders;

SELECT 
	p.product_id, 
    p.product_name, 
    o.product_id AS product_id_in_orders
FROM products p
LEFT JOIN orders o 
ON p.product_id = o.product_id
WHERE o.product_id IS NULL;


-- 3. Joining on multiple columns
USE maven_advanced_sql;
-- Example
SELECT 
	hs.year,
    hs.country,
    hs.happiness_score,
    ir.inflation_rate
FROM happiness_scores hs
INNER JOIN inflation_rates ir
ON hs.year = ir.year AND hs.country = ir.country_name;



-- 4. Joining multiple tables

SELECT * FROM happiness_scores;
SELECT * FROM country_stats;
SELECT * FROM inflation_rates;

SELECT 
	hs.year, hs.country, hs.happiness_score,
    cs.continent,
    ir.inflation_rate
FROM happiness_scores hs
LEFT JOIN country_stats cs
ON hs.country = cs.country
LEFT JOIN inflation_rates ir
ON hs.year = ir.year AND hs.country = ir.country_name;

-- SELF JOINS
-- A self join lets you join a table with itself and two steps:
-- Combine a table with based on matching column
-- Filter on resulting rows based on some criteria

-- Employees with the same salary
USE maven_advanced_sql;

SELECT 
		e1.employee_name, e1.salary,
        e2.employee_name, e2.salary
FROM employees e1 
INNER JOIN employees e2
	ON e1.salary = e2.salary
WHERE e1.employee_name <> e2.employee_name
ORDER BY e1.employee_name;


-- 5. SELF JOINS
CREATE TABLE IF NOT EXISTS employees(
	employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    salary INT,
    manager_id INT
);

INSERT INTO employees (employee_id, employee_name, salary, manager_id) VALUES
(1, 'Ava', 85000, NULL),
(2, 'Bob', 72000, 1),
(3, 'Cat', 59000, 1),
(4, 'Dan', 85000, 2);

SELECT *
FROM employees;

-- Employees with the same salary
USE maven_advanced_sql;

SELECT *
FROM employees e1
INNER JOIN employees e2
ON e1.salary = e2.salary
WHERE e1.employee_name <> e2.employee_name AND
e1.employee_id > e2.employee_id;

SELECT 
	e1.employee_id, e1.employee_name, e1.salary,
    e2.employee_id, e2.employee_name, e2.salary
FROM employees e1
INNER JOIN employees e2
ON e1.salary = e2.salary
WHERE e1.employee_id > e2.employee_id;

-- Employees that have a greater salary

SELECT 
	e1.employee_id, e1.employee_name, e1.salary,
    e2.employee_id, e2.employee_name, e2.salary
FROM employees e1
INNER JOIN employees e2
ON e1.salary > e2.salary
ORDER BY e1.employee_id;

-- Employees and their manager

SELECT 
	e1.employee_id, e1.employee_name, e1.salary,
    e2.employee_name AS manager_name
FROM employees e1
LEFT JOIN employees e2
ON e1.manager_id = e2.employee_id;


-- Section 04 assignment
-- Use self joins on the products table
USE maven_advanced_sql;

SELECT 
	p1.product_name, p1.unit_price,
    p2.product_name,
    (p1.unit_price - p2.unit_price) AS price_diff
FROM products p1
INNER JOIN products p2
ON p1.unit_price <> p2.unit_price 
WHERE ABS(p2.unit_price - p1.unit_price) BETWEEN 0.25 AND -0.25;

-- AI generated correction
SELECT 
    p1.product_name, p1.unit_price,
    p2.product_name,
    (p1.unit_price - p2.unit_price) AS price_diff
FROM products p1
INNER JOIN products p2
    ON p1.unit_price <> p2.unit_price
WHERE ABS(p2.unit_price - p1.unit_price) <= 0.25
	AND p1.product_id < p2.product_id
ORDER BY (p2.unit_price - p1.unit_price) DESC;

-- 6. CROSS JOIN
USE maven_advanced_sql;

CREATE TABLE tops(
	id INT,
    item VARCHAR(50)
);

CREATE TABLE sizes(
	id INT,
    size VARCHAR(50)
);

CREATE TABLE outerwear(
	id INT,
    item VARCHAR(50)
);

INSERT INTO tops (id, item) VALUES
(1, 'T-Shirt'),
(2, 'Hoodie');

INSERT INTO sizes (id, size) VALUES
(101, 'Small'),
(102, 'Medium'),
(103, 'Large');

INSERT INTO outerwear (id, item) VALUES
(2, 'Hoodie'),
(3, 'Jacket'),
(4, 'Coat');

-- View the tables
SELECT * FROM tops;
SELECT * FROM sizes;
SELECT * FROM outerwear;

-- CROSS JOIN THE TABLES
SELECT *
FROM tops
CROSS JOIN sizes;

-- TRY UNION AND UNION ALL
-- Use a UNION to stack multiple tables or queries on top of one another
-- UNION removes duplicate values, while UNION ALL retains them

SELECT * FROM tops
UNION
SELECT * FROM outerwear;

SELECT * FROM tops
UNION ALL
SELECT * FROM outerwear;

-- 7. Union vs union all
SELECT * FROM tops;
SELECT * FROM outerwear;

-- Union
SELECT * FROM tops
UNION
SELECT * FROM outerwear;

-- Union all
SELECT * FROM tops
UNION ALL
SELECT * FROM outerwear;

-- Union with different column names
SELECT * FROM happiness_scores;
SELECT * FROM happiness_scores_current;

SELECT distinct year 
FROM happiness_scores;

SELECT year, country, happiness_score FROM happiness_scores
UNION
SELECT 2024, country, ladder_score FROM happiness_scores_current;

SELECT year, country, happiness_score FROM happiness_scores
UNION ALL
SELECT 2024, country, ladder_score FROM happiness_scores_current;