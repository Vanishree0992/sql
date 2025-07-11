CREATE DATABASE SalespersonDB;
USE SalespersonDB;

CREATE TABLE Salespersons (
  salesperson_id INT PRIMARY KEY,
  salesperson_name VARCHAR(100),
  manager_id INT,
  sales_amount DECIMAL(12,2),
  FOREIGN KEY (manager_id) REFERENCES Salespersons(salesperson_id)
);

INSERT INTO Salespersons VALUES (1, 'Alice', NULL, 50000.00);   
INSERT INTO Salespersons VALUES (2, 'Bob', 1, 30000.00);        
INSERT INTO Salespersons VALUES (3, 'Charlie', 1, 40000.00);    
INSERT INTO Salespersons VALUES (4, 'Dan', 2, 15000.00);        
INSERT INTO Salespersons VALUES (5, 'Eve', 2, 18000.00);       
INSERT INTO Salespersons VALUES (6, 'Frank', 3, 20000.00);     


-- Recursive CTE to build the hierarchy
WITH RECURSIVE SalesHierarchy AS (
  SELECT
    salesperson_id,
    salesperson_name,
    manager_id,
    sales_amount,
    1 AS level,
    CAST(salesperson_name AS CHAR(255)) AS hierarchy_path
  FROM Salespersons
  WHERE manager_id IS NULL

  UNION ALL

  SELECT
    s.salesperson_id,
    s.salesperson_name,
    s.manager_id,
    s.sales_amount,
    sh.level + 1,
    CONCAT(sh.hierarchy_path, ' → ', s.salesperson_name)
  FROM Salespersons s
  JOIN SalesHierarchy sh ON s.manager_id = sh.salesperson_id
)
SELECT * FROM SalesHierarchy
ORDER BY hierarchy_path;

-- Add total team sales using window SUM()
WITH RECURSIVE SalesHierarchy AS (
  SELECT
    salesperson_id,
    salesperson_name,
    manager_id,
    sales_amount,
    1 AS level
  FROM Salespersons
  WHERE manager_id IS NULL

  UNION ALL

  SELECT
    s.salesperson_id,
    s.salesperson_name,
    s.manager_id,
    s.sales_amount,
    sh.level + 1
  FROM Salespersons s
  JOIN SalesHierarchy sh ON s.manager_id = sh.salesperson_id
),
TeamSales AS (
  SELECT
    sh.manager_id AS team_manager_id,
    SUM(sh.sales_amount) AS total_team_sales
  FROM SalesHierarchy sh
  WHERE sh.manager_id IS NOT NULL
  GROUP BY sh.manager_id
)
SELECT
  sh.salesperson_id,
  sh.salesperson_name,
  sh.manager_id,
  sh.sales_amount,
  ts.total_team_sales
FROM SalesHierarchy sh
LEFT JOIN TeamSales ts ON sh.manager_id = ts.team_manager_id
ORDER BY sh.manager_id, sh.salesperson_id;

--  Add RANK() to rank reps by sales within each team
WITH RECURSIVE SalesHierarchy AS (
  SELECT
    salesperson_id,
    salesperson_name,
    manager_id,
    sales_amount,
    1 AS level
  FROM Salespersons
  WHERE manager_id IS NULL

  UNION ALL

  SELECT
    s.salesperson_id,
    s.salesperson_name,
    s.manager_id,
    s.sales_amount,
    sh.level + 1
  FROM Salespersons s
  JOIN SalesHierarchy sh ON s.manager_id = sh.salesperson_id
)
SELECT
  sh.manager_id,
  sh.salesperson_id,
  sh.salesperson_name,
  sh.sales_amount,
  RANK() OVER (PARTITION BY sh.manager_id ORDER BY sh.sales_amount DESC) AS rank_within_team
FROM SalesHierarchy sh
WHERE sh.manager_id IS NOT NULL
ORDER BY sh.manager_id, rank_within_team;
