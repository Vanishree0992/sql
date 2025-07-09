CREATE DATABASE Online_CourseDB;
USE Online_CourseDB;


CREATE TABLE Students (
  student_id INT AUTO_INCREMENT PRIMARY KEY,
  student_name VARCHAR(100) NOT NULL,
  email VARCHAR(100)
);

CREATE TABLE Courses (
  course_id INT AUTO_INCREMENT PRIMARY KEY,
  course_name VARCHAR(150) NOT NULL,
  description TEXT
);

CREATE TABLE Enrollments (
  enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT NOT NULL,
  course_id INT NOT NULL,
  enroll_date DATE NOT NULL,
  FOREIGN KEY (student_id) REFERENCES Students(student_id),
  FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);


CREATE INDEX idx_student_name ON Students(student_name);
CREATE INDEX idx_course_name ON Courses(course_name);
CREATE INDEX idx_enroll_date ON Enrollments(enroll_date);

INSERT INTO Students (student_name, email) VALUES
('Alice Johnson', 'alice@example.com'),
('Bob Smith', 'bob@example.com'),
('Carol White', 'carol@example.com'),
('David Lee', 'david@example.com'),
('Eve Brown', 'eve@example.com');


INSERT INTO Courses (course_name, description) VALUES
('Intro to Python', 'Learn Python basics'),
('Advanced SQL', 'Deep dive into SQL'),
('Data Structures', 'Learn DS and algorithms'),
('Web Development', 'HTML, CSS, JS basics'),
('Machine Learning', 'Intro to ML concepts');


INSERT INTO Enrollments (student_id, course_id, enroll_date) VALUES
(1, 1, '2025-07-01'),
(1, 2, '2025-07-02'),
(1, 3, '2025-07-03'),
(1, 4, '2025-07-04'),
(1, 5, '2025-07-05'),
(2, 1, '2025-07-01'),
(2, 2, '2025-07-02'),
(2, 3, '2025-07-03'),
(2, 4, '2025-07-04'),
(2, 5, '2025-07-05'),
(3, 1, '2025-07-01'),
(3, 2, '2025-07-02'),
(3, 3, '2025-07-03'),
(3, 4, '2025-07-04'),
(3, 5, '2025-07-05'),
(4, 1, '2025-07-01'),
(4, 2, '2025-07-02'),
(4, 3, '2025-07-03'),
(4, 4, '2025-07-04'),
(4, 5, '2025-07-05'),
(5, 1, '2025-07-01'),
(5, 2, '2025-07-02'),
(5, 3, '2025-07-03'),
(5, 4, '2025-07-04'),
(5, 5, '2025-07-05');


EXPLAIN
SELECT 
  e.enrollment_id,
  s.student_name,
  c.course_name,
  e.enroll_date
FROM Enrollments e
JOIN Students s ON e.student_id = s.student_id
JOIN Courses c ON e.course_id = c.course_id
WHERE s.student_name = 'Alice Johnson'
ORDER BY e.enroll_date DESC;

EXPLAIN
SELECT 
  enrollment_id,
  (SELECT student_name FROM Students WHERE student_id = e.student_id) AS student_name,
  (SELECT course_name FROM Courses WHERE course_id = e.course_id) AS course_name,
  enroll_date
FROM Enrollments e
WHERE student_id = 1
ORDER BY enroll_date DESC;

CREATE OR REPLACE VIEW EnrollmentReport AS
SELECT 
  e.enrollment_id,
  s.student_name,
  s.email,
  c.course_name,
  c.description,
  e.enroll_date
FROM Enrollments e
JOIN Students s ON e.student_id = s.student_id
JOIN Courses c ON e.course_id = c.course_id;

SELECT *
FROM EnrollmentReport
WHERE student_name = 'Alice Johnson'
ORDER BY enroll_date DESC
LIMIT 5;