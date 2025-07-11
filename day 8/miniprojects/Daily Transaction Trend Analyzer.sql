CREATE DATABASE dailyFinanceDB;
USE dailyFinanceDB;

CREATE TABLE Transactions (
  transaction_id INT PRIMARY KEY,
  transaction_date DATE,
  amount DECIMAL(10,2)
);

INSERT INTO Transactions VALUES (1, '2024-07-01', 1000.00);
INSERT INTO Transactions VALUES (2, '2024-07-02', 1500.00);
INSERT INTO Transactions VALUES (3, '2024-07-03', 1200.00);
INSERT INTO Transactions VALUES (4, '2024-07-04', 2000.00);
INSERT INTO Transactions VALUES (5, '2024-07-05', 1800.00);
INSERT INTO Transactions VALUES (6, '2024-07-06', 2200.00);
INSERT INTO Transactions VALUES (7, '2024-07-07', 2500.00);
INSERT INTO Transactions VALUES (8, '2024-07-08', 1900.00);


-- CTE for recent 30-day period
WITH Last30Days AS (
  SELECT *
  FROM Transactions
  WHERE transaction_date >= CURDATE() - INTERVAL 30 DAY
)
SELECT * FROM Last30Days;


-- Calculate rolling 7-day average with AVG() window
WITH Last30Days AS (
  SELECT *
  FROM Transactions
  WHERE transaction_date >= CURDATE() - INTERVAL 30 DAY
)
SELECT
  transaction_date,
  amount,
  AVG(amount) OVER (
    ORDER BY transaction_date
    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
  ) AS rolling_7_day_avg
FROM Last30Days
ORDER BY transaction_date;

-- Highlight days when spending was above the rolling average
WITH Last30Days AS (
  SELECT *
  FROM Transactions
  WHERE transaction_date >= CURDATE() - INTERVAL 30 DAY
),
DailyWithRolling AS (
  SELECT
    transaction_date,
    amount,
    AVG(amount) OVER (
      ORDER BY transaction_date
      ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS rolling_7_day_avg
  FROM Last30Days
)
SELECT
  transaction_date,
  amount,
  rolling_7_day_avg,
  CASE
    WHEN amount > rolling_7_day_avg THEN 'Above Average'
    ELSE 'Normal or Below'
  END AS trend_flag
FROM DailyWithRolling
ORDER BY transaction_date;