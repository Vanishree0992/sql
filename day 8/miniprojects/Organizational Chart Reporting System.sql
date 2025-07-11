CREATE DATABASE CompanychartDB;
USE CompanychartDB;

CREATE TABLE Employees (
  emp_id INT PRIMARY KEY,
  emp_name VARCHAR(100),
  manager_id INT,
  FOREIGN KEY (manager_id) REFERENCES Employees(emp_id)
);

INSERT INTO Employees VALUES (1, 'Alice CEO', NULL);

INSERT INTO Employees VALUES (2, 'Bob Manager', 1);
INSERT INTO Employees VALUES (3, 'Charlie Manager', 1);

INSERT INTO Employees VALUES (4, 'David Staff', 2);
INSERT INTO Employees VALUES (5, 'Eva Staff', 2);
INSERT INTO Employees VALUES (6, 'Frank Staff', 3);
INSERT INTO Employees VALUES (7, 'Grace Staff', 3);

-- Recursive CTE to show full hierarchy with level
WITH RECURSIVE OrgChart AS (
  -- Anchor: top-level employees (CEO)
  SELECT
    emp_id,
    emp_name,
    manager_id,
    1 AS level
  FROM Employees
  WHERE manager_id IS NULL

  UNION ALL

  -- Recursive: employees under manager
  SELECT
    e.emp_id,
    e.emp_name,
    e.manager_id,
    oc.level + 1 AS level
  FROM Employees e
  JOIN OrgChart oc ON e.manager_id = oc.emp_id
)
SELECT
  oc.emp_id,
  oc.emp_name,
  oc.manager_id,
  m.emp_name AS manager_name,
  oc.level
FROM OrgChart oc
LEFT JOIN Employees m ON oc.manager_id = m.emp_id
ORDER BY oc.level, oc.manager_id, oc.emp_id;


-- Save as OrgHierarchyView
DROP VIEW IF EXISTS OrgHierarchyView;

CREATE VIEW OrgHierarchyView AS
WITH RECURSIVE OrgChart AS (
  SELECT
    emp_id,
    emp_name,
    manager_id,
    1 AS level
  FROM Employees
  WHERE manager_id IS NULL

  UNION ALL

  SELECT
    e.emp_id,
    e.emp_name,
    e.manager_id,
    oc.level + 1 AS level
  FROM Employees e
  JOIN OrgChart oc ON e.manager_id = oc.emp_id
)
SELECT
  oc.emp_id,
  oc.emp_name,
  oc.manager_id,
  m.emp_name AS manager_name,
  oc.level
FROM OrgChart oc
LEFT JOIN Employees m ON oc.manager_id = m.emp_id;

SELECT * FROM OrgHierarchyView ORDER BY level, manager_name, emp_name;

