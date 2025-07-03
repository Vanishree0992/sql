CREATE DATABASE municipal_service;
USE municipal_service;

CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100)
);
CREATE TABLE citizens (
    citizen_id INT PRIMARY KEY,
    name VARCHAR(100),
    address VARCHAR(150)
);
CREATE TABLE requests (
    request_id INT PRIMARY KEY,
    citizen_id INT,
    department_id INT,
    request_date DATE,
    description TEXT,
    FOREIGN KEY (citizen_id) REFERENCES citizens(citizen_id),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);


INSERT INTO departments VALUES
(1, 'Sanitation'),
(2, 'Water Supply'),
(3, 'Electricity'),
(4, 'Public Safety');


INSERT INTO citizens VALUES
(1, 'Alice', '123 Main St'),
(2, 'Bob', '456 Elm St'),
(3, 'Charlie', '789 Oak St');

INSERT INTO requests VALUES
(1, 1, 1, '2025-06-01', 'Garbage not collected'),
(2, 1, 2, '2025-06-02', 'Water leakage'),
(3, 2, 1, '2025-06-03', 'Street cleaning'),
(4, 2, 1, '2025-06-04', 'Garbage bin missing'),
(5, 3, 3, '2025-06-05', 'Power outage');


-- Count requests per citizen and department.
SELECT 
    c.citizen_id,
    c.name,
    COUNT(r.request_id) AS total_requests
FROM citizens c
LEFT JOIN requests r ON c.citizen_id = r.citizen_id
GROUP BY c.citizen_id, c.name;

SELECT 
    d.department_id,
    d.department_name,
    COUNT(r.request_id) AS total_requests
FROM departments d
LEFT JOIN requests r ON d.department_id = r.department_id
GROUP BY d.department_id, d.department_name;

-- List departments with no requests.
SELECT 
    d.department_id,
    d.department_name
FROM departments d
LEFT JOIN requests r ON d.department_id = r.department_id
WHERE r.request_id IS NULL;


-- Find citizens with the highest number of requests.
WITH citizen_counts AS (
    SELECT 
        c.citizen_id,
        c.name,
        COUNT(r.request_id) AS request_count
    FROM citizens c
    LEFT JOIN requests r ON c.citizen_id = r.citizen_id
    GROUP BY c.citizen_id, c.name
)
SELECT *
FROM citizen_counts
WHERE request_count = (
    SELECT MAX(request_count) FROM citizen_counts
);
