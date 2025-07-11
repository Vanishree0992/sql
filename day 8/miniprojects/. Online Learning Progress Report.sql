CREATE DATABASE LearningDB;
USE LearningDB;

CREATE TABLE Students (
  student_id INT PRIMARY KEY,
  student_name VARCHAR(100)
);


CREATE TABLE QuizScores (
  quiz_id INT PRIMARY KEY,
  student_id INT,
  quiz_date DATE,
  score INT,
  FOREIGN KEY (student_id) REFERENCES Students(student_id)
);


-- Students
INSERT INTO Students VALUES (1, 'Alice');
INSERT INTO Students VALUES (2, 'Bob');

-- Quiz scores (across multiple dates)
INSERT INTO QuizScores VALUES (1, 1, '2024-07-01', 70);
INSERT INTO QuizScores VALUES (2, 1, '2024-07-05', 75); -- up
INSERT INTO QuizScores VALUES (3, 1, '2024-07-10', 72); -- down

INSERT INTO QuizScores VALUES (4, 2, '2024-07-01', 60);
INSERT INTO QuizScores VALUES (5, 2, '2024-07-04', 60); -- same
INSERT INTO QuizScores VALUES (6, 2, '2024-07-07', 65); -- up

-- Use LAG() to compare quiz scores
SELECT
  q.student_id,
  s.student_name,
  q.quiz_date,
  q.score,
  LAG(q.score) OVER (
    PARTITION BY q.student_id ORDER BY q.quiz_date
  ) AS prev_score
FROM QuizScores q
JOIN Students s ON q.student_id = s.student_id
ORDER BY q.student_id, q.quiz_date;

-- Add progress trend: Improving / Declining / Stagnant
SELECT
  q.student_id,
  s.student_name,
  q.quiz_date,
  q.score,
  LAG(q.score) OVER (
    PARTITION BY q.student_id ORDER BY q.quiz_date
  ) AS prev_score,
  CASE
    WHEN LAG(q.score) OVER (PARTITION BY q.student_id ORDER BY q.quiz_date) IS NULL THEN 'N/A'
    WHEN q.score > LAG(q.score) OVER (PARTITION BY q.student_id ORDER BY q.quiz_date) THEN 'Improving'
    WHEN q.score < LAG(q.score) OVER (PARTITION BY q.student_id ORDER BY q.quiz_date) THEN 'Declining'
    ELSE 'Stagnant'
  END AS progress_trend
FROM QuizScores q
JOIN Students s ON q.student_id = s.student_id
ORDER BY q.student_id, q.quiz_date;


-- CTE to summarize improvement for each student
WITH ScoreTrends AS (
  SELECT
    q.student_id,
    CASE
      WHEN LAG(q.score) OVER (PARTITION BY q.student_id ORDER BY q.quiz_date) IS NULL THEN NULL
      WHEN q.score > LAG(q.score) OVER (PARTITION BY q.student_id ORDER BY q.quiz_date) THEN 'Improving'
      WHEN q.score < LAG(q.score) OVER (PARTITION BY q.student_id ORDER BY q.quiz_date) THEN 'Declining'
      ELSE 'Stagnant'
    END AS trend
  FROM QuizScores q
)
SELECT
  s.student_id,
  s.student_name,
  SUM(CASE WHEN st.trend = 'Improving' THEN 1 ELSE 0 END) AS improving_count,
  SUM(CASE WHEN st.trend = 'Declining' THEN 1 ELSE 0 END) AS declining_count,
  SUM(CASE WHEN st.trend = 'Stagnant' THEN 1 ELSE 0 END) AS stagnant_count
FROM Students s
LEFT JOIN ScoreTrends st ON s.student_id = st.student_id
GROUP BY s.student_id, s.student_name;
