-- Topics we'll cover
/*
	Duplicate Values
    Pivoting
    Imputing NULL Values
    Min/Max Value Filtering
    Rolling Calculating
*/

-- Duplicate values can be present in various ways

/*
To view duplicate values:
	- Use a combination of GROUP BY, COUNT, and HAVING
To exclude duplicate values:
	- Use DISTINCT to exclude fully duplicate rows
    - Use windows functions to exclude partially duplicate rows
*/

-- 1. Duplicate values
CREATE TABLE employee_details(
	region VARCHAR(50),
    employee_name VARCHAR(50),
    salary INTEGER
);

INSERT INTO employee_details(region, employee_name, salary) VALUES
('East', 'Ava', 85000),
('East', 'Ava', 85000),
('East', 'Bob', 72000),
('East', 'Cat', 59000),
('West', 'Cat', 63000),
('West', 'Dan', 85000),
('West', 'Eve', 72000),
('West', 'Eve', 75000);

-- View the employee details table
SELECT * FROM employee_details;

-- 1. View duplicate employees
SELECT employee_name, COUNT(*) AS dup_count
FROM employee_details
GROUP BY employee_name
HAVING dup_count > 1;

-- 2. View duplicate region + employee combos
SELECT region, employee_name, COUNT(*) AS dup_count
FROM employee_details
GROUP BY region, employee_name
HAVING COUNT(*) > 1;

-- 3. View fully duplicate rows
SELECT region, employee_name, salary, COUNT(*) AS dup_count
FROM employee_details
GROUP BY region, employee_name, salary
HAVING COUNT(*) > 1;

-- Exclude fully duplicate rows
-- 1. Exclude fully duplicate rows
SELECT DISTINCT region, employee_name, salary
FROM employee_details;

-- 2. Exclude partially duplicate rows (unique employee name for each)
SELECT region, employee_name, salary,
		ROW_NUMBER() OVER(PARTITION BY employee_name ORDER BY salary DESC) AS top_salary
FROM employee_details;

SELECT *
FROM (
	SELECT region, employee_name, salary,
		ROW_NUMBER() OVER(PARTITION BY employee_name ORDER BY salary DESC) AS top_salary
	FROM employee_details
) AS ts
WHERE top_salary = 1;

-- 3. Exclude partially duplicate rows (unique region + employee name for each row)
SELECT *
FROM (
	SELECT region, employee_name, salary,
		ROW_NUMBER() OVER(PARTITION BY region, employee_name ORDER BY salary DESC) AS top_salary
	FROM employee_details
) AS ts
WHERE top_salary = 1;

-- Min/Max value filtering allows you to filter data based on the lowest or highest values within each group
-- 2. MIN / MAX value filtering

USE maven_advanced_sql;

CREATE TABLE sales(
	id INT PRIMARY KEY,
    sales_rep VARCHAR(50),
    date DATE,
    sales INT
);

INSERT INTO sales(id, sales_rep, date, sales) VALUES
(1, 'Emma', '2024-08-01', 6),
(2, 'Emma', '2024-08-02', 17),
(3, 'Jack', '2024-08-02', 14),
(4, 'Emma', '2024-08-04', 20),
(5, 'Jack', '2024-08-05', 5),
(6, 'Emma', '2024-08-07', 1);

-- View the sales table
SELECT * FROM sales;

-- Goal: Return the most recent sales amount for each sale rep
-- Return the most recent sales date for each sales reps 

SELECT s.sales_rep, MAX(s.date) AS most_recent_date
FROM sales s
GROUP BY s.sales_rep;

-- Return the most recent sales date for each sales rep + attempt to add on the sales
SELECT s.sales_rep, MAX(s.date) AS most_recent_date, MAX(s.sales)
FROM sales s
GROUP BY s.sales_rep;

-- Number of sales on most recent date: Group by + join approach
WITH rd AS (
    SELECT s.sales_rep, MAX(s.date) AS most_recent_date
    FROM sales s
    GROUP BY s.sales_rep
)
SELECT 
    rd.sales_rep, 
    rd.most_recent_date, 
    s.date
FROM rd
LEFT JOIN sales s
    ON rd.sales_rep = s.sales_rep
   AND rd.most_recent_date = s.date;
   
-- Number of sales on most recent date: Window function approach
SELECT * FROM
(
	SELECT sales_rep, date, sales,
		ROW_NUMBER() OVER(PARTITION BY sales_rep ORDER BY date DESC) AS row_num
	FROM sales
) AS rn
WHERE row_num = 1;