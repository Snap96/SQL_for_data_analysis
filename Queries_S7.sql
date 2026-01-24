-- Connect to database
-- Assignment 1: Numeric Functions
-- Calculate the total spend for each customer

SELECT o.customer_id, o.product_id, o.units 
FROM orders o;

SELECT p.product_id, p.unit_price
FROM products p;

SELECT o.customer_id, SUM(o.units * p.unit_price) AS total_spend
FROM orders o
LEFT JOIN products p
ON o.product_id = p.product_id
GROUP BY o.customer_id;

-- Put the spend into bins of 0-10, 10-20
SELECT 
	o.customer_id, 
	SUM(o.units * p.unit_price) AS total_spend,
    FLOOR(SUM(o.units * p.unit_price)/10) * 10 AS total_spend_bin
FROM orders o
LEFT JOIN products p
ON o.product_id = p.product_id
GROUP BY o.customer_id;

-- Number of customers in each spend bin
WITH bin AS(
	SELECT 
		o.customer_id, 
		SUM(o.units * p.unit_price) AS total_spend,
		FLOOR(SUM(o.units * p.unit_price)/10) * 10 AS total_spend_bin
	FROM orders o
	LEFT JOIN products p
	ON o.product_id = p.product_id
	GROUP BY o.customer_id
)
SELECT total_spend_bin, COUNT(customer_id) AS num_customers
FROM bin
GROUP BY total_spend_bin
ORDER BY total_spend_bin;

-- Assignment 2 : Datetime functions

-- Extract just the orders from Q2 2024
SELECT * FROM orders;

SELECT * 
FROM orders 
WHERE YEAR(order_date) = 2024 AND MONTH(order_date) BETWEEN 4 AND 6;

-- Add a column called ship_date that adds 2 days to each order date
SELECT 
	order_id, order_date,
    DATE_ADD(order_date, INTERVAL 2 DAY) AS ship_date
FROM orders 
WHERE YEAR(order_date) = 2024 AND MONTH(order_date) BETWEEN 4 AND 6;