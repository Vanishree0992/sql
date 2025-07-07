CREATE DATABASE StudentResultsDB;
USE StudentResultsDB;

CREATE TABLE Students (
  StudentID INT PRIMARY KEY AUTO_INCREMENT,
  FirstName VARCHAR(50) NOT NULL,
  LastName VARCHAR(50) NOT NULL,
  Class VARCHAR(20) NOT NULL
);

CREATE TABLE Subjects (
  SubjectID INT PRIMARY KEY AUTO_INCREMENT,
  SubjectName VARCHAR(50) NOT NULL
);

CREATE TABLE Marks (
  MarkID INT PRIMARY KEY AUTO_INCREMENT,
  StudentID INT NOT NULL,
  SubjectID INT NOT NULL,
  MarksObtained INT NOT NULL CHECK (MarksObtained >= 0 AND MarksObtained <= 100),
  FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
  FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)
);

INSERT INTO Students (FirstName, LastName, Class)
VALUES
('Alice', 'Brown', '10-A'),
('Bob', 'Smith', '10-A'),
('Carol', 'Johnson', '10-A');

INSERT INTO Subjects (SubjectName)
VALUES
('Math'),
('Science'),
('English');

INSERT INTO Marks (StudentID, SubjectID, MarksObtained)
VALUES
(1, 1, 85), 
(1, 2, 90), 
(1, 3, 88), 
(2, 1, 75), 
(2, 2, 80), 
(2, 3, 70), 
(3, 1, 92), 
(3, 2, 95), 
(3, 3, 90);

--	Use JOIN and GROUP BY to get total marks.
SELECT 
  s.StudentID,
  s.FirstName,
  s.LastName,
  s.Class,
  SUM(m.MarksObtained) AS TotalMarks
FROM Students s
JOIN Marks m ON s.StudentID = m.StudentID
GROUP BY s.StudentID, s.FirstName, s.LastName, s.Class
ORDER BY TotalMarks DESC;

--	Use subqueries or RANK() (if available) for ranking.
SELECT 
  StudentID,
  FirstName,
  LastName,
  Class,
  TotalMarks,
  RANK() OVER (ORDER BY TotalMarks DESC) AS RankPosition
FROM (
  SELECT 
    s.StudentID,
    s.FirstName,
    s.LastName,
    s.Class,
    SUM(m.MarksObtained) AS TotalMarks
  FROM Students s
  JOIN Marks m ON s.StudentID = m.StudentID
  GROUP BY s.StudentID
) AS TotalResults;

--	Use CASE for grades based on mark ranges.
SELECT 
  StudentID,
  FirstName,
  LastName,
  TotalMarks,
  CASE 
    WHEN TotalMarks >= 90 THEN 'A+'
    WHEN TotalMarks >= 75 THEN 'A'
    WHEN TotalMarks >= 60 THEN 'B'
    ELSE 'C'
  END AS Grade
FROM (
  SELECT 
    s.StudentID,
    s.FirstName,
    s.LastName,
    SUM(m.MarksObtained) AS TotalMarks
  FROM Students s
  JOIN Marks m ON s.StudentID = m.StudentID
  GROUP BY s.StudentID
) AS StudentTotals;

--	Enforce constraints to prevent invalid scores
ALTER TABLE Marks
ADD CONSTRAINT chk_marks CHECK (MarksObtained >= 0 AND MarksObtained <= 100);
