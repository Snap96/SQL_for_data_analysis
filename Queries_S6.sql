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

-- View the columns of interest
SELECT 
	customer_id, order_id, product_id, transaction_id, order_date, units
FROM orders;

-- For each customer, return the total units within each order
SELECT 
	customer_id, order_id, transaction_id, SUM(units) AS total_units
FROM orders
GROUP BY customer_id, order_id
ORDER BY customer_id;

-- Add on the transaction id to keep track of the order of the orders
SELECT customer_id, order_id, MIN(transaction_id) AS min_tid, SUM(units) AS total_units
FROM orders
GROUP BY customer_id, order_id
ORDER BY customer_id, min_tid;

-- Turn the query into a CTE and view the column of interest
WITH my_cte AS(
SELECT customer_id, order_id, MIN(transaction_id) AS min_tid, SUM(units) AS total_units
FROM orders
GROUP BY customer_id, order_id
ORDER BY customer_id, min_tid
)
SELECT 
	customer_id, order_id, total_units
FROM my_cte;

-- Create a prior units column
WITH my_cte AS (
    SELECT 
        customer_id, 
        order_id, 
        MIN(transaction_id) AS min_tid, 
        SUM(units) AS total_units
    FROM orders
    GROUP BY customer_id, order_id
)
SELECT 
    customer_id, 
    order_id, 
    total_units,
    LAG(total_units) OVER (
        PARTITION BY customer_id 
        ORDER BY min_tid
    ) AS prev_total_units
FROM my_cte;

-- For each customer, find the change in units per over time
WITH my_cte AS (
    SELECT 
        customer_id, 
        order_id, 
        MIN(transaction_id) AS min_tid, 
        SUM(units) AS total_units
    FROM orders
    GROUP BY customer_id, order_id
)
SELECT 
    customer_id, 
    order_id, 
    total_units,
    LAG(total_units) OVER (
        PARTITION BY customer_id 
        ORDER BY min_tid
    ) AS prev_total_units,
    total_units - LAG(total_units) OVER (
        PARTITION BY customer_id 
        ORDER BY min_tid
    )
    
FROM my_cte;

-- final query
WITH my_cte AS (
    SELECT 
        customer_id, 
        order_id, 
        MIN(transaction_id) AS min_tid, 
        SUM(units) AS total_units
    FROM orders
    GROUP BY customer_id, order_id
),
prior_cte AS(
	SELECT customer_id, 
        order_id, total_units,
	total_units - LAG(total_units) OVER (
        PARTITION BY customer_id 
        ORDER BY min_tid
    ) AS prev_total_units
    FROM my_cte
)
SELECT 
    customer_id, 
    order_id, 
    total_units,
	prev_total_units,
    total_units - prev_total_units AS diff_units
FROM prior_cte;

-- Assignment: statistical functions
SELECT * FROM orders;

-- connect two table and indicate the cost of the units
SELECT 
	o.customer_id, SUM(o.units * unit_price) AS amount_spent,
    NTILE(100) OVER(PARTITION BY o.customer_id) AS spend_pct
FROM orders o 
LEFT JOIN products p
ON o.product_id = p.product_id
GROUP BY o.customer_id
ORDER BY o.customer_id;

-- Create CTE
WITH top_cus AS (
    SELECT 
        o.customer_id, 
        SUM(o.units * p.unit_price) AS amount_spent
    FROM orders o
    INNER JOIN products p
        ON o.product_id = p.product_id
    GROUP BY o.customer_id
),
ranked AS (
    SELECT 
        customer_id, 
        amount_spent,
        NTILE(100) OVER (ORDER BY amount_spent DESC) AS spend_pct
    FROM top_cus
)
SELECT 
    customer_id, 
    amount_spent,
    spend_pct
FROM ranked
WHERE spend_pct = 1   -- top 1% of customers
ORDER BY amount_spent DESC;
