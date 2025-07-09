CREATE DATABASE exam_management_db;
USE exam_management_db;

CREATE TABLE Students (
  student_id INT AUTO_INCREMENT PRIMARY KEY,
  student_name VARCHAR(100),
  email VARCHAR(100)
);

INSERT INTO Students (student_name, email) VALUES
('Alice Johnson', 'alice@student.com'),
('Bob Smith', 'bob@student.com'),
('Charlie Lee', 'charlie@student.com'),
('Diana Prince', 'diana@student.com'),
('Eve Adams', 'eve@student.com'),
('Frank White', 'frank@student.com'),
('Grace Kim', 'grace@student.com'),
('Henry Ford', 'henry@student.com'),
('Ivy Green', 'ivy@student.com'),
('Jack Black', 'jack@student.com'),
('Karen Hall', 'karen@student.com'),
('Leo Brown', 'leo@student.com'),
('Mona Reed', 'mona@student.com'),
('Nina Stone', 'nina@student.com'),
('Oscar Wood', 'oscar@student.com'),
('Paul Nash', 'paul@student.com'),
('Quincy Fox', 'quincy@student.com'),
('Rachel Ray', 'rachel@student.com'),
('Steve Cook', 'steve@student.com'),
('Tina Bell', 'tina@student.com');


CREATE TABLE Subjects (
  subject_id INT AUTO_INCREMENT PRIMARY KEY,
  subject_name VARCHAR(50)
);

INSERT INTO Subjects (subject_name) VALUES
('Math'),
('Science'),
('English'),
('History'),
('Computer Science');

CREATE TABLE Exams (
  exam_id INT AUTO_INCREMENT PRIMARY KEY,
  subject_id INT,
  exam_date DATE,
  FOREIGN KEY (subject_id) REFERENCES Subjects(subject_id)
);

INSERT INTO Exams (subject_id, exam_date) VALUES
(1, '2024-06-01'),
(2, '2024-06-02'),
(3, '2024-06-03'),
(4, '2024-06-04'),
(5, '2024-06-05');

CREATE TABLE Scores (
  score_id INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT,
  exam_id INT,
  score INT,
  FOREIGN KEY (student_id) REFERENCES Students(student_id),
  FOREIGN KEY (exam_id) REFERENCES Exams(exam_id)
);

-- Insert 50+ random scores
INSERT INTO Scores (student_id, exam_id, score) VALUES
(1, 1, 85), (1, 2, 78), (1, 3, 90), (2, 1, 65), (2, 2, 70),
(2, 3, 75), (3, 1, 88), (3, 2, 92), (3, 3, 80), (4, 1, 55),
(4, 2, 60), (4, 3, 58), (5, 1, 95), (5, 2, 85), (5, 3, 82),
(6, 1, 67), (6, 2, 72), (6, 3, 70), (7, 1, 77), (7, 2, 80),
(7, 3, 85), (8, 1, 90), (8, 2, 88), (8, 3, 92), (9, 1, 50),
(9, 2, 55), (9, 3, 60), (10, 1, 82), (10, 2, 79), (10, 3, 85),
(11, 1, 70), (11, 2, 72), (11, 3, 74), (12, 1, 68), (12, 2, 65),
(12, 3, 70), (13, 1, 95), (13, 2, 90), (13, 3, 92), (14, 1, 80),
(14, 2, 85), (14, 3, 87), (15, 1, 77), (15, 2, 75), (15, 3, 80),
(16, 1, 66), (16, 2, 68), (16, 3, 70), (17, 1, 82), (17, 2, 84),
(17, 3, 86), (18, 1, 55), (18, 2, 60), (18, 3, 65), (19, 1, 90),
(19, 2, 88), (19, 3, 92), (20, 1, 78), (20, 2, 80), (20, 3, 85);

CREATE INDEX idx_student_id ON Scores(student_id);
CREATE INDEX idx_exam_date ON Exams(exam_date);
CREATE INDEX idx_score ON Scores(score);

SELECT 
  s.student_id,
  s.student_name,
  sc.score,
  CASE 
    WHEN sc.score >= 85 THEN 'A'
    WHEN sc.score >= 70 THEN 'B'
    WHEN sc.score >= 55 THEN 'C'
    ELSE 'D'
  END AS grade
FROM Students s
JOIN Scores sc ON s.student_id = sc.student_id
LIMIT 10;

EXPLAIN SELECT 
  s.student_name,
  sub.subject_name,
  sc.score,
  e.exam_date
FROM Scores sc
JOIN Students s ON sc.student_id = s.student_id
JOIN Exams e ON sc.exam_id = e.exam_id
JOIN Subjects sub ON e.subject_id = sub.subject_id
WHERE sc.score > 70;

CREATE TABLE StudentScoresDashboard (
  student_id INT,
  student_name VARCHAR(100),
  subject_name VARCHAR(50),
  exam_date DATE,
  score INT
);

INSERT INTO StudentScoresDashboard
SELECT 
  s.student_id,
  s.student_name,
  sub.subject_name,
  e.exam_date,
  sc.score
FROM Scores sc
JOIN Students s ON sc.student_id = s.student_id
JOIN Exams e ON sc.exam_id = e.exam_id
JOIN Subjects sub ON e.subject_id = sub.subject_id;

SELECT * FROM StudentScoresDashboard LIMIT 5;

SELECT 
  student_id,
  student_name,
  score
FROM StudentScoresDashboard
ORDER BY score DESC
LIMIT 5;