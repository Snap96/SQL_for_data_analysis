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

-- ASSIGNMENT 2: Min/Max value filtering
-- View the students and student grades tables
USE maven_advanced_sql;

SELECT * FROM students;
SELECT * FROM student_grades;

-- For each student, return the classes they took and their final grades
SELECT 
	s.id, s.student_name, sg.class_name, sg.final_grade
FROM students s
LEFT JOIN student_grades sg
ON s.id = sg.student_id;

-- Return each student's top grade and corresponding class:
-- APPROACH 1: GROUP BY + JOIN

SELECT 
	s.id, s.student_name, MAX(sg.final_grade) AS top_grade
FROM students s
LEFT JOIN student_grades sg
ON s.id = sg.student_id
GROUP BY s.id, s.student_name;

-- To avoid null values we must use a inner join
SELECT 
	s.id, s.student_name, MAX(sg.final_grade) AS top_grade
FROM students s
INNER JOIN student_grades sg
ON s.id = sg.student_id
GROUP BY s.id, s.student_name
ORDER BY s.id;

-- Final GROUP BY + JOIN query
WITH tg AS (
	SELECT 
		s.id, s.student_name, MAX(sg.final_grade) AS top_grade
	FROM students s
	INNER JOIN student_grades sg
	ON s.id = sg.student_id
	GROUP BY s.id, s.student_name
	ORDER BY s.id
)
SELECT 
	tg.id, tg.student_name, tg.top_grade, sg.class_name
FROM tg 
LEFT JOIN student_grades sg
ON tg.id = sg.student_id AND tg.top_grade = sg.final_grade;

-- APPROACH 2: Window function
-- Rank the student grades for each student
SELECT 
	s.id, s.student_name, sg.class_name, sg.final_grade,
    DENSE_RANK() OVER(PARTITION BY s.student_name ORDER BY sg.final_grade DESC) AS grade_rank
FROM students s
LEFT JOIN student_grades sg
ON s.id = sg.student_id;

-- Final window function query
SELECT * FROM
(
	SELECT 
	s.id, s.student_name, sg.class_name, sg.final_grade,
    DENSE_RANK() OVER(PARTITION BY s.student_name ORDER BY sg.final_grade DESC) AS grade_rank
	FROM students s
	LEFT JOIN student_grades sg
	ON s.id = sg.student_id
) AS gr
WHERE grade_rank = 1;

-- ASSIGNMENT 3: Pivoting
-- Combine the students and student grades tables
 SELECT 
	s.grade_level, sg.department, sg.final_grade
FROM students s
LEFT JOIN student_grades sg
ON s.id = sg.student_id;

-- Pivot the grade level column
SELECT 
	s.grade_level, sg.final_grade,
    CASE WHEN s.grade_level = 9 THEN 1 ELSE 0 END AS freshman,
    CASE WHEN s.grade_level = 10 THEN 1 ELSE 0 END AS sophomore,
    CASE WHEN s.grade_level = 11 THEN 1 ELSE 0 END AS junior,
    CASE WHEN s.grade_level = 12 THEN 1 ELSE 0 END AS senior
FROM students s
LEFT JOIN student_grades sg
ON s.id = sg.student_id;

-- Update the values to be final grades
SELECT 
	s.grade_level, 
    CASE WHEN s.grade_level = 9 THEN sg.final_grade ELSE 0 END AS freshman,
    CASE WHEN s.grade_level = 10 THEN sg.final_grade ELSE 0 END AS sophomore,
    CASE WHEN s.grade_level = 11 THEN sg.final_grade ELSE 0 END AS junior,
    CASE WHEN s.grade_level = 12 THEN sg.final_grade ELSE 0 END AS senior
FROM students s
LEFT JOIN student_grades sg
ON s.id = sg.student_id;

-- final summary table
SELECT 
	sg.department, 
    ROUND(AVG(CASE WHEN s.grade_level = 9 THEN sg.final_grade END)) AS freshman,
    ROUND(AVG(CASE WHEN s.grade_level = 10 THEN sg.final_grade END)) AS sophomore,
    ROUND(AVG(CASE WHEN s.grade_level = 11 THEN sg.final_grade END)) AS junior,
    ROUND(AVG(CASE WHEN s.grade_level = 12 THEN sg.final_grade END)) AS senior
FROM students s
LEFT JOIN student_grades sg
ON s.id = sg.student_id
WHERE sg.department IS NOT NULL
GROUP BY sg.department
ORDER BY sg.department;