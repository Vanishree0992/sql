CREATE DATABASE help_desk;
USE help_desk;

CREATE TABLE Agents (
  agent_id INT PRIMARY KEY AUTO_INCREMENT,
  agent_name VARCHAR(100),
  department VARCHAR(100)
);

CREATE TABLE Tickets (
  ticket_id INT PRIMARY KEY AUTO_INCREMENT,
  agent_id INT,
  customer_name VARCHAR(100),
  issue_description VARCHAR(255),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  closed_at DATETIME,
  status VARCHAR(20) DEFAULT 'Open',
  FOREIGN KEY (agent_id) REFERENCES Agents(agent_id)
);

CREATE TABLE TicketLogs (
  log_id INT PRIMARY KEY AUTO_INCREMENT,
  ticket_id INT,
  status VARCHAR(20),
  log_date DATETIME DEFAULT CURRENT_TIMESTAMP
);


INSERT INTO Agents (agent_name, department) VALUES
('Alice', 'Software'),
('Bob', 'Hardware'),
('Charlie', 'Networking');


INSERT INTO Tickets (agent_id, customer_name, issue_description, created_at, closed_at, status) VALUES
(1, 'John Doe', 'Login issue', '2025-07-10 08:00:00', NULL, 'Open'),
(1, 'Jane Smith', 'Software crash', '2025-07-10 09:00:00', NULL, 'Open'),
(1, 'Mike Johnson', 'Update error', '2025-07-10 10:00:00', '2025-07-10 12:00:00', 'Closed'),
(2, 'Sara Lee', 'Hardware replacement', '2025-07-10 08:30:00', NULL, 'Open'),
(2, 'Tom Hanks', 'Printer issue', '2025-07-10 09:30:00', NULL, 'Open'),
(2, 'Emma Watson', 'Monitor flickering', '2025-07-10 10:30:00', NULL, 'Open'),
(2, 'Chris Evans', 'Laptop overheating', '2025-07-10 11:30:00', NULL, 'Open'),
(2, 'Robert Downey', 'Hard disk failure', '2025-07-10 12:30:00', '2025-07-10 15:00:00', 'Closed'),
(3, 'Scarlett Johansson', 'Network down', '2025-07-10 08:45:00', NULL, 'Open'),
(3, 'Mark Ruffalo', 'VPN issue', '2025-07-10 09:45:00', NULL, 'Open'),
(3, 'Chris Hemsworth', 'Firewall configuration', '2025-07-10 10:45:00', NULL, 'Open'),
(3, 'Jeremy Renner', 'Router replacement', '2025-07-10 11:45:00', NULL, 'Open'),
(1, 'Clark Kent', 'Software license', '2025-07-11 08:00:00', NULL, 'Open'),
(1, 'Diana Prince', 'App installation', '2025-07-11 09:00:00', NULL, 'Open'),
(2, 'Barry Allen', 'PC not booting', '2025-07-11 10:00:00', NULL, 'Open'),
(2, 'Hal Jordan', 'Mouse replacement', '2025-07-11 11:00:00', NULL, 'Open'),
(3, 'Arthur Curry', 'LAN setup', '2025-07-11 12:00:00', NULL, 'Open'),
(3, 'Victor Stone', 'Switch configuration', '2025-07-11 13:00:00', NULL, 'Open'),
(3, 'Bruce Wayne', 'Data backup', '2025-07-11 14:00:00', NULL, 'Open'),
(3, 'Selina Kyle', 'Network audit', '2025-07-11 15:00:00', NULL, 'Open');

-- View: Open tickets per agent
CREATE VIEW vw_open_tickets_per_agent AS
SELECT 
  ticket_id,
  agent_id,
  customer_name,
  issue_description,
  created_at,
  status
FROM Tickets
WHERE status = 'Open';
SELECT * FROM vw_open_tickets_per_agent;

-- Stored Procedure: Assign a ticket to an agent
DELIMITER $$

CREATE PROCEDURE AssignTicket(
  IN p_ticket_id INT,
  IN p_agent_id INT
)
BEGIN
  UPDATE Tickets
  SET agent_id = p_agent_id
  WHERE ticket_id = p_ticket_id;
END$$

DELIMITER ;
CALL AssignTicket(1, 2);

-- Function: Return average resolution time (in hours)
DELIMITER $$

CREATE FUNCTION AvgResolutionTime()
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE avg_hours DECIMAL(10,2);

  SELECT AVG(TIMESTAMPDIFF(HOUR, created_at, closed_at))
  INTO avg_hours
  FROM Tickets
  WHERE status = 'Closed';

  RETURN IFNULL(avg_hours, 0);
END$$

DELIMITER ;
SELECT AvgResolutionTime() AS AverageResolutionHours;

--  Trigger: Log ticket status changes
DELIMITER $$

CREATE TRIGGER trg_log_ticket_status
AFTER UPDATE ON Tickets
FOR EACH ROW
BEGIN
  IF OLD.status <> NEW.status THEN
    INSERT INTO TicketLogs (ticket_id, status)
    VALUES (NEW.ticket_id, NEW.status);
  END IF;
END$$

DELIMITER ;
UPDATE Tickets SET status = 'Closed', closed_at = NOW() WHERE ticket_id = 1;

SELECT * FROM TicketLogs;

-- Secure filtered views: Agent-specific
CREATE VIEW vw_agent1_tickets AS
SELECT ticket_id, customer_name, issue_description, status, created_at, closed_at
FROM Tickets
WHERE agent_id = 1;
SELECT * FROM vw_agent1_tickets;