CREATE DATABASE ProjectManagementDB;
USE ProjectManagementDB;

CREATE TABLE Tasks (
  task_id INT PRIMARY KEY,
  task_name VARCHAR(100),
  depends_on_task_id INT,
  estimated_days INT,
  FOREIGN KEY (depends_on_task_id) REFERENCES Tasks(task_id)
);

INSERT INTO Tasks VALUES (1, 'Project Kickoff', NULL, 2);
INSERT INTO Tasks VALUES (2, 'Requirements Gathering', 1, 5);
INSERT INTO Tasks VALUES (3, 'Design Phase', 2, 7);
INSERT INTO Tasks VALUES (4, 'Development', 3, 14);
INSERT INTO Tasks VALUES (5, 'Testing', 4, 5);
INSERT INTO Tasks VALUES (6, 'Deployment', 5, 2);
INSERT INTO Tasks VALUES (7, 'Documentation', 2, 4);


WITH RECURSIVE TaskTree AS (
  -- Base tasks (no dependency)
  SELECT 
    task_id,
    task_name,
    depends_on_task_id,
    estimated_days,
    1 AS level,
    CAST(task_name AS CHAR(500)) AS task_path
  FROM Tasks
  WHERE depends_on_task_id IS NULL

  UNION ALL

  -- Recursively add child tasks
  SELECT 
    t.task_id,
    t.task_name,
    t.depends_on_task_id,
    t.estimated_days,
    tt.level + 1,
    CONCAT(tt.task_path, ' -> ', t.task_name)
  FROM Tasks t
  JOIN TaskTree tt ON t.depends_on_task_id = tt.task_id
)

SELECT 
  task_id,
  task_name,
  depends_on_task_id,
  level,
  task_path
FROM TaskTree
ORDER BY level, task_id;


WITH RECURSIVE TaskSchedule AS (
  -- Root task starts on project start date
  SELECT 
    task_id,
    task_name,
    depends_on_task_id,
    estimated_days,
    1 AS level,
    '2024-07-10' AS start_date,
    DATE_ADD('2024-07-10', INTERVAL estimated_days DAY) AS end_date,
    CAST(task_name AS CHAR(500)) AS task_path
  FROM Tasks
  WHERE depends_on_task_id IS NULL

  UNION ALL

  -- Child tasks start after parent ends
  SELECT 
    t.task_id,
    t.task_name,
    t.depends_on_task_id,
    t.estimated_days,
    ts.level + 1,
    ts.end_date AS start_date,
    DATE_ADD(ts.end_date, INTERVAL t.estimated_days DAY) AS end_date,
    CONCAT(ts.task_path, ' -> ', t.task_name)
  FROM Tasks t
  JOIN TaskSchedule ts ON t.depends_on_task_id = ts.task_id
)

SELECT 
  task_id,
  task_name,
  depends_on_task_id,
  level,
  task_path,
  start_date,
  end_date
FROM TaskSchedule
ORDER BY start_date;
