CREATE DATABASE Real_EstateDB;
USE Real_EstateDB;

CREATE TABLE Locations (
  location_id INT AUTO_INCREMENT PRIMARY KEY,
  location_name VARCHAR(100) NOT NULL
);
CREATE TABLE Owners (
  owner_id INT AUTO_INCREMENT PRIMARY KEY,
  owner_name VARCHAR(100) NOT NULL,
  phone VARCHAR(20),
  email VARCHAR(100)
);

CREATE TABLE Properties (
  property_id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  location_id INT,
  owner_id INT,
  price DECIMAL(12,2),
  status VARCHAR(20) DEFAULT 'Available', -- Available, Sold, UnderOffer
  FOREIGN KEY (location_id) REFERENCES Locations(location_id),
  FOREIGN KEY (owner_id) REFERENCES Owners(owner_id)
);

CREATE TABLE PropertyVisits (
  visit_id INT AUTO_INCREMENT PRIMARY KEY,
  property_id INT,
  client_name VARCHAR(100),
  visit_date DATE,
  visit_time TIME,
  FOREIGN KEY (property_id) REFERENCES Properties(property_id)
);
CREATE TABLE ListingAudit (
  audit_id INT AUTO_INCREMENT PRIMARY KEY,
  property_id INT,
  old_price DECIMAL(12,2),
  new_price DECIMAL(12,2),
  old_status VARCHAR(20),
  new_status VARCHAR(20),
  action_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Locations (location_name) VALUES
('Downtown'), ('Uptown'), ('Suburbs'), ('Beachside'), ('Countryside');

INSERT INTO Owners (owner_name, phone, email) VALUES
('Alice Realty', '123-456-7890', 'alice@realty.com'),
('Bob Estates', '234-567-8901', 'bob@estates.com'),
('Charlie Homes', '345-678-9012', 'charlie@homes.com');

INSERT INTO Properties (title, location_id, owner_id, price, status) VALUES
('Luxury Apartment Downtown', 1, 1, 15000000, 'Available'),
('Cozy Condo Uptown', 2, 2, 8500000, 'Available'),
('Beachfront Villa', 4, 3, 25000000, 'UnderOffer'),
('Countryside Cottage', 5, 1, 5000000, 'Available'),
('Modern Suburban House', 3, 2, 9500000, 'Available'),
('Downtown Studio', 1, 3, 6000000, 'Sold'),
('Uptown Penthouse', 2, 1, 18000000, 'Available'),
('Beachside Bungalow', 4, 2, 12000000, 'Available'),
('Rustic Farmhouse', 5, 3, 7000000, 'Available'),
('Family Suburban Home', 3, 1, 8000000, 'UnderOffer'),
('City Center Loft', 1, 2, 11000000, 'Available'),
('Uptown Duplex', 2, 3, 10000000, 'Sold'),
('Beach Resort Condo', 4, 1, 14000000, 'Available'),
('Countryside Manor', 5, 2, 20000000, 'Available'),
('Suburban Townhouse', 3, 3, 8500000, 'Available'),
('Downtown Office Space', 1, 1, 22000000, 'Available'),
('Uptown Studio Flat', 2, 2, 7500000, 'Available'),
('Beachside Cabin', 4, 3, 9500000, 'Available'),
('Farm Estate', 5, 1, 17500000, 'Sold'),
('New Suburb Development', 3, 2, 13500000, 'Available'),
('High-Rise Apartment Downtown', 1, 3, 16000000, 'Available');

-- Public View: Only Available Properties (Hide Sensitive Owner Info)
CREATE OR REPLACE VIEW PublicPropertyView AS
SELECT
  p.property_id,
  p.title,
  l.location_name,
  p.price,
  p.status
FROM
  Properties p
  JOIN Locations l ON p.location_id = l.location_id
WHERE
  p.status = 'Available';


SELECT * FROM PublicPropertyView;

--  Stored Procedure: Schedule Property Visits
DELIMITER $$
CREATE PROCEDURE ScheduleVisit(
  IN p_property_id INT,
  IN p_client_name VARCHAR(100),
  IN p_visit_date DATE,
  IN p_visit_time TIME
)
BEGIN
  INSERT INTO PropertyVisits (property_id, client_name, visit_date, visit_time)
  VALUES (p_property_id, p_client_name, p_visit_date, p_visit_time);
END $$
DELIMITER ;


CALL ScheduleVisit(1, 'John Doe', '2024-07-15', '14:00:00');

SELECT * FROM PropertyVisits;

-- Function: Count Listings by Location
DELIMITER $$
CREATE FUNCTION ListingsCountByLocation(p_location_name VARCHAR(100))
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total
  FROM Properties p
  JOIN Locations l ON p.location_id = l.location_id
  WHERE l.location_name = p_location_name;
  RETURN total;
END $$
DELIMITER ;


SELECT ListingsCountByLocation('Downtown') AS DowntownListings;

--  Trigger: Log Listing Changes (price or status)
DELIMITER $$
CREATE TRIGGER trg_LogListingChanges
AFTER UPDATE ON Properties
FOR EACH ROW
BEGIN
  IF OLD.price != NEW.price OR OLD.status != NEW.status THEN
    INSERT INTO ListingAudit (
      property_id, old_price, new_price, old_status, new_status
    )
    VALUES (
      NEW.property_id, OLD.price, NEW.price, OLD.status, NEW.status
    );
  END IF;
END $$
DELIMITER ;


UPDATE Properties
SET price = 15500000, status = 'UnderOffer'
WHERE property_id = 1;


SELECT * FROM ListingAudit;
