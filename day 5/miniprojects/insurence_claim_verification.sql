CREATE DATABASE InsuranceDB;
USE InsuranceDB;

CREATE TABLE Policies (
  PolicyID INT PRIMARY KEY AUTO_INCREMENT,
  PolicyHolderName VARCHAR(100) NOT NULL,
  PolicyType VARCHAR(50) NOT NULL
);

CREATE TABLE Claims (
  ClaimID INT PRIMARY KEY AUTO_INCREMENT,
  PolicyID INT NOT NULL,
  ClaimAmount DECIMAL(10,2) NOT NULL,
  ClaimDate DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (PolicyID) REFERENCES Policies(PolicyID),
  CHECK (ClaimAmount <= 100000)  -- example threshold: $100,000
);

CREATE TABLE Documents (
  DocumentID INT PRIMARY KEY AUTO_INCREMENT,
  ClaimID INT NOT NULL,
  DocumentName VARCHAR(100),
  Verified BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (ClaimID) REFERENCES Claims(ClaimID)
);

INSERT INTO Policies (PolicyHolderName, PolicyType)
VALUES
('Alice', 'Health'),
('Bob', 'Auto'),
('Carol', 'Property');

INSERT INTO Claims (PolicyID, ClaimAmount, ClaimDate)
VALUES 
(1, 5000.00, '2025-07-05'),
(2, 20000.00, '2025-07-06');


INSERT INTO Documents (ClaimID, DocumentName, Verified)
VALUES 
(1, 'Medical Report', TRUE),
(1, 'ID Proof', TRUE),
(2, NULL, FALSE);

--	Use IS NULL to find missing documents.
SELECT 
  c.ClaimID,
  p.PolicyHolderName,
  d.DocumentName,
  d.Verified
FROM Claims c
JOIN Policies p ON c.PolicyID = p.PolicyID
LEFT JOIN Documents d ON c.ClaimID = d.ClaimID
WHERE d.DocumentName IS NULL OR d.Verified = FALSE;

--	Use JOIN to display full claim info.
SELECT 
  c.ClaimID,
  p.PolicyHolderName,
  p.PolicyType,
  c.ClaimAmount,
  c.ClaimDate,
  d.DocumentName,
  d.Verified
FROM Claims c
JOIN Policies p ON c.PolicyID = p.PolicyID
LEFT JOIN Documents d ON c.ClaimID = d.ClaimID
ORDER BY c.ClaimDate DESC;

--	Use subqueries to find the average claim per policy.
SELECT 
  PolicyID,
  AVG(ClaimAmount) AS AvgClaimAmount
FROM Claims
GROUP BY PolicyID;

