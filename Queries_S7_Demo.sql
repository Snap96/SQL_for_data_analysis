-- Functions By data type

/*
Function Basics
Datetime Functions
Numeric Functions
String Functions
Null Functions
*/

-- SQL function take in zero or more inputs, apply a calculation or transformation and output a values
-- You can recognize a function by parentheses () that follow a keyword

-- Function that applies a calculation
SELECT COUNT(*)
FROM happiness_scores;

-- Function that applies a transformation
SELECT ROUND(happiness_score)
FROM happiness_scores;

-- Function with no inputs
SELECT CURRENT_DATE();

-- DISTINCT is a keyword, not a function
SELECT COUNT(DISTINCT country)
FROM happiness_scores;

-- FUNCTION CATEGORIES
-- These are three function cateories: aggregate, window and general functions

-- Aggregate
-- Applies a calculation to many rows of data and returns a single value 
-- Often used alongside a GROUP BY

SELECT AVG(happiness_score) AS avg_hs
FROM happiness_scores;

SELECT 
	country,
    AVG(happiness_score) AS avg_hs
FROM happiness_scores
GROUP BY country;

-- Window, performs calculations across a window of rows

SELECT
	year, country, happiness_score,
    ROW_NUMBER() OVER(PARTITION BY year ORDER BY happiness_score DESC) AS happines_score_annual_ranking
FROM happiness_scores;

-- General, performs calculations on all individual values within a column
-- Apply functions to two columns

SELECT 
	year, country, happiness_score,
    UPPER(country) AS country_upper,
    ROUND(happiness_score, 1) AS hs_rounded
FROM happiness_scores;

-- NUMERIC FUNCTIONS
-- Can be applied to numeric columns(integer, decimal)

-- Applying a log transform to the population of each country
SELECT 
	country, population,
    LOG(population) AS log_pop,
    ROUND(LOG(population),2) AS log_pop_2
FROM country_stats;

-- Connect to database (MySQL)
USE maven_advanced_sql;

-- 1. Numeric Functions
-- Math and rounding functions
SELECT 
	country, population,
    LOG(population) AS log_pop,
    ROUND(LOG(population),2) AS log_pop_2
FROM country_stats;

-- Pro Tip: FLOOR function for binning
SELECT 
	country, population,
    FLOOR(population / 1000000) AS pop_m
FROM country_stats;

WITH pm AS (
	SELECT 
		country, population,
		FLOOR(population / 1000000) AS pop_m
	FROM country_stats
)
SELECT 
	pop_m, COUNT(country) AS num_countries
FROM pm
GROUP BY pop_m
ORDER BY pop_m;



-- Max of a column vs max of a row: least & greatest
-- Create a miles run table
CREATE TABLE miles_run(
	name VARCHAR(50),
    q1 INT,
    q2 INT,
    q3 INT,
    q4 INT
);

INSERT INTO miles_run(name, q1, q2, q3, q4) VALUES
('Ali', 100, 200, 150, NULL),
('Bolt', 350, 400, 380, 300),
('Jordan', 200, 250, 300, 320);

SELECT * FROM miles_run;

-- Return the greatest value of each column
SELECT MAX(q1), MAX(q2), MAX(q3), MAX(q4)
FROM miles_run;

-- Return the greatest value of each row
SELECT GREATEST(q1, q2, q3, q4) AS most_miles
FROM miles_run; 

-- Lookahead: Deal with the NULL values
SELECT GREATEST(q1, q2, q3, COALESCE(q4,0)) AS most_miles
FROM miles_run; 

-- Pro Tip: Cast & Convert
-- Sometimes you may need to cast columns to different data types, so that you can utilize specific functions

CREATE TABLE sample_table(
	id INT,
    str_value CHAR(50)
);

INSERT INTO sample_table(id, str_value) VALUES
(1, '100.2'),
(2, '200.4'),
(3, '300.6');

-- Turn the string to a float
SELECT 
	id, str_value,
    CAST(str_value AS FLOAT) * 2 AS float_value
FROM sample_table;

-- Try to do a math calculation on the string column
SELECT 
	id, str_value*2
FROM sample_table;

SELECT 
	id, CAST(str_value AS DECIMAL(5,2)) *2
FROM sample_table;

-- Turn an integer into a float
SELECT country, population /5.0
FROM country_stats;


-- DATE FUNCTIONS
-- Datetime functions can be applied to datetime columns(date, time, etc)

-- Get the current date and time
SELECT CURRENT_DATE(), CURRENT_TIMESTAMP();

-- Create a my events table
CREATE TABLE my_events(
	event_name VARCHAR(50),
    event_date DATE,
    event_datetime DATETIME,
    event_type VARCHAR(20),
    event_desc TEXT
);

