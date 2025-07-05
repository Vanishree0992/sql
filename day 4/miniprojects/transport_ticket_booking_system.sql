CREATE DATABASE Transport_DB;
USE Transport_DB;

CREATE TABLE Passengers (
  passenger_id INT PRIMARY KEY AUTO_INCREMENT,
  passenger_name VARCHAR(100) NOT NULL,
  phone VARCHAR(20)
);

CREATE TABLE Routes (
  route_id INT PRIMARY KEY AUTO_INCREMENT,
  route_name VARCHAR(100) NOT NULL,
  total_seats INT NOT NULL CHECK (total_seats > 0)
);

CREATE TABLE Tickets (
  ticket_id INT PRIMARY KEY AUTO_INCREMENT,
  passenger_id INT NOT NULL,
  route_id INT NOT NULL,
  seat_number INT NOT NULL,
  booking_status ENUM('Booked', 'Cancelled') DEFAULT 'Booked',
  FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id) ON DELETE CASCADE,
  FOREIGN KEY (route_id) REFERENCES Routes(route_id) ON DELETE CASCADE,
  CHECK (seat_number >= 1 AND seat_number <= 50) -- ✅ Seat number must be valid
);

INSERT INTO Passengers (passenger_name, phone)
VALUES ('Alice Rider', '111-222-3333');

INSERT INTO Routes (route_name, total_seats)
VALUES ('City A to City B', 50);

-- •	Use SAVEPOINT and rollback on payment failure.
START TRANSACTION;

SAVEPOINT before_booking;

INSERT INTO Tickets (passenger_id, route_id, seat_number)
VALUES (1, 1, 5);

COMMIT;

-- •	Update seat availability.
UPDATE Routes
SET total_seats = total_seats - 1
WHERE route_id = 1 AND route_id > 0;

-- •	Delete cancelled tickets.
DELETE FROM Tickets
WHERE booking_status = 'Cancelled'
  AND ticket_id > 0; 


SELECT * FROM Passengers;
SELECT * FROM Routes;
SELECT * FROM Tickets;