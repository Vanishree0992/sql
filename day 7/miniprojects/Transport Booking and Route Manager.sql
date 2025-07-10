CREATE DATABASE transport_route;
USE transport_route;

CREATE TABLE Routes (
  route_id INT PRIMARY KEY AUTO_INCREMENT,
  route_name VARCHAR(100),
  departure VARCHAR(100),
  destination VARCHAR(100),
  departure_time DATETIME,
  total_seats INT,
  internal_route_plan VARCHAR(255) -- internal, not for customers
);

CREATE TABLE Seats (
  seat_id INT PRIMARY KEY AUTO_INCREMENT,
  route_id INT,
  seat_number INT,
  status VARCHAR(20) DEFAULT 'Available',
  FOREIGN KEY (route_id) REFERENCES Routes(route_id)
);

CREATE TABLE Bookings (
  booking_id INT PRIMARY KEY AUTO_INCREMENT,
  route_id INT,
  seat_id INT,
  customer_name VARCHAR(100),
  booking_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (route_id) REFERENCES Routes(route_id),
  FOREIGN KEY (seat_id) REFERENCES Seats(seat_id)
);

INSERT INTO Routes (route_name, departure, destination, departure_time, total_seats, internal_route_plan) VALUES
('Route A', 'City X', 'City Y', '2025-07-15 08:00:00', 10, 'Optimized via Highway A'),
('Route B', 'City X', 'City Z', '2025-07-15 09:00:00', 10, 'Alternate via Scenic Route');

INSERT INTO Seats (route_id, seat_number) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5),
(1, 6), (1, 7), (1, 8), (1, 9), (1, 10),
(2, 1), (2, 2), (2, 3), (2, 4), (2, 5),
(2, 6), (2, 7), (2, 8), (2, 9), (2, 10);

  -- View: Available routes for customers
  CREATE VIEW vw_available_routes AS
SELECT 
  route_id,
  route_name,
  departure,
  destination,
  departure_time,
  total_seats
FROM Routes;


-- Stored Procedure: Book a seat
DELIMITER $$

CREATE PROCEDURE BookSeat(
  IN p_route_id INT,
  IN p_seat_id INT,
  IN p_customer_name VARCHAR(100)
)
BEGIN
  INSERT INTO Bookings (route_id, seat_id, customer_name)
  VALUES (p_route_id, p_seat_id, p_customer_name);
  
  UPDATE Seats
  SET status = 'Booked'
  WHERE seat_id = p_seat_id;
END$$

DELIMITER ;

-- Function: Return seat availability count
DELIMITER $$

CREATE FUNCTION GetAvailableSeats(p_route_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE v_count INT;

  SELECT COUNT(*)
  INTO v_count
  FROM Seats
  WHERE route_id = p_route_id AND status = 'Available';

  RETURN v_count;
END$$

DELIMITER ;

-- Trigger: Auto-update seat status on booking\
DELIMITER $$

CREATE TRIGGER trg_update_seat_status
AFTER INSERT ON Bookings
FOR EACH ROW
BEGIN
  UPDATE Seats
  SET status = 'Booked'
  WHERE seat_id = NEW.seat_id;
END$$

DELIMITER ;

SELECT * FROM vw_available_routes;

SELECT GetAvailableSeats(1) AS AvailableSeats;

CALL BookSeat(1, 1, 'Alice');
SELECT * FROM Seats WHERE seat_id = 1;


SELECT * FROM Bookings;

SELECT * FROM vw_available_routes;
SELECT * FROM Routes; 