INSERT INTO my_events (event_name, event_date, event_datetime, event_type, event_desc) VALUES
('New Year\'s Day', '2025-01-01', '2025-01-01 00:00:00', 'Holiday', 'A global celebration to mark the beginning of the New Year. Festivities often include fireworks, parties, and various cultural traditions as people reflect on the past year and set resolutions for the upcoming one.'),
('Lunar New Year', '2025-01-29', '2025-01-29 10:00:00', 'Holiday', 'A significant cultural event in many Asian countries, the Lunar New Year, also known as the Spring Festival, involves family reunions, feasts, and various rituals to welcome good fortune and happiness for the year ahead.'),
('Persian New Year', '2025-03-20', '2025-03-20 12:00:00', 'Holiday', 'Known as Nowruz, this celebration marks the first day of spring and the beginning of the year in the Persian calendar. It is a time for family gatherings, traditional foods, and cultural rituals to symbolize renewal and rebirth.'),
('Birthday', '2025-05-13', '2025-05-13 18:00:00', ' Personal!', 'A personal celebration marking the anniversary of one\'s birth. This special day often involves gatherings with family and friends, cake, gifts, and reflecting on personal growth and achievements over the past year.'),
('Last Day of School', '2025-06-12', '2025-06-12 15:30:00', ' Personal!', 'The final day of the academic year, celebrated by students and teachers alike. It often includes parties, awards, and a sense of excitement for the upcoming summer break, marking the end of a year of hard work and learning.'),
('Vacation', '2025-08-01', '2025-08-01 08:00:00', ' Personal!', 'A much-anticipated break from daily routines, this vacation period allows individuals and families to relax, travel, and create memories. It is a time for adventure and exploration, often enjoyed with loved ones.'),
('First Day of School', '2025-08-18', '2025-08-18 08:30:00', ' Personal!', 'An exciting and sometimes nerve-wracking day for students, marking the beginning of a new academic year. This day typically involves meeting new teachers, reconnecting with friends, and setting goals for the year ahead.'),
('Halloween', '2025-10-31', '2025-10-31 18:00:00', 'Holiday', 'A festive occasion celebrated with costumes, trick-or-treating, and various spooky activities. Halloween is a time for fun and creativity, where people of all ages dress up and participate in themed events, parties, and community gatherings.'),
('Thanksgiving', '2025-11-27', '2025-11-27 12:00:00', 'Holiday', 'A holiday rooted in gratitude and family, Thanksgiving is celebrated with a large feast that typically includes turkey, stuffing, and various side dishes. It is a time to reflect on the blessings of the year and spend quality time with loved ones.'),
('Christmas', '2025-12-25', '2025-12-25 09:00:00', 'Holiday', 'A major holiday celebrated around the world, Christmas commemorates the birth of Jesus Christ. It is marked by traditions such as gift-giving, festive decorations, and family gatherings, creating a warm and joyous atmosphere during the holiday season.');

SELECT * FROM my_events;

-- Extract info about datetime values
SELECT 
	event_name, event_date, event_datetime,
    YEAR(event_date) AS event_year,
    MONTH(event_date) AS every_month,
    DAYOFWEEK(event_date) AS event_dow
FROM my_events;

-- Spell out the full days of the week using CASE statements
WITH dow AS (
	SELECT 
		event_name, event_date, event_datetime,
		YEAR(event_date) AS event_year,
		MONTH(event_date) AS every_month,
		DAYOFWEEK(event_date) AS event_dow
	FROM my_events
)
SELECT *,
		CASE	WHEN event_dow = 1 THEN 'Sunday'
				WHEN event_dow = 2 THEN 'Monday'
				WHEN event_dow = 3 THEN 'Tuesday'
				WHEN event_dow = 4 THEN 'Wednesday'
				WHEN event_dow = 5 THEN 'Thursday'
                WHEN event_dow = 6 THEN 'Friday'
                WHEN event_dow = 7 THEN 'Saturday'
    ELSE 'Unknown' END AS event_dow_name
FROM dow;

-- Calculate an interval between datetime values
SELECT 
	event_name, event_date, event_datetime,
	CURRENT_DATE(), CURRENT_DATE() - event_date
FROM my_events;

SELECT 
	event_name, event_date, event_datetime,
	CURRENT_DATE(), DATEDIFF(event_date, CURRENT_DATE()) AS days_until
FROM my_events;

-- Calculate an interval between datetime value
SELECT
	event_name, event_date, event_datetime,
    DATE_ADD(event_datetime, INTERVAL 1 HOUR) AS plus_one_hour
FROM my_events;

SELECT
	event_name, event_date, event_datetime,
    DATE_ADD(event_datetime, INTERVAL 1 MINUTE) AS plus_one_hour
FROM my_events;

-- String Functions
-- Cleaned up event type and found the length of the description
USE maven_advanced_sql;

SELECT
	event_name, event_type,
    TRIM(REPLACE(event_type, '!', '')) AS event_type_clean,
    LENGTH(event_desc) AS desc_len
FROM my_events;

-- Change the case
SELECT event_name, UPPER(event_name), LOWER(event_name)
FROM my_events;

-- Combine the type and description columns
SELECT
	event_name, event_type_clean, event_desc,
    CONCAT(e.event_type_clean, ' | ', event_desc) AS full_desc
FROM my_events;

-- Combine the type and description columns
WITH my_events_clean AS(
	SELECT 
		event_name, event_type,
        TRIM(REPLACE(event_type, '!', '')) AS event_type_clean,
        event_desc,
        LENGTH(event_desc) AS desc_len
	FROM my_events
)
SELECT
	event_name, event_type_clean, event_desc,
    CONCAT(event_type_clean, ' | ', event_desc) AS full_desc
FROM my_events_clean;
