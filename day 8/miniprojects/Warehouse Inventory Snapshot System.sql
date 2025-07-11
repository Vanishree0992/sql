CREATE DATABASE houseDB;
USE houseDB;

CREATE TABLE Items (
  item_id INT PRIMARY KEY,
  item_name VARCHAR(100)
);


CREATE TABLE DailyStockSnapshots (
  snapshot_id INT PRIMARY KEY,
  item_id INT,
  snapshot_date DATE,
  quantity INT,
  FOREIGN KEY (item_id) REFERENCES Items(item_id)
);

INSERT INTO Items VALUES (1, 'Widgets');
INSERT INTO Items VALUES (2, 'Gadgets');

INSERT INTO DailyStockSnapshots VALUES (1, 1, '2024-07-01', 100);
INSERT INTO DailyStockSnapshots VALUES (2, 1, '2024-07-02', 95);
INSERT INTO DailyStockSnapshots VALUES (3, 1, '2024-07-03', 80); -- drop
INSERT INTO DailyStockSnapshots VALUES (4, 1, '2024-07-04', 78);

INSERT INTO DailyStockSnapshots VALUES (5, 2, '2024-07-01', 50);
INSERT INTO DailyStockSnapshots VALUES (6, 2, '2024-07-02', 60); -- restock
INSERT INTO DailyStockSnapshots VALUES (7, 2, '2024-07-03', 55);
INSERT INTO DailyStockSnapshots VALUES (8, 2, '2024-07-04', 30); -- sharp drop


--  Use LAG() to calculate daily stock changes
SELECT
  i.item_id,
  i.item_name,
  s.snapshot_date,
  s.quantity,
  LAG(s.quantity) OVER (
    PARTITION BY s.item_id ORDER BY s.snapshot_date
  ) AS prev_quantity,
  s.quantity - LAG(s.quantity) OVER (
    PARTITION BY s.item_id ORDER BY s.snapshot_date
  ) AS qty_change
FROM DailyStockSnapshots s
JOIN Items i ON s.item_id = i.item_id
ORDER BY i.item_id, s.snapshot_date;

-- dentify sharp drops using conditional logic
SELECT
  i.item_id,
  i.item_name,
  s.snapshot_date,
  s.quantity,
  LAG(s.quantity) OVER (
    PARTITION BY s.item_id ORDER BY s.snapshot_date
  ) AS prev_quantity,
  s.quantity - LAG(s.quantity) OVER (
    PARTITION BY s.item_id ORDER BY s.snapshot_date
  ) AS qty_change,
  CASE 
    WHEN LAG(s.quantity) OVER (PARTITION BY s.item_id ORDER BY s.snapshot_date) IS NULL THEN NULL
    WHEN ((s.quantity - LAG(s.quantity) OVER (PARTITION BY s.item_id ORDER BY s.snapshot_date)) / LAG(s.quantity) OVER (PARTITION BY s.item_id ORDER BY s.snapshot_date)) * 100 <= -30 THEN 'Sharp Drop'
    ELSE 'Normal'
  END AS drop_flag
FROM DailyStockSnapshots s
JOIN Items i ON s.item_id = i.item_id
ORDER BY i.item_id, s.snapshot_date;

--  Use AVG() window to show daily avg stock
SELECT
  i.item_id,
  i.item_name,
  s.snapshot_date,
  s.quantity,
  AVG(s.quantity) OVER (
    PARTITION BY s.item_id
    ORDER BY s.snapshot_date
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
  ) AS rolling_avg_stock
FROM DailyStockSnapshots s
JOIN Items i ON s.item_id = i.item_id
ORDER BY i.item_id, s.snapshot_date;

-- CTE for top 10 high-movement items
WITH StockChanges AS (
  SELECT
    s.item_id,
    i.item_name,
    s.snapshot_date,
    LAG(s.quantity) OVER (PARTITION BY s.item_id ORDER BY s.snapshot_date) AS prev_qty,
    s.quantity
  FROM DailyStockSnapshots s
  JOIN Items i ON s.item_id = i.item_id
),
Movement AS (
  SELECT
    item_id,
    item_name,
    SUM(ABS(quantity - prev_qty)) AS total_movement
  FROM StockChanges
  WHERE prev_qty IS NOT NULL
  GROUP BY item_id, item_name
)
SELECT *
FROM Movement
ORDER BY total_movement DESC
LIMIT 10;
