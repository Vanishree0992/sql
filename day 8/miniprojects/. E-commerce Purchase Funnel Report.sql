CREATE DATABASE commerceDB;
USE commerceDB;

CREATE TABLE Users (
  user_id INT PRIMARY KEY,
  user_name VARCHAR(100)
);


CREATE TABLE UserFunnelStages (
  activity_id INT PRIMARY KEY,
  user_id INT,
  funnel_stage VARCHAR(50),
  activity_date DATETIME,
  FOREIGN KEY (user_id) REFERENCES Users(user_id)
);


INSERT INTO Users VALUES (1, 'Alice');
INSERT INTO Users VALUES (2, 'Bob');
INSERT INTO Users VALUES (3, 'Charlie');

INSERT INTO UserFunnelStages VALUES (1, 1, 'View', '2024-07-01 09:00:00');
INSERT INTO UserFunnelStages VALUES (2, 1, 'Add to Cart', '2024-07-01 09:05:00');
INSERT INTO UserFunnelStages VALUES (3, 1, 'Checkout', '2024-07-01 09:10:00');
INSERT INTO UserFunnelStages VALUES (4, 1, 'Payment', '2024-07-01 09:15:00');

INSERT INTO UserFunnelStages VALUES (5, 2, 'View', '2024-07-01 10:00:00');
INSERT INTO UserFunnelStages VALUES (6, 2, 'Add to Cart', '2024-07-01 10:05:00');
-- Bob drops off at Cart

INSERT INTO UserFunnelStages VALUES (7, 3, 'View', '2024-07-01 11:00:00');
-- Charlie drops off after View


-- Analyze stage-wise drop-offs with window functions
SELECT
  funnel_stage,
  COUNT(DISTINCT user_id) AS users_at_stage
FROM UserFunnelStages
GROUP BY funnel_stage
ORDER BY FIELD(funnel_stage, 'View', 'Add to Cart', 'Checkout', 'Payment');

--  Rank users by activity depth
SELECT
  u.user_id,
  u.user_name,
  COUNT(DISTINCT f.funnel_stage) AS stages_completed,
  RANK() OVER (ORDER BY COUNT(DISTINCT f.funnel_stage) DESC) AS activity_rank
FROM Users u
LEFT JOIN UserFunnelStages f ON u.user_id = f.user_id
GROUP BY u.user_id, u.user_name
ORDER BY stages_completed DESC;

-- See each user’s stage transitions

SELECT
  f.user_id,
  u.user_name,
  f.funnel_stage,
  f.activity_date,
  LAG(f.funnel_stage) OVER (PARTITION BY f.user_id ORDER BY f.activity_date) AS previous_stage,
  LEAD(f.funnel_stage) OVER (PARTITION BY f.user_id ORDER BY f.activity_date) AS next_stage
FROM UserFunnelStages f
JOIN Users u ON u.user_id = f.user_id
ORDER BY f.user_id, f.activity_date;


-- Create a view for your marketing dashboard
CREATE VIEW UserFunnelActivityView AS
SELECT
  u.user_id,
  u.user_name,
  COUNT(DISTINCT f.funnel_stage) AS stages_completed,
  RANK() OVER (ORDER BY COUNT(DISTINCT f.funnel_stage) DESC) AS activity_rank
FROM Users u
LEFT JOIN UserFunnelStages f ON u.user_id = f.user_id
GROUP BY u.user_id, u.user_name;
SELECT * FROM UserFunnelActivityView;
