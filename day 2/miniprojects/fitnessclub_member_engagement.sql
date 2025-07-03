CREATE DATABASE fitness_clubDB;
USE fitness_clubDB;


CREATE TABLE members (
    member_id INT PRIMARY KEY,
    name VARCHAR(100),
    join_date DATE
);


CREATE TABLE classes (
    class_id INT PRIMARY KEY,
    class_name VARCHAR(100),
    instructor VARCHAR(100)
);

CREATE TABLE attendance (
    attendance_id INT PRIMARY KEY,
    member_id INT,
    class_id INT,
    attendance_date DATE,
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (class_id) REFERENCES classes(class_id)
);



INSERT INTO members
 VALUES
(1, 'Alice', '2023-01-15'),
(2, 'Bob', '2023-03-10'),
(3, 'Charlie', '2023-05-22'),
(4, 'Diana', '2023-06-01');


INSERT INTO classes 
VALUES
(1, 'Yoga', 'Instructor A'),
(2, 'Pilates', 'Instructor B'),
(3, 'HIIT', 'Instructor C');


INSERT INTO attendance 
VALUES
(1, 1, 1, '2023-06-05'),
(2, 1, 2, '2023-06-06'),
(3, 2, 1, '2023-06-05'),
(4, 2, 1, '2023-06-07'),
(5, 3, 3, '2023-06-10');


-- Count class attendance per member.
SELECT 
    m.member_id,
    m.name,
    COUNT(a.attendance_id) AS total_attendance
FROM members m
LEFT JOIN attendance a ON m.member_id = a.member_id
GROUP BY m.member_id, m.name;

-- Identify members with no attendance (LEFT JOIN).
SELECT 
    m.member_id,
    m.name
FROM members m
LEFT JOIN attendance a ON m.member_id = a.member_id
WHERE a.attendance_id IS NULL;

-- List classes with highest average attendance
SELECT 
    c.class_id,
    c.class_name,
    COUNT(a.attendance_id) AS total_attendance
FROM classes c
LEFT JOIN attendance a ON c.class_id = a.class_id
GROUP BY c.class_id, c.class_name
ORDER BY total_attendance DESC;

