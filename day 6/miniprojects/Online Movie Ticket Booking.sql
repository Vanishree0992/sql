CREATE DATABASE movie_booking_db;
USE movie_booking_db;

CREATE TABLE Movies (
  movie_id INT AUTO_INCREMENT PRIMARY KEY,
  movie_name VARCHAR(100),
  genre VARCHAR(50),
  duration_minutes INT
);

INSERT INTO Movies (movie_name, genre, duration_minutes) VALUES
('Inception', 'Sci-Fi', 148),
('Titanic', 'Romance', 195),
('The Dark Knight', 'Action', 152),
('Avengers: Endgame', 'Superhero', 181),
('Interstellar', 'Sci-Fi', 169);

CREATE TABLE Halls (
  hall_id INT AUTO_INCREMENT PRIMARY KEY,
  hall_name VARCHAR(50),
  capacity INT
);

INSERT INTO Halls (hall_name, capacity) VALUES
('Hall A', 100),
('Hall B', 120),
('Hall C', 150),
('Hall D', 80),
('Hall E', 60);

CREATE TABLE Shows (
  show_id INT AUTO_INCREMENT PRIMARY KEY,
  movie_id INT,
  hall_id INT,
  show_time DATETIME,
  available_seats INT,
  FOREIGN KEY (movie_id) REFERENCES Movies(movie_id),
  FOREIGN KEY (hall_id) REFERENCES Halls(hall_id)
);

-- Insert 30 shows, multiple times for different movies and halls
INSERT INTO Shows (movie_id, hall_id, show_time, available_seats) VALUES
(1, 1, '2024-07-08 14:00:00', 50),
(1, 2, '2024-07-08 17:00:00', 45),
(1, 3, '2024-07-08 20:00:00', 70),
(2, 1, '2024-07-09 13:00:00', 60),
(2, 2, '2024-07-09 16:00:00', 55),
(2, 3, '2024-07-09 19:00:00', 50),
(3, 1, '2024-07-10 12:00:00', 80),
(3, 2, '2024-07-10 15:00:00', 70),
(3, 3, '2024-07-10 18:00:00', 65),
(4, 4, '2024-07-08 11:00:00', 40),
(4, 5, '2024-07-08 14:00:00', 35),
(4, 1, '2024-07-08 17:00:00', 30),
(5, 2, '2024-07-09 11:00:00', 50),
(5, 3, '2024-07-09 14:00:00', 55),
(5, 4, '2024-07-09 17:00:00', 40),
(1, 5, '2024-07-10 20:00:00', 50),
(2, 4, '2024-07-10 21:00:00', 35),
(3, 5, '2024-07-10 22:00:00', 60),
(4, 2, '2024-07-11 12:00:00', 50),
(5, 1, '2024-07-11 15:00:00', 55),
(1, 3, '2024-07-11 18:00:00', 60),
(2, 5, '2024-07-11 21:00:00', 40),
(3, 4, '2024-07-12 13:00:00', 55),
(4, 3, '2024-07-12 16:00:00', 60),
(5, 2, '2024-07-12 19:00:00', 70),
(1, 1, '2024-07-13 11:00:00', 80),
(2, 2, '2024-07-13 14:00:00', 65),
(3, 3, '2024-07-13 17:00:00', 75),
(4, 4, '2024-07-13 20:00:00', 50),
(5, 5, '2024-07-13 23:00:00', 45);

CREATE TABLE Users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  user_name VARCHAR(100),
  email VARCHAR(100)
);

INSERT INTO Users (user_name, email) VALUES
('Alice Johnson', 'alice@example.com'),
('Bob Smith', 'bob@example.com'),
('Charlie Brown', 'charlie@example.com'),
('Diana Prince', 'diana@example.com'),
('Eve Adams', 'eve@example.com');

CREATE TABLE Bookings (
  booking_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  show_id INT,
  seats_booked INT,
  booking_date DATETIME,
  FOREIGN KEY (user_id) REFERENCES Users(user_id),
  FOREIGN KEY (show_id) REFERENCES Shows(show_id)
);

INSERT INTO Bookings (user_id, show_id, seats_booked, booking_date) VALUES
(1, 1, 2, '2024-07-07 10:00:00'),
(2, 2, 4, '2024-07-07 11:00:00'),
(3, 3, 1, '2024-07-07 12:00:00'),
(4, 4, 5, '2024-07-07 13:00:00'),
(5, 6, 3, '2024-07-07 14:00:00'),
(1, 7, 2, '2024-07-07 15:00:00'),
(2, 8, 1, '2024-07-07 16:00:00'),
(3, 9, 2, '2024-07-07 17:00:00'),
(4, 10, 3, '2024-07-07 18:00:00'),
(5, 11, 1, '2024-07-07 19:00:00');

CREATE INDEX idx_movie_name ON Movies(movie_name);
CREATE INDEX idx_show_time ON Shows(show_time);
CREATE INDEX idx_hall_id ON Shows(hall_id);

CREATE VIEW MovieShowDashboard AS
SELECT 
  m.movie_name,
  s.show_id,
  s.show_time,
  h.hall_name,
  s.available_seats
FROM Shows s
JOIN Movies m ON s.movie_id = m.movie_id
JOIN Halls h ON s.hall_id = h.hall_id;

EXPLAIN SELECT 
  u.user_name,
  m.movie_name,
  s.show_time,
  b.seats_booked
FROM Bookings b
JOIN Users u ON b.user_id = u.user_id
JOIN Shows s ON b.show_id = s.show_id
JOIN Movies m ON s.movie_id = m.movie_id
WHERE s.show_time >= '2024-07-08';

SELECT *
FROM MovieShowDashboard
ORDER BY show_time ASC
LIMIT 10 OFFSET 0;