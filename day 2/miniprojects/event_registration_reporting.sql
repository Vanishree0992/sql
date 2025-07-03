CREATE DATABASE event_registration;
USE event_registration;

CREATE TABLE events (
    event_id INT PRIMARY KEY,
    event_name VARCHAR(100),
    event_date DATE
);

CREATE TABLE attendees (
    attendee_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE registrations (
    registration_id INT PRIMARY KEY,
    event_id INT,
    attendee_id INT,
    registration_date DATE,
    FOREIGN KEY (event_id) REFERENCES events(event_id),
    FOREIGN KEY (attendee_id) REFERENCES attendees(attendee_id)
);


INSERT INTO events 
VALUES
(1, 'Tech Conference 2025', '2025-09-15'),
(2, 'Music Festival', '2025-08-10'),
(3, 'Art Expo', '2025-07-20');


INSERT INTO attendees 
VALUES
(1, 'Emily', 'emily@example.com'),
(2, 'John', 'john@example.com'),
(3, 'Sophie', 'sophie@example.com'),
(4, 'Mark', 'mark@example.com');


INSERT INTO registrations 
VALUES
(1, 1, 1, '2025-06-01'),
(2, 1, 2, '2025-06-02'),
(3, 2, 1, '2025-06-10'),
(4, 2, 3, '2025-06-12'),
(5, 1, 3, '2025-06-15');


-- Count registrations per event.
SELECT 
    e.event_id,
    e.event_name,
    COUNT(r.registration_id) AS total_registrations
FROM events e
LEFT JOIN registrations r ON e.event_id = r.event_id
GROUP BY e.event_id, e.event_name;

-- Find attendees who registered for most events.
WITH attendee_counts AS (
    SELECT 
        a.attendee_id,
        a.name,
        COUNT(DISTINCT r.event_id) AS events_registered
    FROM attendees a
    LEFT JOIN registrations r ON a.attendee_id = r.attendee_id
    GROUP BY a.attendee_id, a.name
)
SELECT *
FROM attendee_counts
WHERE events_registered = (
    SELECT MAX(events_registered) FROM attendee_counts
);

-- List events with no registrations.
SELECT 
    e.event_id,
    e.event_name
FROM events e
LEFT JOIN registrations r ON e.event_id = r.event_id
WHERE r.registration_id IS NULL;

