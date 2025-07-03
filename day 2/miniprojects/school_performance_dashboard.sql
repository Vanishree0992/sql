CREATE DATABASE schooldashboard;
USE schooldashboard;

CREATE TABLE students (
    student_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE classes (
    class_id INTEGER PRIMARY KEY,
    class_name TEXT NOT NULL
);

CREATE TABLE grades (
    grade_id INTEGER PRIMARY KEY,
    student_id INTEGER,
    class_id INTEGER,
    grade REAL CHECK(grade >= 0 AND grade <= 100),
    FOREIGN KEY(student_id) REFERENCES students(student_id),
    FOREIGN KEY(class_id) REFERENCES classes(class_id)
);

INSERT INTO students (student_id, name) 
VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');


INSERT INTO classes (class_id, class_name) 
VALUES
(1, 'Math'),
(2, 'Science'),
(3, 'History');


INSERT INTO grades (grade_id, student_id, class_id, grade) 
VALUES
(1, 1, 1, 85),
(2, 1, 2, 78),
(3, 2, 1, 92),
(4, 2, 3, 88),
(5, 3, 2, 55),
(6, 3, 3, 60);


-- Find average grade per student and per class.
SELECT s.name AS student_name, 
       ROUND(AVG(g.grade), 2) AS average_grade
FROM students s
JOIN grades g ON s.student_id = g.student_id
GROUP BY s.student_id;

SELECT c.class_name, 
       ROUND(AVG(g.grade), 2) AS average_grade
FROM classes c
JOIN grades g ON c.class_id = g.class_id
GROUP BY c.class_id;

--  List classes where the average grade is below a set value.
SELECT c.class_name, 
       ROUND(AVG(g.grade), 2) AS average_grade
FROM classes c
JOIN grades g ON c.class_id = g.class_id
GROUP BY c.class_id
HAVING AVG(g.grade) < 70;


-- Identify students with the highest and lowest grades.
-- Highest Grade
SELECT s.name, g.grade
FROM grades g
JOIN students s ON g.student_id = s.student_id
WHERE g.grade = (SELECT MAX(grade) FROM grades);

-- Lowest Grade
SELECT s.name, g.grade
FROM grades g
JOIN students s ON g.student_id = s.student_id
WHERE g.grade = (SELECT MIN(grade) FROM grades);
