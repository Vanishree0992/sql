CREATE DATABASE onlineDB;
USE onlineDB;

CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    instructor VARCHAR(100)
);
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY,
    user_id INT,
    course_id INT,
    enrollment_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);
CREATE TABLE completions (
    completion_id INT PRIMARY KEY,
    user_id INT,
    course_id INT,
    completion_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);



INSERT INTO courses 
VALUES
(1, 'SQL Basics', 'Alice'),
(2, 'Advanced Python', 'Bob'),
(3, 'Data Science 101', 'Carol');


INSERT INTO users 
VALUES
(1, 'John', 'john@example.com'),
(2, 'Sara', 'sara@example.com'),
(3, 'Tom', 'tom@example.com'),
(4, 'Nina', 'nina@example.com');


INSERT INTO enrollments 
VALUES
(1, 1, 1, '2025-06-01'),
(2, 1, 2, '2025-06-03'),
(3, 2, 1, '2025-06-05'),
(4, 3, 3, '2025-06-07'),
(5, 4, 1, '2025-06-10'),
(6, 4, 2, '2025-06-12');


INSERT INTO completions 
VALUES
(1, 1, 1, '2025-06-10'),
(2, 2, 1, '2025-06-15'),
(3, 3, 3, '2025-06-20');

-- Count course completions per user.
SELECT 
    u.user_id,
    u.name,
    COUNT(c.completion_id) AS total_completions
FROM users u
LEFT JOIN completions c ON u.user_id = c.user_id
GROUP BY u.user_id, u.name;

-- List courses with less than 5 completions.
SELECT 
    co.course_id,
    co.course_name,
    COUNT(c.completion_id) AS completions
FROM courses co
LEFT JOIN completions c ON co.course_id = c.course_id
GROUP BY co.course_id, co.course_name
HAVING COUNT(c.completion_id) < 5;

-- Identify users enrolled but never completed any course.
SELECT DISTINCT 
    u.user_id,
    u.name
FROM users u
JOIN enrollments e ON u.user_id = e.user_id
LEFT JOIN completions c ON u.user_id = c.user_id
WHERE c.completion_id IS NULL;

