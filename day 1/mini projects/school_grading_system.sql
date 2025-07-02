-- Create the database
CREATE DATABASE SchoolGradingDB;

-- Use the database
USE SchoolGradingDB;
 
-- creating tables
CREATE TABLE Students (
    StudentID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Class VARCHAR(20)
);

CREATE TABLE Subjects (
    SubjectID INT AUTO_INCREMENT PRIMARY KEY,
    SubjectName VARCHAR(100) NOT NULL
);

CREATE TABLE Grades (
    GradeID INT AUTO_INCREMENT PRIMARY KEY,
    StudentID INT,
    SubjectID INT,
    Grade DECIMAL(5,2),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)
);

-- Insert grades for students in various subjects.
INSERT INTO Students (Name, Class) 
VALUES 
('Alice', '10A'),
('Bob', '10A'),
('Charlie', '10B'),
('David', '10B'),
('Eva', '10C');

INSERT INTO Subjects (SubjectName) 
VALUES 
('Mathematics'),
('Science'),
('English');

INSERT INTO Grades (StudentID, SubjectID, Grade) 
VALUES 
(1, 1, 95.00), -- Alice, Math
(2, 1, 88.00), -- Bob, Math
(3, 1, 76.00), -- Charlie, Math
(4, 1, 92.00), -- David, Math
(5, 1, 55.00), -- Eva, Math

(1, 2, 89.00), -- Alice, Science
(2, 2, 92.00), -- Bob, Science
(3, 2, 65.00), -- Charlie, Science
(4, 2, 78.00), -- David, Science
(5, 2, 50.00), -- Eva, Science

(1, 3, 85.00), -- Alice, English
(2, 3, 70.00), -- Bob, English
(3, 3, 90.00), -- Charlie, English
(4, 3, 82.00), -- David, English
(5, 3, 45.00); -- Eva, English

-- Query students with highest grade per subject.
SELECT 
    s.SubjectName,
    st.Name AS StudentName,
    g.Grade
FROM 
    Grades g
JOIN 
    Students st ON g.StudentID = st.StudentID
JOIN 
    Subjects s ON g.SubjectID = s.SubjectID
WHERE 
    (s.SubjectID, g.Grade) IN (
        SELECT 
            SubjectID,
            MAX(Grade)
        FROM 
            Grades
        GROUP BY 
            SubjectID
    );


-- List students who failed (grade below passing threshold).
SELECT 
    st.Name AS StudentName,
    s.SubjectName,
    g.Grade
FROM 
    Grades g
JOIN 
    Students st ON g.StudentID = st.StudentID
JOIN 
    Subjects s ON g.SubjectID = s.SubjectID
WHERE 
    g.Grade < 50;
