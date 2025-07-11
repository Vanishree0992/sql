CREATE DATABASE Banking;
USE Banking;

CREATE TABLE Accounts (
  account_id INT PRIMARY KEY,
  customer_name VARCHAR(100)
);


CREATE TABLE Transactions (
  transaction_id INT PRIMARY KEY,
  account_id INT,
  txn_date DATE,
  balance DECIMAL(10,2),
  FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);


INSERT INTO Accounts VALUES (1, 'Alice');
INSERT INTO Accounts VALUES (2, 'Bob');

INSERT INTO Transactions VALUES (1, 1, '2024-07-01', 10000.00);
INSERT INTO Transactions VALUES (2, 1, '2024-07-05', 9000.00);
INSERT INTO Transactions VALUES (3, 1, '2024-07-10', 3000.00); -- big dip
INSERT INTO Transactions VALUES (4, 1, '2024-07-15', 5000.00);

INSERT INTO Transactions VALUES (5, 2, '2024-07-01', 20000.00);
INSERT INTO Transactions VALUES (6, 2, '2024-07-04', 19500.00);
INSERT INTO Transactions VALUES (7, 2, '2024-07-08', 19300.00);
INSERT INTO Transactions VALUES (8, 2, '2024-07-12', 18000.00); -- mild dip


-- Use LAG() to get previous balance
SELECT
  t.account_id,
  a.customer_name,
  t.txn_date,
  t.balance,
  LAG(t.balance) OVER (
    PARTITION BY t.account_id
    ORDER BY t.txn_date
  ) AS previous_balance
FROM Transactions t
JOIN Accounts a ON t.account_id = a.account_id
ORDER BY t.account_id, t.txn_date;


-- Add % change & find abnormal dips (CTE)
WITH BalanceChanges AS (
  SELECT
    t.account_id,
    a.customer_name,
    t.txn_date,
    t.balance,
    LAG(t.balance) OVER (
      PARTITION BY t.account_id
      ORDER BY t.txn_date
    ) AS previous_balance
  FROM Transactions t
  JOIN Accounts a ON t.account_id = a.account_id
),
BalanceAudit AS (
  SELECT
    account_id,
    customer_name,
    txn_date,
    balance,
    previous_balance,
    ROUND(
      CASE 
        WHEN previous_balance IS NULL THEN NULL
        ELSE ((balance - previous_balance) / previous_balance) * 100
      END,
    2) AS percent_change
  FROM BalanceChanges
)
SELECT
  *
FROM BalanceAudit
WHERE percent_change < -30
ORDER BY account_id, txn_date;

-- Final audit-ready summary view
CREATE VIEW AccountBalanceAuditView AS
WITH BalanceChanges AS (
  SELECT
    t.account_id,
    a.customer_name,
    t.txn_date,
    t.balance,
    LAG(t.balance) OVER (
      PARTITION BY t.account_id
      ORDER BY t.txn_date
    ) AS previous_balance
  FROM Transactions t
  JOIN Accounts a ON t.account_id = a.account_id
),
BalanceAudit AS (
  SELECT
    account_id,
    customer_name,
    txn_date,
    balance,
    previous_balance,
    ROUND(
      CASE 
        WHEN previous_balance IS NULL THEN NULL
        ELSE ((balance - previous_balance) / previous_balance) * 100
      END,
    2) AS percent_change
  FROM BalanceChanges
)
SELECT
  account_id,
  customer_name,
  txn_date,
  balance,
  previous_balance,
  percent_change
FROM BalanceAudit
WHERE percent_change < -30;
