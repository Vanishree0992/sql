CREATE DATABASE OnlineEducation;
USE OnlineEducation;

CREATE TABLE Students (
  StudentID INT PRIMARY KEY AUTO_INCREMENT,
  FirstName VARCHAR(50) NOT NULL,
  LastName VARCHAR(50) NOT NULL,
  Email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Courses (
  CourseID INT PRIMARY KEY AUTO_INCREMENT,
  CourseName VARCHAR(100) NOT NULL,
  Instructor VARCHAR(100) NOT NULL
);

CREATE TABLE Enrollments (
  EnrollmentID INT PRIMARY KEY AUTO_INCREMENT,
  StudentID INT NOT NULL,
  CourseID INT NOT NULL,
  EnrollmentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
  FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

CREATE TABLE Grades (
  GradeID INT PRIMARY KEY AUTO_INCREMENT,
  EnrollmentID INT NOT NULL,
  Score DECIMAL(5,2) NOT NULL CHECK (Score >= 0),
  GradeDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (EnrollmentID) REFERENCES Enrollments(EnrollmentID)
);

INSERT INTO Students (FirstName, LastName, Email)
VALUES
('Alice', 'Johnson', 'alice@example.com'),
('Bob', 'Smith', 'bob@example.com'),
('Carol', 'White', 'carol@example.com'),
('David', 'Brown', 'david@example.com'),
('Eva', 'Black', 'eva@example.com');

INSERT INTO Courses (CourseName, Instructor)
VALUES
('SQL Basics', 'Prof. Adams'),
('Python Programming', 'Prof. Baker'),
('Data Analysis', 'Prof. Clark');

INSERT INTO Enrollments (StudentID, CourseID)
VALUES
(1, 1),
(2, 1),
(3, 1),
(1, 2),
(2, 2),
(4, 2),
(5, 2),
(1, 3),
(3, 3),
(4, 3),
(5, 3);

INSERT INTO Grades (EnrollmentID, Score)
VALUES
(1, 85.5),
(2, 75.0),
(3, 90.0),
(4, 88.0),
(5, 79.0),
(6, 92.0),
(7, 70.0),
(8, 95.0),
(9, 89.0),
(10, 60.0),
(11, 83.0);

--	Use JOIN to combine student and course data.
SELECT s.FirstName, s.LastName, c.CourseName, g.Score
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
JOIN Grades g ON e.EnrollmentID = g.EnrollmentID
ORDER BY s.LastName;

--	Use subqueries to get students who scored above the average in each course.
SELECT s.FirstName, s.LastName, c.CourseName, g.Score
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
JOIN Grades g ON e.EnrollmentID = g.EnrollmentID
WHERE g.Score > (
  SELECT AVG(g2.Score)
  FROM Enrollments e2
  JOIN Grades g2 ON e2.EnrollmentID = g2.EnrollmentID
  WHERE e2.CourseID = c.CourseID
);

--	Use GROUP BY, HAVING to show courses with more than 10 enrollments.
SELECT c.CourseName, COUNT(e.EnrollmentID) AS TotalEnrollments
FROM Courses c
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.CourseName
HAVING COUNT(e.EnrollmentID) > 10;

--	Enforce NOT NULL, CHECK (score >= 0) constraints.
