-- Assignment 1
/*
SELECT employee_name, COUNT(*) AS dup_count
FROM employee_details
GROUP BY employee_name
HAVING dup_count > 1;
*/


SELECT * FROM students;

SELECT s.student_name, COUNT(s.email)
FROM students s
GROUP BY s.student_name;

-- Noah Scott appears twice

-- Create a column that counts the number of times a student appears in the table
WITH sc AS (
	SELECT *,
		ROW_NUMBER() OVER(PARTITION BY s.student_name ORDER BY s.id DESC) AS student_count
    FROM students s
)
SELECT id, student_name, grade_level, gpa, school_lunch, birthday, email
FROM sc
WHERE student_count = 1;

