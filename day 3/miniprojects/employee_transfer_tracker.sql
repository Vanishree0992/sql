CREATE DATABASE Employee_Transfers;
USE Employee_Transfers;

CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    full_name VARCHAR(100)
);

CREATE TABLE employee_transfers (
    transfer_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    department_id INT,
    transfer_date DATE,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

INSERT INTO departments VALUES
(1, 'Finance'),
(2, 'Engineering'),
(3, 'IT'),
(4, 'HR'),
(5, 'Sales');

INSERT INTO employees VALUES
(101, 'Alice Singh'),
(102, 'Bob Kapoor'),
(103, 'Charu Desai'),
(104, 'Deepak Mehta'),
(105, 'Esha Khan');

INSERT INTO employee_transfers (employee_id, department_id, transfer_date) VALUES
(101, 1, '2024-01-15'), 
(101, 3, '2024-07-01'), 

(102, 2, '2023-12-01'), 
(102, 1, '2024-05-01'), 

(103, 3, '2024-04-01'), 

(104, 4, '2023-09-01'), 
(104, 5, '2024-06-15'), 

(105, 3, '2023-08-01'); 

--	Use INTERSECT to find employees in both IT and Finance.

SELECT employee_id FROM employee_transfers WHERE department_id = 3
INTERSECT
SELECT employee_id FROM employee_transfers WHERE department_id = 1;

--	Use EXCEPT to find employees in one dept but not in another.

SELECT employee_id FROM employee_transfers WHERE department_id = 1
EXCEPT
SELECT employee_id FROM employee_transfers WHERE department_id = 3;

--	Use subqueries to find employees who transferred in the last 6 months.

SELECT DISTINCT e.employee_id, e.full_name
FROM employees e
WHERE employee_id IN (
    SELECT employee_id
    FROM employee_transfers
    WHERE transfer_date >= CURDATE() - INTERVAL 6 MONTH
);

--	Track unique department count per employee using subquery.
SELECT 
    e.employee_id,
    e.full_name,
    (
        SELECT COUNT(DISTINCT department_id)
        FROM employee_transfers t
        WHERE t.employee_id = e.employee_id
    ) AS departments_worked_in
FROM employees e;
