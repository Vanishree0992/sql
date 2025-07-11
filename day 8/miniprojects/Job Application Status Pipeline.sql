CREATE DATABASE jobRecruitmentDB;
USE jobRecruitmentDB;


CREATE TABLE Candidates (
  candidate_id INT PRIMARY KEY,
  candidate_name VARCHAR(100)
);

CREATE TABLE Applications (
  application_id INT PRIMARY KEY,
  candidate_id INT,
  status_stage VARCHAR(50),
  status_date DATE,
  FOREIGN KEY (candidate_id) REFERENCES Candidates(candidate_id)
);


INSERT INTO Candidates VALUES (1, 'Alice');
INSERT INTO Candidates VALUES (2, 'Bob');
INSERT INTO Candidates VALUES (3, 'Charlie');


INSERT INTO Applications VALUES (1, 1, 'Applied', '2024-07-01');
INSERT INTO Applications VALUES (2, 1, 'HR Interview', '2024-07-05');
INSERT INTO Applications VALUES (3, 1, 'Technical Interview', '2024-07-10');
INSERT INTO Applications VALUES (4, 2, 'Applied', '2024-07-02');
INSERT INTO Applications VALUES (5, 2, 'HR Interview', '2024-07-08');
-- Bob stuck at HR
INSERT INTO Applications VALUES (6, 3, 'Applied', '2024-07-03');

-- Use LAG() & LEAD() for status transitions
SELECT
  a.candidate_id,
  c.candidate_name,
  a.status_date,
  a.status_stage,
  LAG(a.status_stage) OVER (
    PARTITION BY a.candidate_id ORDER BY a.status_date
  ) AS previous_stage,
  LEAD(a.status_stage) OVER (
    PARTITION BY a.candidate_id ORDER BY a.status_date
  ) AS next_expected_stage
FROM Applications a
JOIN Candidates c ON a.candidate_id = c.candidate_id
ORDER BY a.candidate_id, a.status_date;


-- Use CTE to find stalled applications
WITH LatestStatus AS (
  SELECT
    a.candidate_id,
    c.candidate_name,
    a.status_stage,
    a.status_date,
    ROW_NUMBER() OVER (
      PARTITION BY a.candidate_id ORDER BY a.status_date DESC
    ) AS rn
  FROM Applications a
  JOIN Candidates c ON a.candidate_id = c.candidate_id
),
StalledApplications AS (
  SELECT
    candidate_id,
    candidate_name,
    status_stage,
    status_date,
    DATEDIFF(CURDATE(), status_date) AS days_since_last_stage
  FROM LatestStatus
  WHERE rn = 1
)
SELECT
  *
FROM StalledApplications
WHERE days_since_last_stage > 10;


