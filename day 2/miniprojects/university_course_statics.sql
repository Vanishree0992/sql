CREATE DATABASE university_db;
USE university_db;

CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100)
);

CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    student_name VARCHAR(100)
);

CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    grade DECIMAL(4,2), -- Example: 75.50
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

INSERT INTO courses (course_name) VALUES
('Mathematics'),
('Physics'),
('History'),
('Chemistry');

INSERT INTO students (student_name) VALUES
('Alice'),
('Bob'),
('Charlie'),
('David');

INSERT INTO enrollments (student_id, course_id, grade) VALUES
(1, 1, 85.0),   
(2, 1, 90.0),   
(3, 2, 65.0),   
(4, 1, 72.0),   
(1, 2, 40.0);   

-- Find the number of students per course.
SELECT 
    c.course_name,
    COUNT(e.student_id) AS student_count
FROM 
    courses c
LEFT JOIN 
    enrollments e ON c.course_id = e.course_id
GROUP BY 
    c.course_id;

-- List courses with no enrollments (LEFT JOIN).
SELECT 
    c.course_name
FROM 
    courses c
LEFT JOIN 
    enrollments e ON c.course_id = e.course_id
WHERE 
    e.course_id IS NULL;

-- Show courses where all students passed.
SELECT 
    c.course_name
FROM 
    courses c
JOIN 
    enrollments e ON c.course_id = e.course_id
GROUP BY 
    c.course_id
HAVING 
    MIN(e.grade) >= 50.0;
