CREATE DATABASE online_tracker;
USE online_tracker;

-- Students table
CREATE TABLE Students (
  student_id INT PRIMARY KEY AUTO_INCREMENT,
  student_name VARCHAR(100)
);

-- Assessments table
CREATE TABLE Assessments (
  assessment_id INT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(100),
  total_marks INT,
  grading_deadline DATE
);

-- Results table
CREATE TABLE Results (
  result_id INT PRIMARY KEY AUTO_INCREMENT,
  student_id INT,
  assessment_id INT,
  score INT,
  answers TEXT,
  instructor_remarks TEXT,
  submitted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (student_id) REFERENCES Students(student_id),
  FOREIGN KEY (assessment_id) REFERENCES Assessments(assessment_id)
);


-- Insert students
INSERT INTO Students (student_name) VALUES
('Alice'), ('Bob'), ('Charlie'), ('David'), ('Eve');

-- Insert assessments
INSERT INTO Assessments (title, total_marks, grading_deadline) VALUES
('Math Test', 100, '2025-07-20'),
('Science Test', 100, '2025-07-21');

-- Insert results (>20)
INSERT INTO Results (student_id, assessment_id, score, answers, instructor_remarks) VALUES
(1, 1, 85, 'A1,B2,C3', 'Good work'),
(2, 1, 75, 'A1,B2,C3', 'Needs improvement'),
(3, 1, 65, 'A1,B2,C3', 'Revise topics'),
(4, 1, 95, 'A1,B2,C3', 'Excellent'),
(5, 1, 55, 'A1,B2,C3', 'Below average'),
(1, 2, 88, 'A1,B2,C3', 'Strong effort'),
(2, 2, 78, 'A1,B2,C3', 'Better'),
(3, 2, 68, 'A1,B2,C3', 'Fair'),
(4, 2, 92, 'A1,B2,C3', 'Outstanding'),
(5, 2, 50, 'A1,B2,C3', 'Weak'),
(1, 1, 80, 'A1,B2,C3', 'Consistent'),
(2, 1, 70, 'A1,B2,C3', 'Work needed'),
(3, 1, 60, 'A1,B2,C3', 'Study harder'),
(4, 1, 90, 'A1,B2,C3', 'Very good'),
(5, 1, 50, 'A1,B2,C3', 'Poor'),
(1, 2, 85, 'A1,B2,C3', 'Well done'),
(2, 2, 75, 'A1,B2,C3', 'Satisfactory'),
(3, 2, 65, 'A1,B2,C3', 'Needs focus'),
(4, 2, 95, 'A1,B2,C3', 'Perfect'),
(5, 2, 55, 'A1,B2,C3', 'Try again');


CREATE VIEW vw_student_scores AS
SELECT
  r.result_id,
  r.student_id,
  r.assessment_id,
  a.title,
  r.score,
  a.total_marks,
  r.submitted_at
FROM Results r
JOIN Assessments a ON r.assessment_id = a.assessment_id;


CREATE VIEW vw_instructor_results AS
SELECT
  r.result_id,
  s.student_name,
  a.title,
  r.score,
  r.answers,
  r.instructor_remarks,
  r.submitted_at
FROM Results r
JOIN Students s ON r.student_id = s.student_id
JOIN Assessments a ON r.assessment_id = a.assessment_id;
SELECT * FROM vw_student_scores WHERE student_id = 1;

SELECT * FROM vw_instructor_results;

DELIMITER $$

CREATE PROCEDURE InsertAssessmentResult(
  IN p_student_id INT,
  IN p_assessment_id INT,
  IN p_score INT,
  IN p_answers TEXT,
  IN p_instructor_remarks TEXT
)
BEGIN
  INSERT INTO Results (student_id, assessment_id, score, answers, instructor_remarks)
  VALUES (p_student_id, p_assessment_id, p_score, p_answers, p_instructor_remarks);
END$$

DELIMITER ;
CALL InsertAssessmentResult(1, 1, 85, 'A1,B2,C3', 'Good effort');


DELIMITER $$

CREATE FUNCTION GetGrade(p_score INT)
RETURNS VARCHAR(2)
DETERMINISTIC
BEGIN
  DECLARE v_grade VARCHAR(2);

  IF p_score >= 90 THEN
    SET v_grade = 'A+';
  ELSEIF p_score >= 80 THEN
    SET v_grade = 'A';
  ELSEIF p_score >= 70 THEN
    SET v_grade = 'B';
  ELSEIF p_score >= 60 THEN
    SET v_grade = 'C';
  ELSE
    SET v_grade = 'F';
  END IF;

  RETURN v_grade;
END$$

DELIMITER ;
SELECT GetGrade(85) AS Grade;

DELIMITER $$

CREATE TRIGGER trg_block_post_deadline
BEFORE UPDATE ON Results
FOR EACH ROW
BEGIN
  DECLARE v_deadline DATE;

  SELECT grading_deadline
  INTO v_deadline
  FROM Assessments
  WHERE assessment_id = NEW.assessment_id;

  IF CURDATE() > v_deadline THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Cannot update record: grading deadline has passed.';
  END IF;
END$$

DELIMITER ;
UPDATE Results SET score = 90 WHERE result_id = 1;