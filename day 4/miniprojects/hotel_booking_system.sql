CREATE DATABASE Hotel_DB;
USE Hotel_DB;

CREATE TABLE Rooms (
  room_id INT PRIMARY KEY AUTO_INCREMENT,
  room_type VARCHAR(50) NOT NULL,
  price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
  is_available BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE Guests (
  guest_id INT PRIMARY KEY AUTO_INCREMENT,
  guest_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Bookings (
  booking_id INT PRIMARY KEY AUTO_INCREMENT,
  room_id INT NOT NULL,
  guest_id INT NOT NULL,
  check_in DATE NOT NULL,
  check_out DATE NOT NULL,
  booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (room_id) REFERENCES Rooms(room_id)
    ON DELETE CASCADE,
  FOREIGN KEY (guest_id) REFERENCES Guests(guest_id)
    ON DELETE CASCADE,
  CHECK (check_out > check_in)
);

INSERT INTO Rooms (room_type, price)
VALUES
  ('Single', 2500),
  ('Double', 4000),
  ('Suite', 8000);


INSERT INTO Guests (guest_name, email)
VALUES
  ('Alice Blue', 'alice.blue@example.com'),
  ('Bob Red', 'bob.red@example.com');
  
INSERT INTO Bookings (room_id, guest_id, check_in, check_out)
VALUES (1, 1, '2025-07-10', '2025-07-15');

-- Find booking_id
SELECT booking_id FROM Bookings WHERE guest_id = 1;

DELETE FROM Bookings
WHERE booking_id = 1;

UPDATE Rooms
SET is_available = TRUE
WHERE room_id = 1;

START TRANSACTION;

SELECT * FROM Rooms WHERE room_id = 1 AND is_available = TRUE;

INSERT INTO Bookings (room_id, guest_id, check_in, check_out)
VALUES (1, 1, '2025-07-10', '2025-07-15');

UPDATE Rooms
SET is_available = FALSE
WHERE room_id = 1;

SAVEPOINT before_error;

COMMIT;