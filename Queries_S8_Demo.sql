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