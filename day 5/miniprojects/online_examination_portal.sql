CREATE DATABASE ExamPortalDB;
USE ExamPortalDB;

CREATE TABLE Candidates (
  CandidateID INT PRIMARY KEY AUTO_INCREMENT,
  CandidateName VARCHAR(100) NOT NULL
);


CREATE TABLE Exams (
  ExamID INT PRIMARY KEY AUTO_INCREMENT,
  ExamName VARCHAR(100) NOT NULL
);

CREATE TABLE Results (
  ResultID INT PRIMARY KEY AUTO_INCREMENT,
  CandidateID INT,
  ExamID INT,
  Score DECIMAL(5,2) CHECK (Score >= 0 AND Score <= 100),
  FOREIGN KEY (CandidateID) REFERENCES Candidates(CandidateID),
  FOREIGN KEY (ExamID) REFERENCES Exams(ExamID)
);

INSERT INTO Candidates (CandidateName) VALUES
('Alice'), ('Bob'), ('Charlie'), ('David'), ('Eve');


INSERT INTO Exams (ExamName) VALUES ('Math');

INSERT INTO Results (CandidateID, ExamID, Score) VALUES
(1, 1, 85.00),
(2, 1, 75.00),
(3, 1, 90.00),
(4, 1, 65.00),
(5, 1, 40.00);

SELECT
  c.CandidateID,
  c.CandidateName,
  e.ExamName,
  r.Score,


  (
    SELECT
      ROUND((COUNT(*) / total.total_count) * 100, 2)
    FROM Results r2,
      (SELECT COUNT(*) AS total_count FROM Results WHERE ExamID = r.ExamID) AS total
    WHERE r2.ExamID = r.ExamID AND r2.Score < r.Score
  ) AS Percentile,


  CASE
    WHEN r.Score >= 50 THEN 'Pass'
    ELSE 'Fail'
  END AS Status


FROM Candidates c
JOIN Results r ON c.CandidateID = r.CandidateID
JOIN Exams e ON r.ExamID = e.ExamID

ORDER BY r.Score DESC;

-- ad ranking
SELECT
  c.CandidateID,
  c.CandidateName,
  e.ExamName,
  r.Score,
  RANK() OVER (ORDER BY r.Score DESC) AS ExamRank,
  CASE WHEN r.Score >= 50 THEN 'Pass' ELSE 'Fail' END AS Status
FROM Candidates c
JOIN Results r ON c.CandidateID = r.CandidateID
JOIN Exams e ON r.ExamID = e.ExamID;
