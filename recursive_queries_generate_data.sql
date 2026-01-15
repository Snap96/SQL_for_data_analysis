WITH RECURSIVE numbers (n) AS
(
	SELECT 0
    UNION ALL 
    SELECT n + 1
    FROM numbers
    WHERE n < 100
)
SELECT n FROM numbers;

WITH RECURSIVE dates(d) AS
(
	SELECT '2002-01-01'
    UNION ALL
    SELECT DATE_ADD(d, INTERVAL 1 MONTH)
    FROM dates
    WHERE d < '2022-12-31'
)
SELECT d FROM dates;