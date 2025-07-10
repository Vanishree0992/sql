CREATE DATABASE students_information;
USE students_information;

CREATE TABLE Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    batch_year INT,
    department VARCHAR(50),
    admission_date DATE
);


CREATE TABLE Grades (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_code VARCHAR(10),
    course_name VARCHAR(100),
    grade CHAR(2),
    credits INT,
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);


CREATE TABLE Fees (
    fee_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    fee_type VARCHAR(50),
    amount DECIMAL(10,2),
    paid_date DATE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);


CREATE TABLE Logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    action VARCHAR(100),
    student_id INT,
    log_date DATETIME DEFAULT CURRENT_TIMESTAMP
);


INSERT INTO Students (first_name, last_name, batch_year, department, admission_date)
VALUES 
('John', 'Doe', 2022, 'Computer Science', '2022-07-01'),
('Jane', 'Smith', 2023, 'Electrical', '2023-07-01'),
('Alice', 'Brown', 2022, 'Mechanical', '2022-07-01'),
('Bob', 'Johnson', 2023, 'Civil', '2023-07-01'),
('Eve', 'Davis', 2022, 'Computer Science', '2022-07-01');


INSERT INTO Grades (student_id, course_code, course_name, grade, credits)
VALUES 
(1, 'CS101', 'Intro to CS', 'A', 4),
(1, 'CS102', 'Data Structures', 'B+', 3),
(1, 'CS103', 'Algorithms', 'A-', 3),
(2, 'EE101', 'Basic Circuits', 'B', 4),
(2, 'EE102', 'Electronics', 'A', 3),
(2, 'EE103', 'Signals', 'B+', 3),
(3, 'ME101', 'Thermodynamics', 'A', 4),
(3, 'ME102', 'Fluid Mechanics', 'B', 3),
(4, 'CE101', 'Surveying', 'B+', 4),
(4, 'CE102', 'Concrete Tech', 'A', 3),
(5, 'CS101', 'Intro to CS', 'A-', 4),
(5, 'CS104', 'Databases', 'A', 3),
(5, 'CS105', 'OS', 'B+', 3),
(1, 'CS104', 'Databases', 'A', 3),
(2, 'EE104', 'Power Systems', 'A-', 3);


INSERT INTO Fees (student_id, fee_type, amount, paid_date)
VALUES 
(1, 'Tuition', 50000.00, '2022-07-10'),
(2, 'Tuition', 52000.00, '2023-07-10'),
(3, 'Hostel', 20000.00, '2022-08-05'),
(4, 'Tuition', 48000.00, '2023-07-12'),
(5, 'Library', 3000.00, '2022-07-15');


-- Views for Role-Based Access

CREATE VIEW vw_student_grades AS
SELECT s.student_id, s.first_name, s.last_name, g.course_code, g.course_name, g.grade
FROM Students s
JOIN Grades g ON s.student_id = g.student_id;

CREATE VIEW vw_admin_fees AS
SELECT s.student_id, s.first_name, s.last_name, f.fee_type, f.amount, f.paid_date
FROM Students s
JOIN Fees f ON s.student_id = f.student_id;

SELECT * FROM vw_student_grades;

-- Stored Procedure: Fetch students by batch year
DELIMITER $$

CREATE PROCEDURE GetStudentsByBatchYear(IN batch INT)
BEGIN
  SELECT * FROM Students WHERE batch_year = batch;
END$$

DELIMITER ;
CALL GetStudentsByBatchYear(2022);

-- Function: Calculate CGPA for a student
DELIMITER $$
CREATE FUNCTION GetCGPA(stu_id INT)
RETURNS DECIMAL(4,2)
DETERMINISTIC
BEGIN
  DECLARE total_points DECIMAL(10,2);
  DECLARE total_credits INT;

  SELECT SUM(
    CASE grade
      WHEN 'A' THEN 10
      WHEN 'A-' THEN 9
      WHEN 'B+' THEN 8
      WHEN 'B' THEN 7
      ELSE 0
    END * credits
  ), SUM(credits)
  INTO total_points, total_credits
  FROM Grades
  WHERE student_id = stu_id;

  RETURN total_points / total_credits;
END$$

DELIMITER ;
SELECT GetCGPA(1) AS CGPA;

-- Trigger: Log when new student is added
DELIMITER $$

CREATE TRIGGER trg_log_new_student
AFTER INSERT ON Students
FOR EACH ROW
BEGIN
  INSERT INTO Logs (action, student_id)
  VALUES ('New student added', NEW.student_id);
END$$

DELIMITER ;
SELECT * FROM Logs;

SELECT * FROM vw_admin_fees;

DROP VIEW IF EXISTS vw_student_grades;
DROP VIEW IF EXISTS vw_admin_fees;