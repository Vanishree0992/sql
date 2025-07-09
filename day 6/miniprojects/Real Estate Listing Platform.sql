CREATE DATABASE realestate_db;
USE realestate_db;

CREATE TABLE Clients (
  client_id INT AUTO_INCREMENT PRIMARY KEY,
  client_name VARCHAR(100),
  email VARCHAR(100)
);

INSERT INTO Clients (client_name, email) VALUES
('Alice Johnson', 'alice@client.com'),
('Bob Smith', 'bob@client.com'),
('Charlie Lee', 'charlie@client.com'),
('Diana Prince', 'diana@client.com'),
('Eve Adams', 'eve@client.com'),
('Frank White', 'frank@client.com'),
('Grace Kim', 'grace@client.com'),
('Henry Ford', 'henry@client.com'),
('Ivy Green', 'ivy@client.com'),
('Jack Black', 'jack@client.com'),
('Karen Hall', 'karen@client.com'),
('Leo Brown', 'leo@client.com'),
('Mona Reed', 'mona@client.com'),
('Nina Stone', 'nina@client.com'),
('Oscar Wood', 'oscar@client.com'),
('Paul Nash', 'paul@client.com'),
('Quincy Fox', 'quincy@client.com'),
('Rachel Ray', 'rachel@client.com'),
('Steve Cook', 'steve@client.com'),
('Tina Bell', 'tina@client.com');


CREATE TABLE Agents (
  agent_id INT AUTO_INCREMENT PRIMARY KEY,
  agent_name VARCHAR(100)
);

INSERT INTO Agents (agent_name) VALUES
('Agent A'),
('Agent B'),
('Agent C'),
('Agent D'),
('Agent E'),
('Agent F'),
('Agent G'),
('Agent H'),
('Agent I'),
('Agent J');

CREATE TABLE Properties (
  property_id INT AUTO_INCREMENT PRIMARY KEY,
  agent_id INT,
  location VARCHAR(100),
  price DECIMAL(12,2),
  property_type VARCHAR(50),
  bedrooms INT,
  bathrooms INT,
  FOREIGN KEY (agent_id) REFERENCES Agents(agent_id)
);

-- 25 sample properties
INSERT INTO Properties (agent_id, location, price, property_type, bedrooms, bathrooms) VALUES
(1, 'Downtown', 250000, 'Apartment', 2, 2),
(2, 'Suburb', 450000, 'House', 4, 3),
(3, 'Beachside', 650000, 'Villa', 5, 4),
(4, 'City Center', 300000, 'Apartment', 3, 2),
(5, 'Countryside', 350000, 'Cottage', 3, 2),
(6, 'Uptown', 400000, 'House', 4, 3),
(7, 'Suburb', 275000, 'Townhouse', 3, 2),
(8, 'Downtown', 325000, 'Apartment', 2, 2),
(9, 'Waterfront', 900000, 'Villa', 6, 5),
(10, 'Mountain View', 550000, 'Cabin', 4, 3),
(1, 'City Center', 275000, 'Apartment', 2, 1),
(2, 'Suburb', 450000, 'House', 4, 3),
(3, 'Countryside', 500000, 'Farmhouse', 5, 4),
(4, 'Downtown', 295000, 'Apartment', 3, 2),
(5, 'Uptown', 375000, 'House', 4, 2),
(6, 'City Outskirts', 600000, 'Villa', 5, 4),
(7, 'Downtown', 260000, 'Apartment', 2, 2),
(8, 'Suburb', 420000, 'House', 3, 2),
(9, 'Waterfront', 800000, 'Villa', 6, 5),
(10, 'Mountain View', 580000, 'Cabin', 4, 3),
(1, 'Suburb', 290000, 'Townhouse', 3, 2),
(2, 'Countryside', 330000, 'Cottage', 3, 2),
(3, 'City Center', 310000, 'Apartment', 2, 1),
(4, 'Uptown', 460000, 'House', 4, 3),
(5, 'Waterfront', 950000, 'Villa', 7, 6);



CREATE TABLE Bookings (
  booking_id INT AUTO_INCREMENT PRIMARY KEY,
  property_id INT,
  client_id INT,
  booking_date DATE,
  FOREIGN KEY (property_id) REFERENCES Properties(property_id),
  FOREIGN KEY (client_id) REFERENCES Clients(client_id)
);

-- 25 bookings
INSERT INTO Bookings (property_id, client_id, booking_date) VALUES
(1, 1, '2024-06-15'),
(2, 2, '2024-06-16'),
(3, 3, '2024-06-17'),
(4, 4, '2024-06-18'),
(5, 5, '2024-06-19'),
(6, 6, '2024-06-20'),
(7, 7, '2024-06-21'),
(8, 8, '2024-06-22'),
(9, 9, '2024-06-23'),
(10, 10, '2024-06-24'),
(11, 11, '2024-06-25'),
(12, 12, '2024-06-26'),
(13, 13, '2024-06-27'),
(14, 14, '2024-06-28'),
(15, 15, '2024-06-29'),
(16, 16, '2024-06-30'),
(17, 17, '2024-07-01'),
(18, 18, '2024-07-02'),
(19, 19, '2024-07-03'),
(20, 20, '2024-07-04'),
(21, 1, '2024-07-05'),
(22, 2, '2024-07-06'),
(23, 3, '2024-07-07'),
(24, 4, '2024-07-08'),
(25, 5, '2024-07-09');

CREATE INDEX idx_location ON Properties(location);
CREATE INDEX idx_price ON Properties(price);
CREATE INDEX idx_property_type ON Properties(property_type);

CREATE TABLE PublicPropertyListings (
  property_id INT,
  agent_name VARCHAR(100),
  location VARCHAR(100),
  price DECIMAL(12,2),
  property_type VARCHAR(50),
  bedrooms INT,
  bathrooms INT
);

INSERT INTO PublicPropertyListings
(property_id, agent_name, location, price, property_type, bedrooms, bathrooms)
SELECT 
  p.property_id,
  a.agent_name,
  p.location,
  p.price,
  p.property_type,
  p.bedrooms,
  p.bathrooms
FROM Properties p
JOIN Agents a ON p.agent_id = a.agent_id;

SELECT * FROM PublicPropertyListings LIMIT 5;

SELECT *
FROM PublicPropertyListings
ORDER BY price DESC
LIMIT 5;