CREATE DATABASE result_generator;
USE result_generator;

CREATE TABLE Students (
  student_id INT PRIMARY KEY AUTO_INCREMENT,
  student_name VARCHAR(100)
);

CREATE TABLE Exams (
  exam_id INT PRIMARY KEY AUTO_INCREMENT,
  exam_name VARCHAR(100),
  max_marks INT
);

CREATE TABLE Results (
  result_id INT PRIMARY KEY AUTO_INCREMENT,
  student_id INT,
  exam_id INT,
  score INT,
  grade CHAR(2),
  published BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (student_id) REFERENCES Students(student_id),
  FOREIGN KEY (exam_id) REFERENCES Exams(exam_id)
);

CREATE TABLE ResultAudit (
  audit_id INT PRIMARY KEY AUTO_INCREMENT,
  result_id INT,
  old_score INT,
  new_score INT,
  changed_on DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (result_id) REFERENCES Results(result_id)
);

INSERT INTO Students (student_name) VALUES
('Alice'), ('Bob'), ('Charlie'), ('David'), ('Eve'),
('Frank'), ('Grace'), ('Heidi'), ('Ivan'), ('Judy');

INSERT INTO Exams (exam_name, max_marks) VALUES
('Maths', 100), ('Science', 100);

INSERT INTO Results (student_id, exam_id, score, grade, published)
VALUES
(1, 1, 85, 'A', FALSE), (2, 1, 70, 'B', FALSE), (3, 1, 90, 'A', FALSE),
(4, 1, 65, 'B', FALSE), (5, 1, 50, 'C', FALSE),
(6, 1, 40, 'D', FALSE), (7, 1, 95, 'A', FALSE), (8, 1, 77, 'B', FALSE),
(9, 1, 82, 'A', FALSE), (10, 1, 55, 'C', FALSE),
(1, 2, 75, 'B', FALSE), (2, 2, 80, 'A', FALSE), (3, 2, 60, 'C', FALSE),
(4, 2, 45, 'D', FALSE), (5, 2, 68, 'B', FALSE),
(6, 2, 88, 'A', FALSE), (7, 2, 53, 'C', FALSE), (8, 2, 95, 'A', FALSE),
(9, 2, 66, 'B', FALSE), (10, 2, 59, 'C', FALSE);


-- View: Student result summary WITHOUT answers/internal remarks
CREATE VIEW vw_result_summary AS
SELECT
  r.result_id,
  s.student_id,
  s.student_name,
  e.exam_name,
  r.score,
  r.grade,
  r.published
FROM Results r
JOIN Students s ON r.student_id = s.student_id
JOIN Exams e ON r.exam_id = e.exam_id;
SELECT * FROM vw_result_summary;

-- Stored Procedure: Assign grades
DELIMITER $$

CREATE PROCEDURE AssignGrade(IN p_result_id INT)
BEGIN
  DECLARE v_score INT;
  DECLARE v_grade CHAR(2);

  SELECT score INTO v_score FROM Results WHERE result_id = p_result_id;

  IF v_score >= 85 THEN
    SET v_grade = 'A';
  ELSEIF v_score >= 70 THEN
    SET v_grade = 'B';
  ELSEIF v_score >= 50 THEN
    SET v_grade = 'C';
  ELSEIF v_score >= 35 THEN
    SET v_grade = 'D';
  ELSE
    SET v_grade = 'F';
  END IF;

  UPDATE Results SET grade = v_grade WHERE result_id = p_result_id;
END$$

DELIMITER ;

UPDATE Results SET score = 72 WHERE result_id = 2;
CALL AssignGrade(2);
SELECT * FROM Results WHERE result_id = 2;

-- Trigger: Prevent score updates after publishing
DELIMITER $$

CREATE TRIGGER trg_prevent_score_update
BEFORE UPDATE ON Results
FOR EACH ROW
BEGIN
  IF OLD.published = TRUE THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot update score after result is published';
  END IF;
END$$

DELIMITER ;

SELECT * FROM ResultAudit;

-- Trigger: Log score modifications
DELIMITER $$

CREATE TRIGGER trg_log_score_change
AFTER UPDATE ON Results
FOR EACH ROW
BEGIN
  IF OLD.score != NEW.score THEN
    INSERT INTO ResultAudit (result_id, old_score, new_score)
    VALUES (NEW.result_id, OLD.score, NEW.score);
  END IF;
END$$

DELIMITER ;