CREATE DATABASE StudentAttendanceDB;
USE StudentAttendanceDB;

-- Tables: Students, Courses, Attendance.
CREATE TABLE Students (
    StudentID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Department VARCHAR(50)
);

USE StudentAttendanceDB;
CREATE TABLE Courses (
    CourseID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(100) NOT NULL,
    Credits INT
);

USE StudentAttendanceDB;
CREATE TABLE Attendance (
    AttendanceID INT AUTO_INCREMENT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    AttendanceDate DATE,
    Status ENUM('Present', 'Absent'),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

-- Insert attendance records for multiple students across different courses.
INSERT INTO Students (Name, Department) VALUES 
('Alice', 'Computer Science'),
('Bob', 'Mechanical'),
('Charlie', 'Electrical'),
('David', 'Civil');

INSERT INTO Courses (Title, Credits) VALUES 
('Mathematics', 3),
('Physics', 4),
('Programming', 4);

INSERT INTO Attendance (StudentID, CourseID, AttendanceDate, Status) VALUES 
(1, 1, '2025-07-01', 'Present'),
(1, 1, '2025-07-02', 'Present'),
(1, 1, '2025-07-03', 'Absent'),

(2, 1, '2025-07-01', 'Absent'),
(2, 1, '2025-07-02', 'Present'),
(2, 1, '2025-07-03', 'Present'),

(3, 2, '2025-07-01', 'Present'),
(3, 2, '2025-07-02', 'Present'),
(3, 2, '2025-07-03', 'Present'),

(4, 3, '2025-07-01', 'Absent'),
(4, 3, '2025-07-02', 'Absent'),
(4, 3, '2025-07-03', 'Present');

-- Query all students who have more than 90% attendance in a course.
SELECT 
    s.StudentID,
    s.Name,
    c.Title,
    COUNT(CASE WHEN a.Status = 'Present' THEN 1 END) AS DaysPresent,
    COUNT(*) AS TotalDays,
    ROUND((COUNT(CASE WHEN a.Status = 'Present' THEN 1 END) / COUNT(*)) * 100, 2) AS AttendancePercentage
FROM 
    Attendance a
JOIN 
    Students s ON a.StudentID = s.StudentID
JOIN 
    Courses c ON a.CourseID = c.CourseID
GROUP BY 
    s.StudentID, c.CourseID
HAVING 
    AttendancePercentage > 90;
    
-- List students absent on a specific date.
SELECT 
    s.StudentID,
    s.Name,
    c.Title,
    a.AttendanceDate
FROM 
    Attendance a
JOIN 
    Students s ON a.StudentID = s.StudentID
JOIN 
    Courses c ON a.CourseID = c.CourseID
WHERE 
    a.Status = 'Absent'
    AND a.AttendanceDate = '2025-07-02';
