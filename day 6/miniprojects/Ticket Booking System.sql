CREATE DATABASE Ticket_BookingDB;
USE Ticket_BookingDB;

CREATE TABLE Cities (
  city_id INT AUTO_INCREMENT PRIMARY KEY,
  city_name VARCHAR(100) NOT NULL
);

CREATE TABLE Routes (
  route_id INT AUTO_INCREMENT PRIMARY KEY,
  origin_city_id INT NOT NULL,
  destination_city_id INT NOT NULL,
  departure_time DATETIME NOT NULL,
  arrival_time DATETIME NOT NULL,
  FOREIGN KEY (origin_city_id) REFERENCES Cities(city_id),
  FOREIGN KEY (destination_city_id) REFERENCES Cities(city_id)
);

CREATE TABLE Vehicles (
  vehicle_id INT AUTO_INCREMENT PRIMARY KEY,
  vehicle_number VARCHAR(50) NOT NULL,
  vehicle_type ENUM('Bus', 'Train') NOT NULL,
  total_seats INT NOT NULL
);

CREATE TABLE Passengers (
  passenger_id INT AUTO_INCREMENT PRIMARY KEY,
  passenger_name VARCHAR(100) NOT NULL,
  phone VARCHAR(20)
);

CREATE TABLE Bookings (
  booking_id INT AUTO_INCREMENT PRIMARY KEY,
  passenger_id INT NOT NULL,
  route_id INT NOT NULL,
  vehicle_id INT NOT NULL,
  booking_date DATE NOT NULL,
  seat_number INT NOT NULL,
  FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id),
  FOREIGN KEY (route_id) REFERENCES Routes(route_id),
  FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id)
);


CREATE INDEX idx_route_id ON Bookings(route_id);
CREATE INDEX idx_booking_date ON Bookings(booking_date);
CREATE INDEX idx_passenger_name ON Passengers(passenger_name);

INSERT INTO Cities (city_name) VALUES 
('New York'), ('Boston'), ('Chicago'), ('Washington DC'), ('Philadelphia');


INSERT INTO Vehicles (vehicle_number, vehicle_type, total_seats) VALUES
('BUS101', 'Bus', 50),
('BUS102', 'Bus', 50),
('TRAIN201', 'Train', 200);


INSERT INTO Routes (origin_city_id, destination_city_id, departure_time, arrival_time) VALUES
(1, 2, '2025-07-10 08:00:00', '2025-07-10 12:00:00'),
(2, 3, '2025-07-10 13:00:00', '2025-07-10 18:00:00'),
(3, 4, '2025-07-10 19:00:00', '2025-07-11 02:00:00'),
(1, 5, '2025-07-11 07:00:00', '2025-07-11 10:00:00'),
(5, 4, '2025-07-11 12:00:00', '2025-07-11 16:00:00');


INSERT INTO Passengers (passenger_name, phone) VALUES
('Alice Johnson', '555-1111'),
('Bob Smith', '555-2222'),
('Carol White', '555-3333'),
('David Lee', '555-4444'),
('Eve Brown', '555-5555');


INSERT INTO Bookings (passenger_id, route_id, vehicle_id, booking_date, seat_number) VALUES
(1, 1, 1, '2025-07-09', 1),
(2, 1, 1, '2025-07-09', 2),
(3, 1, 1, '2025-07-09', 3),
(4, 1, 1, '2025-07-09', 4),
(5, 1, 1, '2025-07-09', 5),
(1, 2, 2, '2025-07-09', 1),
(2, 2, 2, '2025-07-09', 2),
(3, 2, 2, '2025-07-09', 3),
(4, 2, 2, '2025-07-09', 4),
(5, 2, 2, '2025-07-09', 5),
(1, 3, 3, '2025-07-09', 1),
(2, 3, 3, '2025-07-09', 2),
(3, 3, 3, '2025-07-09', 3),
(4, 3, 3, '2025-07-09', 4),
(5, 3, 3, '2025-07-09', 5),
(1, 4, 1, '2025-07-10', 6),
(2, 4, 1, '2025-07-10', 7),
(3, 4, 1, '2025-07-10', 8),
(4, 4, 1, '2025-07-10', 9),
(5, 4, 1, '2025-07-10', 10),
(1, 5, 2, '2025-07-10', 11),
(2, 5, 2, '2025-07-10', 12),
(3, 5, 2, '2025-07-10', 13),
(4, 5, 2, '2025-07-10', 14),
(5, 5, 2, '2025-07-10', 15);


EXPLAIN
SELECT 
  r.route_id,
  c1.city_name AS origin,
  c2.city_name AS destination,
  r.departure_time,
  r.arrival_time,
  v.vehicle_number
FROM Routes r
JOIN Cities c1 ON r.origin_city_id = c1.city_id
JOIN Cities c2 ON r.destination_city_id = c2.city_id
JOIN Vehicles v ON v.vehicle_id = 1 -- example vehicle
WHERE c1.city_name = 'New York' AND c2.city_name = 'Boston' AND r.departure_time > NOW()
ORDER BY r.departure_time ASC;

CREATE OR REPLACE VIEW ScheduleView AS
SELECT
  r.route_id,
  c1.city_name AS origin,
  c2.city_name AS destination,
  r.departure_time,
  r.arrival_time,
  v.vehicle_number,
  v.vehicle_type,
  v.total_seats,
  COUNT(b.booking_id) AS booked_seats,
  (v.total_seats - COUNT(b.booking_id)) AS available_seats
FROM Routes r
JOIN Cities c1 ON r.origin_city_id = c1.city_id
JOIN Cities c2 ON r.destination_city_id = c2.city_id
JOIN Vehicles v ON v.vehicle_id = r.route_id -- simplified example
LEFT JOIN Bookings b ON r.route_id = b.route_id
GROUP BY r.route_id, c1.city_name, c2.city_name, v.vehicle_number;


SELECT *
FROM ScheduleView
WHERE available_seats > 0
ORDER BY departure_time ASC
LIMIT 5 OFFSET 0;