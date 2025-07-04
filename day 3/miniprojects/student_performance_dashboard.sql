CREATE DATABASE Education_Performance;
USE Education_Performance;

CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100)
);

CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100)
);

CREATE TABLE marks (
    mark_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    marks_obtained DECIMAL(5,2),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

INSERT INTO students 
VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie'),
(4, 'David');

INSERT INTO courses 
VALUES
(101, 'Mathematics'),
(102, 'Science'),
(103, 'English');

INSERT INTO marks 
VALUES
(1, 1, 101, 78),
(2, 1, 102, 85),
(3, 1, 103, 90),
(4, 2, 101, 60),
(5, 2, 102, 65),
(6, 2, 103, 70),
(7, 3, 101, 40),
(8, 3, 102, 55),
(9, 3, 103, 45),
(10, 4, 101, 88),
(11, 4, 102, 92),
(12, 4, 103, 95);

--	Use subqueries to calculate subject-wise and overall average marks.
SELECT 
    c.course_name,
    AVG(m.marks_obtained) AS avg_marks
FROM marks m
JOIN courses c ON m.course_id = c.course_id
GROUP BY c.course_name;
SELECT AVG(marks_obtained) AS overall_avg
FROM marks;
--	Use CASE to tag students as Pass, Merit, Distinction.
SELECT 
    s.student_id,
    s.student_name,
    AVG(m.marks_obtained) AS average_score,
    CASE
        WHEN AVG(m.marks_obtained) >= 85 THEN 'Distinction'
        WHEN AVG(m.marks_obtained) >= 60 THEN 'Merit'
        ELSE 'Pass'
    END AS performance
FROM students s
JOIN marks m ON s.student_id = m.student_id
GROUP BY s.student_id, s.student_name;

--	Use JOIN to combine student and course tables.
SELECT 
    s.student_name,
    c.course_name,
    m.marks_obtained
FROM marks m
JOIN students s ON m.student_id = s.student_id
JOIN courses c ON m.course_id = c.course_id;

--	Filter students above average using WHERE with subquery
SELECT 
    s.student_id,
    s.student_name,
    AVG(m.marks_obtained) AS avg_marks
FROM students s
JOIN marks m ON s.student_id = m.student_id
GROUP BY s.student_id, s.student_name
HAVING AVG(m.marks_obtained) > (
    SELECT AVG(marks_obtained) FROM marks
);
