CREATE DATABASE SupportDB;
USE SupportDB;

CREATE TABLE Users (
  UserID INT PRIMARY KEY AUTO_INCREMENT,
  UserName VARCHAR(100) NOT NULL,
  Email VARCHAR(100) NOT NULL
);

CREATE TABLE Tickets (
  TicketID INT PRIMARY KEY AUTO_INCREMENT,
  UserID INT NOT NULL,
  Subject VARCHAR(255) NOT NULL,
  Description TEXT,
  CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  ResolvedAt DATETIME,
  FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE Responses (
  ResponseID INT PRIMARY KEY AUTO_INCREMENT,
  TicketID INT NOT NULL,
  ResponseText TEXT NOT NULL,
  RespondedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (TicketID) REFERENCES Tickets(TicketID)
);

INSERT INTO Users (UserName, Email)
VALUES 
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com'),
('Carol', 'carol@example.com');

INSERT INTO Tickets (UserID, Subject, Description)
VALUES
(1, 'Login Issue', 'Cannot login to my account'),
(2, 'Payment Failure', 'Payment did not go through'),
(3, 'Bug Report', 'Found a bug in the dashboard');

INSERT INTO Responses (TicketID, ResponseText)
VALUES
(1, 'We have reset your password.'),
(2, 'Payment issue forwarded to billing.'),
(3, 'Bug has been logged for the dev team.');

--	Use JOIN to view full complaint and resolution history.
SELECT 
  t.TicketID,
  u.UserName,
  t.Subject,
  t.Description,
  r.ResponseText,
  r.RespondedAt
FROM Tickets t
JOIN Users u ON t.UserID = u.UserID
LEFT JOIN Responses r ON t.TicketID = r.TicketID
ORDER BY t.CreatedAt DESC;

--	Use ORDER BY and BETWEEN to filter by time.
SELECT *
FROM Tickets
WHERE CreatedAt BETWEEN '2025-07-01' AND '2025-07-31'
ORDER BY CreatedAt DESC;

--	Use INSERT with transactions for batch reply updates.
START TRANSACTION;

INSERT INTO Responses (TicketID, ResponseText)
VALUES (1, 'Follow-up: Please check your email.');

INSERT INTO Responses (TicketID, ResponseText)
VALUES (2, 'Follow-up: Payment confirmed, issue closed.');
COMMIT;

--	Use CASE to display ticket status
SELECT 
  TicketID,
  Subject,
  CreatedAt,
  ResolvedAt,
  CASE
    WHEN ResolvedAt IS NULL THEN 'Open'
    ELSE 'Closed'
  END AS TicketStatus
FROM Tickets;
