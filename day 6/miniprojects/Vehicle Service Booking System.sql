CREATE DATABASE Vehicle_ServiceDB;
USE Vehicle_ServiceDB;

CREATE TABLE Customers (
  customer_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_name VARCHAR(100) NOT NULL,
  phone VARCHAR(20),
  email VARCHAR(100)
);

CREATE TABLE Vehicles (
  vehicle_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT NOT NULL,
  license_plate VARCHAR(20) UNIQUE,
  make VARCHAR(50),
  model VARCHAR(50),
  year INT,
  FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Services (
  service_id INT AUTO_INCREMENT PRIMARY KEY,
  service_name VARCHAR(100) NOT NULL,
  cost DECIMAL(10,2)
);

CREATE TABLE Bookings (
  booking_id INT AUTO_INCREMENT PRIMARY KEY,
  vehicle_id INT NOT NULL,
  service_id INT NOT NULL,
  service_date DATE NOT NULL,
  notes TEXT,
  FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id),
  FOREIGN KEY (service_id) REFERENCES Services(service_id)
);

CREATE INDEX idx_vehicle_id ON Bookings(vehicle_id);
CREATE INDEX idx_service_date ON Bookings(service_date);
CREATE INDEX idx_customer_name ON Customers(customer_name);

INSERT INTO Customers (customer_name, phone, email) VALUES
('John Doe', '123-456-7890', 'john@example.com'),
('Jane Smith', '987-654-3210', 'jane@example.com'),
('Alice Johnson', '555-111-2222', 'alice@example.com'),
('Bob Brown', '444-333-2222', 'bob@example.com'),
('Charlie Green', '111-222-3333', 'charlie@example.com');

INSERT INTO Vehicles (customer_id, license_plate, make, model, year) VALUES
(1, 'ABC123', 'Toyota', 'Camry', 2020),
(1, 'XYZ789', 'Honda', 'Civic', 2019),
(2, 'DEF456', 'Ford', 'Focus', 2018),
(2, 'GHI321', 'Chevy', 'Malibu', 2021),
(3, 'JKL654', 'Nissan', 'Altima', 2017),
(3, 'MNO987', 'Hyundai', 'Elantra', 2020),
(4, 'PQR111', 'BMW', 'X3', 2022),
(4, 'STU222', 'Audi', 'A4', 2021),
(5, 'VWX333', 'Mercedes', 'C-Class', 2022),
(5, 'YZA444', 'Tesla', 'Model 3', 2023);

INSERT INTO Services (service_name, cost) VALUES
('Oil Change', 49.99),
('Brake Inspection', 79.99),
('Tire Rotation', 39.99),
('Battery Check', 29.99),
('Engine Tune-Up', 199.99);


INSERT INTO Bookings (vehicle_id, service_id, service_date, notes) VALUES
(1, 1, '2025-07-01', 'Regular oil change'),
(1, 2, '2025-07-05', 'Brake pads check'),
(1, 3, '2025-07-10', 'Rotated tires'),
(1, 4, '2025-07-15', 'Battery test'),
(1, 5, '2025-07-20', 'Engine tune-up'),

(2, 1, '2025-07-02', 'Oil change'),
(2, 2, '2025-07-06', 'Brake inspection'),
(2, 3, '2025-07-11', 'Tire rotation'),
(2, 4, '2025-07-16', 'Battery check'),
(2, 5, '2025-07-21', 'Engine service'),

(3, 1, '2025-07-03', 'Oil service'),
(3, 2, '2025-07-07', 'Brake service'),
(3, 3, '2025-07-12', 'Tire rotation done'),
(3, 4, '2025-07-17', 'Battery replacement'),
(3, 5, '2025-07-22', 'Engine tune-up done'),

(4, 1, '2025-07-04', 'Oil maintenance'),
(4, 2, '2025-07-08', 'Brake checkup'),
(4, 3, '2025-07-13', 'Tire rotation'),
(4, 4, '2025-07-18', 'Battery health check'),
(4, 5, '2025-07-23', 'Engine tuning'),

(5, 1, '2025-07-09', 'Oil replacement'),
(5, 2, '2025-07-14', 'Brake inspection done'),
(5, 3, '2025-07-19', 'Tires rotated'),
(5, 4, '2025-07-24', 'Battery check passed'),
(5, 5, '2025-07-25', 'Engine tune-up completed');


EXPLAIN
SELECT 
  c.customer_name,
  v.license_plate,
  s.service_name,
  b.service_date
FROM Bookings b
JOIN Vehicles v ON b.vehicle_id = v.vehicle_id
JOIN Customers c ON v.customer_id = c.customer_id
JOIN Services s ON b.service_id = s.service_id
WHERE c.customer_id = 1
ORDER BY b.service_date DESC;


SELECT
  c.customer_name,
  v.license_plate,
  GROUP_CONCAT(CONCAT(s.service_name, ' (', b.service_date, ')') ORDER BY b.service_date DESC SEPARATOR ', ') AS service_history
FROM Customers c
JOIN Vehicles v ON c.customer_id = v.customer_id
JOIN Bookings b ON v.vehicle_id = b.vehicle_id
JOIN Services s ON b.service_id = s.service_id
GROUP BY c.customer_id, v.vehicle_id;


SELECT
  c.customer_name,
  v.license_plate,
  s.service_name,
  b.service_date
FROM Bookings b
JOIN Vehicles v ON b.vehicle_id = v.vehicle_id
JOIN Customers c ON v.customer_id = c.customer_id
JOIN Services s ON b.service_id = s.service_id
WHERE c.customer_id = 1
ORDER BY b.service_date DESC
LIMIT 5;


