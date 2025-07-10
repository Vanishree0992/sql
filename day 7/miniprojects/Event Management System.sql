CREATE DATABASE event_system;
USE event_system;
44
CREATE TABLE Events (
  event_id INT PRIMARY KEY AUTO_INCREMENT,
  event_name VARCHAR(100),
  event_date DATE,
  location VARCHAR(100),
  internal_notes VARCHAR(255) -- planning details, NOT for public
);

CREATE TABLE Participants (
  participant_id INT PRIMARY KEY AUTO_INCREMENT,
  event_id INT,
  participant_name VARCHAR(100),
  registration_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (event_id) REFERENCES Events(event_id)
);

CREATE TABLE EventAudit (
  audit_id INT PRIMARY KEY AUTO_INCREMENT,
  participant_id INT,
  event_id INT,
  action VARCHAR(50),
  audit_date DATETIME DEFAULT CURRENT_TIMESTAMP
);


INSERT INTO Events (event_name, event_date, location, internal_notes) VALUES
('Tech Conference', '2025-08-15', 'Main Hall', 'VIP speakers to confirm'),
('Music Festival', '2025-08-20', 'Open Grounds', 'Backstage passes'),
('Art Expo', '2025-08-25', 'Gallery Hall', 'Setup crew details');

INSERT INTO Participants (event_id, participant_name) VALUES
(1, 'Alice'),
(1, 'Bob'),
(1, 'Charlie'),
(1, 'David'),
(1, 'Eve'),
(1, 'Frank'),
(1, 'Grace'),
(1, 'Heidi'),
(1, 'Ivan'),
(1, 'Judy'),
(2, 'Mallory'),
(2, 'Oscar'),
(2, 'Peggy'),
(2, 'Sybil'),
(2, 'Trent'),
(2, 'Victor'),
(2, 'Walter'),
(2, 'Xavier'),
(3, 'Yvonne'),
(3, 'Zara');

--  View: Public event schedules (no internal notes)
CREATE VIEW vw_public_event_schedule AS
SELECT
  event_id,
  event_name,
  event_date,
  location
FROM Events;
SELECT * FROM vw_public_event_schedule;

-- Stored Procedure: Register a participant
DELIMITER $$

CREATE PROCEDURE RegisterParticipant(
  IN p_event_id INT,
  IN p_participant_name VARCHAR(100)
)
BEGIN
  INSERT INTO Participants (event_id, participant_name)
  VALUES (p_event_id, p_participant_name);
END$$

DELIMITER ;
CALL RegisterParticipant(1, 'NewUser');
SELECT * FROM EventAudit;

-- Function: Return total attendees for an event
DELIMITER $$

CREATE FUNCTION GetTotalAttendees(p_event_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE v_total INT;

  SELECT COUNT(*)
  INTO v_total
  FROM Participants
  WHERE event_id = p_event_id;

  RETURN v_total;
END$$

DELIMITER ;
SELECT GetTotalAttendees(1) AS TotalAttendees;

--  Trigger: Insert audit record when participant registers
DELIMITER $$

CREATE TRIGGER trg_audit_participant_register
AFTER INSERT ON Participants
FOR EACH ROW
BEGIN
  INSERT INTO EventAudit (participant_id, event_id, action)
  VALUES (NEW.participant_id, NEW.event_id, 'Registered');
END$$

DELIMITER ;

SELECT * FROM Participants WHERE event_id = 1;