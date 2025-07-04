CREATE DATABASE Transportation;
USE Transportation;

CREATE TABLE vehicle_types (
    type_id INT PRIMARY KEY,
    type_name VARCHAR(50)
);

CREATE TABLE vehicles (
    vehicle_id INT PRIMARY KEY,
    type_id INT,
    registration_no VARCHAR(20),
    last_service_date DATE,
    next_service_date DATE,
    FOREIGN KEY (type_id) REFERENCES vehicle_types(type_id)
);

CREATE TABLE maintenance (
    maintenance_id INT PRIMARY KEY,
    vehicle_id INT,
    service_date DATE,
    cost DECIMAL(10,2),
    description VARCHAR(100),
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id)
);

INSERT INTO vehicle_types VALUES
(1, 'Truck'),
(2, 'Van'),
(3, 'Bike');

INSERT INTO vehicles VALUES
(101, 1, 'TRK-999', '2025-05-01', '2025-08-01'),
(102, 2, 'VAN-123', '2025-06-01', '2025-07-10'),
(103, 3, 'BIK-456', '2025-06-15', '2025-07-30'),
(104, 1, 'TRK-111', '2025-05-10', '2025-07-05');

INSERT INTO maintenance VALUES
(1, 101, '2025-05-01', 12000, 'Full Service'),
(2, 102, '2025-06-01', 3000, 'Oil Change'),
(3, 103, '2025-06-15', 2000, 'Brake Check'),
(4, 104, '2025-05-10', 15000, 'Engine Overhaul');

--	Use DATE_SUB to list vehicles due for service in the next 30 days.
SELECT 
    v.vehicle_id,
    v.registration_no,
    v.next_service_date
FROM vehicles v
WHERE v.next_service_date <= DATE_ADD(CURDATE(), INTERVAL 30 DAY);

--	Use subqueries to find vehicles with highest service cost.
SELECT 
    v.registration_no,
    m.cost
FROM maintenance m
JOIN vehicles v ON m.vehicle_id = v.vehicle_id
WHERE m.cost = (
    SELECT MAX(cost) FROM maintenance
);

--	Use CASE to label urgency (High, Medium, Low).
SELECT 
    v.vehicle_id,
    v.registration_no,
    v.next_service_date,
    DATEDIFF(v.next_service_date, CURDATE()) AS days_remaining,
    CASE 
        WHEN DATEDIFF(v.next_service_date, CURDATE()) <= 7 THEN 'High'
        WHEN DATEDIFF(v.next_service_date, CURDATE()) <= 20 THEN 'Medium'
        ELSE 'Low'
    END AS urgency_level
FROM vehicles v;

--	Use GROUP BY to get total cost per vehicle type.
SELECT 
    vt.type_name,
    SUM(m.cost) AS total_maintenance_cost
FROM maintenance m
JOIN vehicles v ON m.vehicle_id = v.vehicle_id
JOIN vehicle_types vt ON v.type_id = vt.type_id
GROUP BY vt.type_name;
