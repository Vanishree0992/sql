CREATE DATABASE StudentHierarchyDB;
USE StudentHierarchyDB;

CREATE TABLE Mentors (
  mentor_id INT PRIMARY KEY,
  mentor_name VARCHAR(100),
  senior_mentor_id INT NULL, -- self-reference
  FOREIGN KEY (senior_mentor_id) REFERENCES Mentors(mentor_id)
);


CREATE TABLE Students (
  student_id INT PRIMARY KEY,
  student_name VARCHAR(100),
  mentor_id INT,
  FOREIGN KEY (mentor_id) REFERENCES Mentors(mentor_id)
);



INSERT INTO Mentors VALUES (1, 'Dr. Smith', NULL);   -- Head mentor
INSERT INTO Mentors VALUES (2, 'Prof. Adams', 1);    -- Senior under Dr. Smith
INSERT INTO Mentors VALUES (3, 'Prof. Lee', 1);      -- Another senior under Dr. Smith


INSERT INTO Mentors VALUES (4, 'Mr. Clark', 2);      -- Junior under Prof. Adams
INSERT INTO Mentors VALUES (5, 'Ms. Patel', 3);      -- Junior under Prof. Lee


INSERT INTO Students VALUES (1, 'Alice', 4);         -- Mentored by Mr. Clark
INSERT INTO Students VALUES (2, 'Bob', 4);           -- Mentored by Mr. Clark
INSERT INTO Students VALUES (3, 'Charlie', 5);       -- Mentored by Ms. Patel

-- Build the student–mentor hierarchy with recursive CTE
WITH RECURSIVE MentorHierarchy AS (
  -- Start with all mentors who have no senior (top-level)
  SELECT
    mentor_id,
    mentor_name,
    senior_mentor_id,
    mentor_name AS path,
    1 AS depth
  FROM Mentors
  WHERE senior_mentor_id IS NULL

  UNION ALL

  -- Add juniors under the seniors
  SELECT
    m.mentor_id,
    m.mentor_name,
    m.senior_mentor_id,
    CONCAT(mh.path, ' -> ', m.mentor_name) AS path,
    mh.depth + 1
  FROM Mentors m
  JOIN MentorHierarchy mh ON m.senior_mentor_id = mh.mentor_id
)
SELECT * FROM MentorHierarchy
ORDER BY path;

-- Combine with students to see the full team
WITH RECURSIVE MentorHierarchy AS (
  SELECT
    mentor_id,
    mentor_name,
    senior_mentor_id,
    mentor_name AS path,
    1 AS depth
  FROM Mentors
  WHERE senior_mentor_id IS NULL

  UNION ALL

  SELECT
    m.mentor_id,
    m.mentor_name,
    m.senior_mentor_id,
    CONCAT(mh.path, ' -> ', m.mentor_name) AS path,
    mh.depth + 1
  FROM Mentors m
  JOIN MentorHierarchy mh ON m.senior_mentor_id = mh.mentor_id
)
SELECT
  s.student_id,
  s.student_name,
  mh.mentor_id,
  mh.mentor_name,
  mh.path AS mentor_path,
  mh.depth AS mentor_level
FROM Students s
JOIN MentorHierarchy mh ON s.mentor_id = mh.mentor_id
ORDER BY mentor_path, s.student_name;

-- Highlight mentor teams using a view
CREATE VIEW StudentMentorHierarchyView AS
WITH RECURSIVE MentorHierarchy AS (
  SELECT
    mentor_id,
    mentor_name,
    senior_mentor_id,
    mentor_name AS path,
    1 AS depth
  FROM Mentors
  WHERE senior_mentor_id IS NULL

  UNION ALL

  SELECT
    m.mentor_id,
    m.mentor_name,
    m.senior_mentor_id,
    CONCAT(mh.path, ' -> ', m.mentor_name) AS path,
    mh.depth + 1
  FROM Mentors m
  JOIN MentorHierarchy mh ON m.senior_mentor_id = mh.mentor_id
)
SELECT
  s.student_id,
  s.student_name,
  mh.mentor_id,
  mh.mentor_name,
  mh.path AS mentor_path,
  mh.depth AS mentor_level
FROM Students s
JOIN MentorHierarchy mh ON s.mentor_id = mh.mentor_id;

SELECT * FROM StudentMentorHierarchyView;