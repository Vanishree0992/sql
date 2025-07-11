CREATE DATABASE hierarchical_data;
USE hierarchical_data;
-- Create Employees table
CREATE TABLE Employees (
  emp_id INT PRIMARY KEY,
  emp_name VARCHAR(50),
  position VARCHAR(50),
  manager_id INT,
  department VARCHAR(50),
  FOREIGN KEY (manager_id) REFERENCES Employees(emp_id)
);

-- Insert 7 sample records
INSERT INTO Employees VALUES (1, 'Alice', 'CEO', NULL, 'Executive');
INSERT INTO Employees VALUES (2, 'Bob', 'Manager', 1, 'Sales');
INSERT INTO Employees VALUES (3, 'Carol', 'Manager', 1, 'IT');
INSERT INTO Employees VALUES (4, 'David', 'Staff', 2, 'Sales');
INSERT INTO Employees VALUES (5, 'Eve', 'Staff', 2, 'Sales');
INSERT INTO Employees VALUES (6, 'Frank', 'Staff', 3, 'IT');
INSERT INTO Employees VALUES (7, 'Grace', 'Intern', 6, 'IT');

-- WITH RECURSIVE to show hierarchy
WITH RECURSIVE EmpHierarchy AS (
  SELECT emp_id, emp_name, manager_id, position, 1 AS level
  FROM Employees
  WHERE manager_id IS NULL
  UNION ALL
  SELECT e.emp_id, e.emp_name, e.manager_id, e.position, eh.level + 1
  FROM Employees e
  JOIN EmpHierarchy eh ON e.manager_id = eh.emp_id
)
SELECT * FROM EmpHierarchy;

-- . Sort hierarchy by level

SELECT * FROM EmpHierarchy
ORDER BY level;

-- 6. Subordinates of manager_id = 2
WITH RECURSIVE Subordinates AS (
  SELECT emp_id, emp_name, manager_id
  FROM Employees
  WHERE emp_id = 2
  UNION ALL
  SELECT e.emp_id, e.emp_name, e.manager_id
  FROM Employees e
  JOIN Subordinates s ON e.manager_id = s.emp_id
)
SELECT * FROM Subordinates WHERE emp_id != 2;

-- 7. Prevent cyclic relationship
ALTER TABLE Employees
ADD CONSTRAINT chk_no_cycle CHECK (emp_id <> manager_id);

-- 8. Create a view
CREATE VIEW EmployeeHierarchyView AS
WITH RECURSIVE EmpHierarchy AS (
  SELECT emp_id, emp_name, manager_id, position, 1 AS level
  FROM Employees
  WHERE manager_id IS NULL
  UNION ALL
  SELECT e.emp_id, e.emp_name, e.manager_id, e.position, eh.level + 1
  FROM Employees e
  JOIN EmpHierarchy eh ON e.manager_id = eh.emp_id
)
SELECT * FROM EmpHierarchy;

-- 9. Filter only level 3
SELECT * FROM EmployeeHierarchyView WHERE level = 3;

-- 10. Find maximum level
SELECT MAX(level) AS max_depth FROM EmployeeHierarchyView;

-- 11. Manager and immediate team count
SELECT manager_id, COUNT(*) AS team_count
FROM Employees
WHERE manager_id IS NOT NULL
GROUP BY manager_id;

-- 12. Count direct + indirect reports
WITH RECURSIVE Subordinates AS (
  SELECT emp_id, manager_id
  FROM Employees
  WHERE manager_id IS NOT NULL
  UNION ALL
  SELECT e.emp_id, e.manager_id
  FROM Employees e
  JOIN Subordinates s ON e.manager_id = s.emp_id
)
SELECT manager_id, COUNT(*) AS total_reports
FROM Subordinates
GROUP BY manager_id;

-- 13. Add “path”
WITH RECURSIVE EmpPath AS (
  SELECT emp_id, emp_name, manager_id, position, CAST(emp_name AS CHAR(255)) AS path
  FROM Employees
  WHERE manager_id IS NULL
  UNION ALL
  SELECT e.emp_id, e.emp_name, e.manager_id, e.position, CONCAT(ep.path, ' -> ', e.emp_name)
  FROM Employees e
  JOIN EmpPath ep ON e.manager_id = ep.emp_id
)
SELECT * FROM EmpPath;

-- 14. Hierarchy within each department
WITH RECURSIVE DeptHierarchy AS (
  SELECT emp_id, emp_name, manager_id, department, 1 AS level
  FROM Employees
  WHERE manager_id IS NULL
  UNION ALL
  SELECT e.emp_id, e.emp_name, e.manager_id, e.department, dh.level + 1
  FROM Employees e
  JOIN DeptHierarchy dh ON e.manager_id = dh.emp_id
)
SELECT * FROM DeptHierarchy
ORDER BY department, level;

-- 15. Depth of given employee (e.g., emp_id = 7)
WITH RECURSIVE EmpDepth AS (
  SELECT emp_id, manager_id, 1 AS depth
  FROM Employees
  WHERE emp_id = 7
  UNION ALL
  SELECT e.manager_id, m.manager_id, ed.depth + 1
  FROM Employees e
  JOIN EmpDepth ed ON e.emp_id = ed.emp_id
  JOIN Employees m ON e.manager_id = m.emp_id
  WHERE e.manager_id IS NOT NULL
)
SELECT MAX(depth) AS emp_depth FROM EmpDepth;
