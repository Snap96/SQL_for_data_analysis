SELECT * FROM maven_advanced_sql.orders;

SELECT order_id, MAX(units) 
FROM orders
GROUP BY order_id;

-- how many order where placed on each day
SELECT order_date, sum(units)
FROM orders
GROUP BY order_date;


-- get our biggest order
SELECT order_id, MAX(units) AS biggest_units
FROM orders
GROUP BY order_id
ORDER BY biggest_units DESC;

-- Tells you the cost of each transtion of the customer units and amount spend
SELECT 
	o.customer_id, o.order_id, o.order_date, o.product_id,
    p.product_name, o.units, p.unit_price, (o.units * p.unit_price) AS amount_spend
FROM orders o
LEFT JOIN products p
ON o.product_id = p.product_id;

SELECT 
	o.order_id,
	SUM((o.units * p.unit_price)) AS amount_spend
FROM orders o
INNER JOIN products p
ON o.product_id = p.product_id
GROUP BY o.customer_id, o.order_date
HAVING o.customer_id = 18127
ORDER BY o.customer_id, o.order_date;

-- The cusomter who ordered the most
SELECT customer_id, count(customer_id), SUM(units)
FROM orders
GROUP BY customer_id
ORDER BY SUM(units) DESC;

SELECT 
	o.order_id,
    SUM(o.units * p.unit_price) AS total_amount_spend
FROM orders o
LEFT JOIN products p
ON o.product_id = p.product_id
GROUP BY order_id
HAVING total_amount_spend > 200
ORDER BY total_amount_spend DESC;

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