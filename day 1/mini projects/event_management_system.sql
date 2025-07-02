-- Create the database
CREATE DATABASE EventManagementDB;

-- Use the database
USE EventManagementDB;

-- creating tables
CREATE TABLE Events (
    EventID INT AUTO_INCREMENT PRIMARY KEY,
    EventName VARCHAR(100) NOT NULL,
    EventDate DATE,
    Location VARCHAR(100)
);

CREATE TABLE Attendees (
    AttendeeID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100)
);

CREATE TABLE Registrations (
    RegistrationID INT AUTO_INCREMENT PRIMARY KEY,
    EventID INT,
    AttendeeID INT,
    RegistrationDate DATE,
    FOREIGN KEY (EventID) REFERENCES Events(EventID),
    FOREIGN KEY (AttendeeID) REFERENCES Attendees(AttendeeID)
);

-- inserting data
INSERT INTO Events (EventName, EventDate, Location) 
VALUES
('Tech Conference', '2025-08-15', 'Convention Center'),
('Music Festival', '2025-09-01', 'Open Grounds'),
('Startup Meetup', '2025-08-20', 'Innovation Hub');

INSERT INTO Attendees (Name, Email) 
VALUES
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com'),
('Charlie', 'charlie@example.com'),
('David', 'david@example.com'),
('Eva', 'eva@example.com');

-- Tech Conference registrations (simulate 102, here we add 5 for example)
INSERT INTO Registrations (EventID, AttendeeID, RegistrationDate) VALUES
(1, 1, '2025-07-01'),
(1, 2, '2025-07-02'),
(1, 3, '2025-07-03'),
(1, 4, '2025-07-04'),
(1, 5, '2025-07-05');

-- Music Festival registrations
INSERT INTO Registrations (EventID, AttendeeID, RegistrationDate) VALUES
(2, 1, '2025-07-10'),
(2, 2, '2025-07-11');

-- Startup Meetup registrations
INSERT INTO Registrations (EventID, AttendeeID, RegistrationDate) VALUES
(3, 1, '2025-07-15'),
(3, 3, '2025-07-16'),
(3, 4, '2025-07-17');

-- Query events with more than 100 attendees.
SELECT 
    e.EventID,
    e.EventName,
    COUNT(r.RegistrationID) AS AttendeeCount
FROM 
    Events e
JOIN 
    Registrations r ON e.EventID = r.EventID
GROUP BY 
    e.EventID, e.EventName
HAVING 
    AttendeeCount > 100;

-- List attendees registered for multiple events.
SELECT 
    a.AttendeeID,
    a.Name,
    COUNT(r.RegistrationID) AS EventsRegistered
FROM 
    Attendees a
JOIN 
    Registrations r ON a.AttendeeID = r.AttendeeID
GROUP BY 
    a.AttendeeID, a.Name
HAVING 
    EventsRegistered > 1;
