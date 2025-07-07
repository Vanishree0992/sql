CREATE DATABASE University_trackerDB;
USE University_trackerDB;

CREATE TABLE Courses (
  CourseID INT PRIMARY KEY AUTO_INCREMENT,
  CourseName VARCHAR(100) NOT NULL,
  MaxCapacity INT NOT NULL CHECK (MaxCapacity > 0)
);

CREATE TABLE Students (
  StudentID INT PRIMARY KEY AUTO_INCREMENT,
  StudentName VARCHAR(100) NOT NULL
);

CREATE TABLE Enrollments (
  EnrollmentID INT PRIMARY KEY AUTO_INCREMENT,
  StudentID INT NOT NULL,
  CourseID INT NOT NULL,
  EnrollDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
  FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

INSERT INTO Courses (CourseName, MaxCapacity)
VALUES ('Math 101', 2), ('Physics 201', 3);

INSERT INTO Students (StudentName)
VALUES ('Alice'), ('Bob'), ('Carol'), ('David');

-- •	Use CHECK or a controlled procedure to limit max enrollments.
SELECT 
  c.CourseID,
  c.CourseName,
  c.MaxCapacity,
  COUNT(e.EnrollmentID) AS CurrentEnrollment
FROM Courses c
LEFT JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY c.CourseID, c.CourseName, c.MaxCapacity;

-- •	Use subqueries to block over-capacity courses.
SELECT 
  (SELECT COUNT(*) FROM Enrollments WHERE CourseID = 1) AS CurrentEnrolled,
  (SELECT MaxCapacity FROM Courses WHERE CourseID = 1) AS MaxCapacity;

-- •	Use INSERT INTO with validation logic.
START TRANSACTION;

SELECT COUNT(*) INTO @current FROM Enrollments WHERE CourseID = 1;
SELECT MaxCapacity INTO @maxcap FROM Courses WHERE CourseID = 1;

INSERT INTO Enrollments (StudentID, CourseID)
SELECT 4, 1
WHERE @current < @maxcap;

SELECT ROW_COUNT();

COMMIT;

