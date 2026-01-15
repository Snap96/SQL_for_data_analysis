-- Connect to database
USE maven_advanced_sql;

-- 1. Window function basics

-- Return all row number
SELECT 
	country, year, happiness_score
FROM happiness_scores
ORDER BY country, year;

SELECT 
	country, year, happiness_score,
    ROW_NUMBER() OVER() as row_num
FROM happiness_scores
ORDER BY country, year;

SELECT 
	country, year, happiness_score,
    ROW_NUMBER() OVER(PARTITION BY country) as row_num
FROM happiness_scores
ORDER BY country, year;

-- Return all row number within each window
-- where the rows are ordered by happiness score
SELECT 
	country, year, happiness_score,
    ROW_NUMBER() OVER(PARTITION BY country ORDER BY happiness_score) as row_num
FROM happiness_scores
ORDER BY country, year;

SELECT 
	country, year, happiness_score,
    ROW_NUMBER() OVER(PARTITION BY country ORDER BY happiness_score) as row_num
FROM happiness_scores
ORDER BY country, row_num;

-- Return all row number within each window
-- where the rows are ordered by happiness score descending
SELECT 
	country, year, happiness_score,
    ROW_NUMBER() OVER(PARTITION BY country ORDER BY happiness_score DESC) as row_num
FROM happiness_scores
ORDER BY country, row_num;


-- Assignment Window functions basics
-- view the table
SELECT *
FROM orders;

SELECT 
	customer_id, order_id, order_date, transaction_id,
    ROW_NUMBER() OVER(PARTITION BY customer_id  ORDER BY transaction_id ) as transaction_number
FROM orders
ORDER BY customer_id;

-- Assignment which is the most popular product
-- View the table
SELECT * FROM orders;

-- using ROW_NUMBER
SELECT 
	order_id, product_id, units,
    ROW_NUMBER() OVER(PARTITION BY order_id ORDER BY units DESC) AS product_rank
FROM orders
ORDER BY order_id, product_id;

-- Using RANK
SELECT 
	order_id, product_id, units,
    DENSE_RANK() OVER(PARTITION BY order_id ORDER BY units DESC) AS product_rn
FROM orders
ORDER BY order_id, product_rn;

-- Correction
SELECT 
	order_id, product_id, units,
    DENSE_RANK() OVER(PARTITION BY order_id ORDER BY units DESC) AS product_rank
FROM orders
WHERE order_id LIKE '%44262'
ORDER BY order_id, product_rank;

-- Assignment
WITH pop AS (SELECT 
	order_id, product_id, units,
    NTH_VALUE(product_id, 2) OVER(PARTITION BY order_id ORDER BY units DESC) AS second_product
FROM orders
ORDER BY order_id, second_product
)
SELECT
	order_id, product_id, units
FROM pop
WHERE product_id = second_product;

-- Alternative 
WITH pop AS (SELECT 
	order_id, product_id, units,
    DENSE_RANK() OVER(PARTITION BY order_id ORDER BY units DESC) AS product_rank
FROM orders
ORDER BY order_id
)
SELECT * FROM pop
WHERE product_rank = 2;