CREATE DATABASE OnlineExam_DB;
USE OnlineExam_DB;

CREATE TABLE Candidates (
  candidate_id INT PRIMARY KEY AUTO_INCREMENT,
  candidate_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Exams (
  exam_id INT PRIMARY KEY AUTO_INCREMENT,
  exam_name VARCHAR(100) NOT NULL,
  exam_date DATE NOT NULL
);

CREATE TABLE Results (
  result_id INT PRIMARY KEY AUTO_INCREMENT,
  candidate_id INT NOT NULL,
  exam_id INT NOT NULL,
  marks INT NOT NULL CHECK (marks >= 0 AND marks <= 100),
  certificate_generated BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (candidate_id) REFERENCES Candidates(candidate_id) ON DELETE CASCADE,
  FOREIGN KEY (exam_id) REFERENCES Exams(exam_id) ON DELETE CASCADE
);

INSERT INTO Candidates (candidate_name, email)
VALUES 
  ('Alice Scholar', 'alice@exam.com'),
  ('Bob Learner', 'bob@exam.com');

INSERT INTO Exams (exam_name, exam_date)
VALUES
  ('Math Final', '2025-07-30'),
  ('Science Final', '2025-07-31');

-- •	Use transaction for result entry + certificate generation.
START TRANSACTION;

INSERT INTO Results (candidate_id, exam_id, marks)
VALUES (1, 1, 88);

UPDATE Results
SET certificate_generated = TRUE
WHERE candidate_id = 1 AND exam_id = 1;

COMMIT;

-- •	Update marks if re-evaluated.
UPDATE Results
SET marks = 92
WHERE result_id = 1 AND result_id > 0; 

--	Delete invalid or duplicate results.
DELETE FROM Results
WHERE (marks < 0 OR marks > 100)
  AND result_id > 0;


SELECT * FROM Candidates;
SELECT * FROM Exams;
SELECT * FROM Results;