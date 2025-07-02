-- Create the database
CREATE DATABASE UniversityDB;

-- Use the database
USE UniversityDB;

-- create table
CREATE TABLE Students (
    StudentID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100)
);

CREATE TABLE Courses (
    CourseID INT AUTO_INCREMENT PRIMARY KEY,
    CourseName VARCHAR(100) NOT NULL,
    Credits INT
);

CREATE TABLE Enrollments (
    EnrollmentID INT AUTO_INCREMENT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

-- inserting data
INSERT INTO Students (Name, Email)
 VALUES
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com'),
('Charlie', 'charlie@example.com'),
('David', 'david@example.com');

INSERT INTO Courses (CourseName, Credits) 
VALUES
('Mathematics', 3),
('Physics', 4),
('Chemistry', 4),
('Computer Science', 3),
('History', 2);

INSERT INTO Enrollments (StudentID, CourseID, EnrollmentDate) 
VALUES
(1, 1, '2025-07-01'),
(1, 2, '2025-07-02'),
(1, 3, '2025-07-03'), 
(2, 1, '2025-07-02'),
(2, 2, '2025-07-03'),
(3, 1, '2025-07-01'),
(3, 4, '2025-07-04'),
(4, 2, '2025-07-02');

-- courses with no enrollments 
SELECT 
    c.CourseID,
    c.CourseName
FROM 
    Courses c
LEFT JOIN 
    Enrollments e ON c.CourseID = e.CourseID
WHERE 
    e.CourseID IS NULL;

-- students enrolled in more than 2 courses
SELECT 
    s.StudentID,
    s.Name,
    COUNT(e.EnrollmentID) AS EnrolledCourses
FROM 
    Students s
JOIN 
    Enrollments e ON s.StudentID = e.StudentID
GROUP BY 
    s.StudentID, s.Name
HAVING 
    EnrolledCourses > 2;
