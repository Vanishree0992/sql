CREATE DATABASE ELearning_Analytics;
USE ELearning_Analytics;

CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100)
);

CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE enrollments_free (
    enrollment_id INT PRIMARY KEY,
    course_id INT,
    enrollment_date DATE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

CREATE TABLE enrollments_paid (
    enrollment_id INT PRIMARY KEY,
    course_id INT,
    enrollment_date DATE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

INSERT INTO categories VALUES
(1, 'Programming'),
(2, 'Design'),
(3, 'Marketing');

INSERT INTO courses VALUES
(101, 'Python Basics', 1),
(102, 'UI/UX Design', 2),
(103, 'Digital Marketing', 3),
(104, 'Advanced Python', 1);

INSERT INTO enrollments_free VALUES
(1, 101, '2025-01-10'),
(2, 101, '2025-01-12'),
(3, 102, '2025-01-13'),
(4, 104, '2025-01-15');

INSERT INTO enrollments_paid VALUES
(5, 101, '2025-01-20'),
(6, 102, '2025-01-21'),
(7, 103, '2025-01-25'),
(8, 104, '2025-01-28'),
(9, 104, '2025-02-01');

--	Use UNION to combine enrollments from free and paid platforms.
SELECT course_id, enrollment_date FROM enrollments_free
UNION
SELECT course_id, enrollment_date FROM enrollments_paid;

SELECT course_id, enrollment_date FROM enrollments_free
UNION ALL
SELECT course_id, enrollment_date FROM enrollments_paid;

--	Use subquery to find average enrollment per course.
SELECT 
    course_id,
    COUNT(*) AS total_enrollments
FROM (
    SELECT course_id FROM enrollments_free
    UNION ALL
    SELECT course_id FROM enrollments_paid
) AS all_enrollments
GROUP BY course_id;
SELECT AVG(enroll_count) AS avg_enrollments
FROM (
    SELECT course_id, COUNT(*) AS enroll_count
    FROM (
        SELECT course_id FROM enrollments_free
        UNION ALL
        SELECT course_id FROM enrollments_paid
    ) AS all_enrollments
    GROUP BY course_id
) AS course_counts;

--	Use JOIN to connect courses and categories.
SELECT 
    c.course_name,
    cat.category_name
FROM courses c
JOIN categories cat ON c.category_id = cat.category_id;

--	Classify courses as Popular/Regular based on average.

WITH course_enrollments AS (
    SELECT 
        course_id,
        COUNT(*) AS total_enrollments
    FROM (
        SELECT course_id FROM enrollments_free
        UNION ALL
        SELECT course_id FROM enrollments_paid
    ) AS all_enrollments
    GROUP BY course_id
),


average_enroll AS (
    SELECT AVG(total_enrollments) AS avg_enrollments FROM course_enrollments
)


SELECT 
    c.course_name,
    cat.category_name,
    ce.total_enrollments,
    CASE
        WHEN ce.total_enrollments > ae.avg_enrollments THEN 'Popular'
        ELSE 'Regular'
    END AS popularity_status
FROM course_enrollments ce
JOIN courses c ON ce.course_id = c.course_id
JOIN categories cat ON c.category_id = cat.category_id
CROSS JOIN average_enroll ae;
