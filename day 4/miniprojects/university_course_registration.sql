CREATE DATABASE University_DB;
USE University_DB;

CREATE TABLE Students (
  student_id INT PRIMARY KEY AUTO_INCREMENT,
  student_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Courses (
  course_id INT PRIMARY KEY AUTO_INCREMENT,
  course_name VARCHAR(100) NOT NULL,
  capacity INT NOT NULL CHECK (capacity >= 0),
  seats_remaining INT NOT NULL CHECK (seats_remaining >= 0)
);

CREATE TABLE Registrations (
  registration_id INT PRIMARY KEY AUTO_INCREMENT,
  student_id INT NOT NULL,
  course_id INT NOT NULL,
  registration_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE,
  FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE,
  UNIQUE (student_id, course_id)
);


INSERT INTO Students (student_name, email)
VALUES 
  ('Alice Johnson', 'alice@example.com'),
  ('Bob Smith', 'bob@example.com');

INSERT INTO Courses (course_name, capacity, seats_remaining)
VALUES 
  ('Database Systems', 30, 30),
  ('Data Structures', 25, 25);

-- •	Use rollback if course capacity exceeded.

START TRANSACTION;

SELECT seats_remaining FROM Courses WHERE course_id = 1;

INSERT INTO Registrations (student_id, course_id)
VALUES (1, 1);

--  Update course seats_remaining
UPDATE Courses 
SET seats_remaining = seats_remaining - 1
WHERE course_id = 1;

-- Delete dropped registrations 

DELETE FROM Registrations WHERE registration_id = 1;

SELECT * FROM Students;
SELECT * FROM Courses;
SELECT * FROM Registrations;