CREATE DATABASE insurance_db;
USE insurance_db;


CREATE TABLE Clients (
  client_id INT AUTO_INCREMENT PRIMARY KEY,
  client_name VARCHAR(100),
  email VARCHAR(100)
);

-- Sample clients
INSERT INTO Clients (client_name, email) VALUES
('Alice Johnson', 'alice@example.com'),
('Bob Smith', 'bob@example.com'),
('Charlie Lee', 'charlie@example.com'),
('Diana Prince', 'diana@example.com'),
('Eve Adams', 'eve@example.com');



CREATE TABLE Agents (
  agent_id INT AUTO_INCREMENT PRIMARY KEY,
  agent_name VARCHAR(100)
);

-- Sample agents
INSERT INTO Agents (agent_name) VALUES
('Agent A'),
('Agent B'),
('Agent C');


CREATE TABLE Policies (
  policy_id INT AUTO_INCREMENT PRIMARY KEY,
  client_id INT,
  agent_id INT,
  policy_type VARCHAR(50),
  start_date DATE,
  end_date DATE,
  FOREIGN KEY (client_id) REFERENCES Clients(client_id),
  FOREIGN KEY (agent_id) REFERENCES Agents(agent_id)
);

-- Sample policies
INSERT INTO Policies (client_id, agent_id, policy_type, start_date, end_date) VALUES
(1, 1, 'Life', '2024-01-01', '2034-01-01'),
(2, 1, 'Health', '2023-06-15', '2028-06-15'),
(3, 2, 'Vehicle', '2022-05-10', '2027-05-10'),
(4, 3, 'Home', '2024-03-20', '2029-03-20'),
(5, 2, 'Life', '2023-08-01', '2033-08-01');

CREATE TABLE Claims (
  claim_id INT AUTO_INCREMENT PRIMARY KEY,
  policy_id INT,
  claim_date DATE,
  claim_status VARCHAR(50),
  amount DECIMAL(12,2),
  FOREIGN KEY (policy_id) REFERENCES Policies(policy_id)
);

-- Sample claims
INSERT INTO Claims (policy_id, claim_date, claim_status, amount) VALUES
(1, '2024-04-01', 'Approved', 5000),
(2, '2024-04-10', 'Under Review', 2000),
(3, '2024-04-15', 'Rejected', 1500),
(1, '2024-05-01', 'Under Review', 2500),
(4, '2024-05-10', 'Approved', 8000),
(5, '2024-05-20', 'Under Review', 3000);

CREATE INDEX idx_claim_status ON Claims(claim_status);
CREATE INDEX idx_policy_type ON Policies(policy_type);
CREATE INDEX idx_claim_date ON Claims(claim_date);

EXPLAIN SELECT 
  cl.claim_id,
  c.client_name,
  p.policy_type,
  a.agent_name,
  cl.claim_status,
  cl.amount
FROM Claims cl
JOIN Policies p ON cl.policy_id = p.policy_id
JOIN Clients c ON p.client_id = c.client_id
JOIN Agents a ON p.agent_id = a.agent_id
WHERE cl.claim_status = 'Under Review';

CREATE TABLE AgentClaimsSummary (
  agent_id INT,
  agent_name VARCHAR(100),
  total_claims INT,
  total_amount DECIMAL(12,2)
);

-- Populate summary
INSERT INTO AgentClaimsSummary (agent_id, agent_name, total_claims, total_amount)
SELECT 
  a.agent_id,
  a.agent_name,
  COUNT(cl.claim_id) AS total_claims,
  SUM(cl.amount) AS total_amount
FROM Agents a
JOIN Policies p ON a.agent_id = p.agent_id
JOIN Claims cl ON p.policy_id = cl.policy_id
GROUP BY a.agent_id;


SELECT * FROM AgentClaimsSummary;

SELECT 
  cl.claim_id,
  p.policy_id,
  c.client_name,
  cl.claim_date,
  cl.amount
FROM Claims cl
JOIN Policies p ON cl.policy_id = p.policy_id
JOIN Clients c ON p.client_id = c.client_id
WHERE cl.claim_status = 'Under Review'
ORDER BY cl.claim_date DESC
LIMIT 5;
