SELECT * FROM students;

-- Example Code
SELECT grade_level, AVG(gpa) AS avg_gpa
FROM students
GROUP BY grade_level
HAVING avg_gpa < 3.3
ORDER BY grade_level;

-- Comparsion operaters 
SELECT *
FROM students
WHERE grade_level < 12 AND school_lunch = 'Yes';

-- Comparsion operaters 
SELECT *
FROM students
WHERE grade_level IN (10, 11, 12)
ORDER BY grade_level, gpa;

-- Comparsion operaters 
SELECT *
FROM students
WHERE email LIKE '%.com';


-- Another Key word is the limit and desc
SELECT *
FROM students
ORDER BY gpa DESC;

-- Key word is Limit
SELECT *
FROM students
LIMIT 10;

-- Using the case statements
SELECT 
	student_name, grade_level,
    CASE
		WHEN grade_level = 9 THEN 'Freshman'
        WHEN grade_level = 10 THEN 'Sophomore'
        WHEN grade_level = 11 THEN 'Junior'
        ELSE 'Senior' 
	END AS student_class
FROM students
ORDER BY grade_level
