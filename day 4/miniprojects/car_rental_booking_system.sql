CREATE DATABASE Car_RentalDB;
USE Car_RentalDB;

CREATE TABLE Customers (
  customer_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Cars (
  car_id INT PRIMARY KEY AUTO_INCREMENT,
  car_model VARCHAR(100) NOT NULL,
  license_plate VARCHAR(20) NOT NULL UNIQUE,
  is_available BOOLEAN NOT NULL DEFAULT TRUE
);


CREATE TABLE Bookings (
  booking_id INT PRIMARY KEY AUTO_INCREMENT,
  car_id INT NOT NULL,
  customer_id INT NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  FOREIGN KEY (car_id) REFERENCES Cars(car_id) ON DELETE CASCADE,
  FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE,
  CHECK (end_date > start_date)
);


INSERT INTO Customers (customer_name, email)
VALUES
  ('Alice Walker', 'alice.walker@example.com'),
  ('Bob Marley', 'bob.marley@example.com');

INSERT INTO Cars (car_model, license_plate)
VALUES
  ('Toyota Camry', 'ABC123'),
  ('Honda Civic', 'XYZ789');

-- •	Insert booking records and car info.
-- 	Update car availability.

START TRANSACTION;

INSERT INTO Bookings (car_id, customer_id, start_date, end_date)
VALUES (1, 1, '2025-07-10', '2025-07-15');

UPDATE Cars
SET is_available = FALSE
WHERE car_id = 1;

INSERT INTO Bookings (car_id, customer_id, start_date, end_date)
VALUES (2, 2, '2025-07-12', '2025-07-14');

--	Update car availability.
UPDATE Cars
SET is_available = FALSE
WHERE car_id = 2;

COMMIT;

-- •	Delete expired bookings.
UPDATE Cars 
SET is_available = TRUE 
WHERE car_id IN (
  SELECT car_id 
  FROM Bookings 
  WHERE end_date < CURDATE()
)
AND car_id > 0;

DELETE FROM Bookings
WHERE end_date < CURDATE()
  AND booking_id > 0; 


SELECT * FROM Cars;
SELECT * FROM Customers;
SELECT * FROM Bookings;