CREATE DATABASE callDB;
USE callDB;

CREATE TABLE Agents (
  agent_id INT PRIMARY KEY,
  agent_name VARCHAR(50),
  location VARCHAR(50),
  shift VARCHAR(20)
);

CREATE TABLE Calls (
  call_id INT PRIMARY KEY,
  agent_id INT,
  call_start DATETIME,
  call_end DATETIME,
  FOREIGN KEY (agent_id) REFERENCES Agents(agent_id)
);

INSERT INTO Agents VALUES (1, 'Alice', 'New York', 'Morning');
INSERT INTO Agents VALUES (2, 'Bob', 'New York', 'Morning');
INSERT INTO Agents VALUES (3, 'Carol', 'Chicago', 'Night');
INSERT INTO Agents VALUES (4, 'David', 'Chicago', 'Night');


INSERT INTO Calls VALUES (1, 1, '2024-07-10 08:00:00', '2024-07-10 08:10:00');
INSERT INTO Calls VALUES (2, 1, '2024-07-10 08:15:00', '2024-07-10 08:25:00');
INSERT INTO Calls VALUES (3, 2, '2024-07-10 08:00:00', '2024-07-10 08:05:00');
INSERT INTO Calls VALUES (4, 2, '2024-07-10 08:07:00', '2024-07-10 08:20:00');
INSERT INTO Calls VALUES (5, 2, '2024-07-10 08:25:00', '2024-07-10 08:30:00');
INSERT INTO Calls VALUES (6, 3, '2024-07-10 22:00:00', '2024-07-10 22:20:00');
INSERT INTO Calls VALUES (7, 3, '2024-07-10 22:30:00', '2024-07-10 22:50:00');
INSERT INTO Calls VALUES (8, 4, '2024-07-10 22:10:00', '2024-07-10 22:30:00');


-- Rank agents by calls handled using RANK() and PARTITION BY
SELECT
  a.agent_id,
  a.agent_name,
  a.location,
  a.shift,
  COUNT(c.call_id) AS calls_handled,
  RANK() OVER (
    PARTITION BY a.shift
    ORDER BY COUNT(c.call_id) DESC
  ) AS rank_in_shift
FROM Agents a
LEFT JOIN Calls c ON a.agent_id = c.agent_id
GROUP BY a.agent_id, a.agent_name, a.location, a.shift;


-- Use LAG() to detect call gap durations
SELECT
  c.agent_id,
  a.agent_name,
  c.call_id,
  c.call_start,
  LAG(c.call_end) OVER (
    PARTITION BY c.agent_id
    ORDER BY c.call_start
  ) AS prev_call_end,
  TIMESTAMPDIFF(MINUTE,
    LAG(c.call_end) OVER (PARTITION BY c.agent_id ORDER BY c.call_start),
    c.call_start
  ) AS gap_minutes
FROM Calls c
JOIN Agents a ON c.agent_id = a.agent_id
ORDER BY c.agent_id, c.call_start;

-- Use a CTE to list consistently high-volume agents
WITH DailyCallCounts AS (
  SELECT
    agent_id,
    DATE(call_start) AS call_date,
    COUNT(*) AS daily_calls
  FROM Calls
  GROUP BY agent_id, DATE(call_start)
),
HighVolumeAgents AS (
  SELECT
    agent_id,
    COUNT(*) AS high_volume_days
  FROM DailyCallCounts
  WHERE daily_calls >= 2
  GROUP BY agent_id
  HAVING high_volume_days >= 1
)
SELECT
  a.agent_id,
  a.agent_name,
  hva.high_volume_days
FROM HighVolumeAgents hva
JOIN Agents a ON a.agent_id = hva.agent_id;

-- 
CREATE VIEW AgentPerformanceView AS
SELECT
  a.agent_id,
  a.agent_name,
  a.location,
  a.shift,
  COUNT(c.call_id) AS calls_handled,
  RANK() OVER (PARTITION BY a.shift ORDER BY COUNT(c.call_id) DESC) AS rank_in_shift
FROM Agents a
LEFT JOIN Calls c ON a.agent_id = c.agent_id
GROUP BY a.agent_id, a.agent_name, a.location, a.shift;