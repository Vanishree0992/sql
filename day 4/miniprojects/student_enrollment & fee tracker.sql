CREATE DATABASE School_studentDB;
USE School_studentDB;

CREATE TABLE Students (
  student_id INT PRIMARY KEY AUTO_INCREMENT,
  student_name VARCHAR(100) NOT NULL,
  date_of_birth DATE NOT NULL
);

CREATE TABLE Courses (
  course_id INT PRIMARY KEY AUTO_INCREMENT,
  course_name VARCHAR(100) NOT NULL,
  course_fee DECIMAL(10, 2) NOT NULL CHECK (course_fee >= 0)
);

CREATE TABLE Enrollments (
  enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
  student_id INT NOT NULL,
  course_id INT NOT NULL,
  enrollment_date DATE,
  FOREIGN KEY (student_id) REFERENCES Students(student_id)
    ON DELETE CASCADE,
  FOREIGN KEY (course_id) REFERENCES Courses(course_id)
    ON DELETE CASCADE
);

CREATE TABLE Payments (
  payment_id INT PRIMARY KEY AUTO_INCREMENT,
  enrollment_id INT NOT NULL,
  fee_paid DECIMAL(10, 2) NOT NULL CHECK (fee_paid >= 0),
  payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (enrollment_id) REFERENCES Enrollments(enrollment_id)
    ON DELETE CASCADE
);
INSERT INTO Students (student_name, date_of_birth)
VALUES 
  ('Alice', '2000-05-10'),
  ('Bob', '2001-08-15');
  
  INSERT INTO Courses (course_name, course_fee)
VALUES 
  ('Mathematics', 5000),
  ('Science', 6000);

INSERT INTO Enrollments (student_id, course_id)
VALUES (1, 1), 
       (2, 2); 
-- •	Enforce NOT NULL and CHECK (fee_paid >= 0) constraints.
INSERT INTO Payments (enrollment_id, fee_paid) 
VALUES 
  (1, 3000), 
  (2, 6000);

I
-- •	Use DELETE to remove records of dropped students.

DELETE FROM Students
WHERE student_id = 2;
-- •	Rollback partial fee updates in case of errors using SAVEPOINT.
START TRANSACTION;
UPDATE Payments
SET fee_paid = 4000
WHERE payment_id = 1;

SAVEPOINT before_invalid_update;

UPDATE Payments
SET fee_paid = -1000
WHERE payment_id = 1;

ROLLBACK TO before_invalid_update;

INSERT INTO Payments (enrollment_id, fee_paid)
VALUES (1, 1000);

COMMIT;


SELECT * FROM Students;
SELECT * FROM Courses;
SELECT * FROM Enrollments;
