CREATE DATABASE freelancer_payment_db;
USE freelancer_payment_db;

CREATE TABLE Freelancers (
  freelancer_id INT AUTO_INCREMENT PRIMARY KEY,
  freelancer_name VARCHAR(100),
  email VARCHAR(100)
);

INSERT INTO Freelancers (freelancer_name, email) VALUES
('Alice Smith', 'alice@freelance.com'),
('Bob Johnson', 'bob@freelance.com'),
('Charlie Lee', 'charlie@freelance.com'),
('Diana Prince', 'diana@freelance.com'),
('Eve Adams', 'eve@freelance.com');


CREATE TABLE Clients (
  client_id INT AUTO_INCREMENT PRIMARY KEY,
  client_name VARCHAR(100),
  email VARCHAR(100)
);

INSERT INTO Clients (client_name, email) VALUES
('Acme Corp', 'contact@acme.com'),
('Globex Inc', 'support@globex.com'),
('Initech', 'hello@initech.com'),
('Soylent Corp', 'admin@soylent.com'),
('Umbrella LLC', 'info@umbrella.com');

CREATE TABLE Projects (
  project_id INT AUTO_INCREMENT PRIMARY KEY,
  freelancer_id INT,
  client_id INT,
  project_name VARCHAR(100),
  project_date DATE,
  amount DECIMAL(12,2),
  FOREIGN KEY (freelancer_id) REFERENCES Freelancers(freelancer_id),
  FOREIGN KEY (client_id) REFERENCES Clients(client_id)
);

INSERT INTO Projects (freelancer_id, client_id, project_name, project_date, amount) VALUES
(1, 1, 'Website Redesign', '2024-06-01', 1200.00),
(2, 2, 'Mobile App', '2024-06-02', 3000.00),
(3, 3, 'Database Optimization', '2024-06-03', 2000.00),
(4, 4, 'SEO Audit', '2024-06-04', 800.00),
(5, 5, 'Marketing Campaign', '2024-06-05', 1500.00),
(1, 2, 'UI/UX Review', '2024-06-06', 1100.00),
(2, 3, 'Backend API', '2024-06-07', 2500.00),
(3, 4, 'Data Analysis', '2024-06-08', 1800.00),
(4, 5, 'Social Media Ads', '2024-06-09', 900.00),
(5, 1, 'Branding Design', '2024-06-10', 1200.00),
(1, 3, 'Content Writing', '2024-06-11', 700.00),
(2, 4, 'Video Editing', '2024-06-12', 1400.00),
(3, 5, 'Photography', '2024-06-13', 1600.00),
(4, 1, 'Logo Design', '2024-06-14', 500.00),
(5, 2, 'Product Catalog', '2024-06-15', 900.00),
(1, 4, 'Market Research', '2024-06-16', 1500.00),
(2, 5, 'Client Training', '2024-06-17', 1300.00),
(3, 1, 'Technical Support', '2024-06-18', 1000.00),
(4, 2, 'Email Marketing', '2024-06-19', 800.00),
(5, 3, 'Press Release', '2024-06-20', 600.00),
(1, 5, 'Pitch Deck', '2024-06-21', 950.00),
(2, 1, 'Market Expansion', '2024-06-22', 2000.00),
(3, 2, 'Ad Copywriting', '2024-06-23', 700.00),
(4, 3, 'Online Survey', '2024-06-24', 500.00),
(5, 4, 'Community Management', '2024-06-25', 750.00),
(1, 3, 'Chatbot Setup', '2024-06-26', 850.00),
(2, 4, 'Web Security Audit', '2024-06-27', 1200.00),
(3, 5, 'Virtual Event', '2024-06-28', 1600.00),
(4, 1, 'Print Design', '2024-06-29', 650.00),
(5, 2, 'Product Testing', '2024-06-30', 950.00);

CREATE TABLE Invoices (
  invoice_id INT AUTO_INCREMENT PRIMARY KEY,
  project_id INT,
  freelancer_id INT,
  invoice_date DATE,
  amount DECIMAL(12,2),
  payment_status VARCHAR(50),
  FOREIGN KEY (project_id) REFERENCES Projects(project_id),
  FOREIGN KEY (freelancer_id) REFERENCES Freelancers(freelancer_id)
);

INSERT INTO Invoices (project_id, freelancer_id, invoice_date, amount, payment_status) VALUES
(1, 1, '2024-06-02', 1200.00, 'Paid'),
(2, 2, '2024-06-03', 3000.00, 'Pending'),
(3, 3, '2024-06-04', 2000.00, 'Paid'),
(4, 4, '2024-06-05', 800.00, 'Overdue'),
(5, 5, '2024-06-06', 1500.00, 'Paid'),
(6, 1, '2024-06-07', 1100.00, 'Pending'),
(7, 2, '2024-06-08', 2500.00, 'Paid'),
(8, 3, '2024-06-09', 1800.00, 'Paid'),
(9, 4, '2024-06-10', 900.00, 'Overdue'),
(10, 5, '2024-06-11', 1200.00, 'Paid'),
(11, 1, '2024-06-12', 700.00, 'Paid'),
(12, 2, '2024-06-13', 1400.00, 'Pending'),
(13, 3, '2024-06-14', 1600.00, 'Paid'),
(14, 4, '2024-06-15', 500.00, 'Paid'),
(15, 5, '2024-06-16', 900.00, 'Pending'),
(16, 1, '2024-06-17', 1500.00, 'Paid'),
(17, 2, '2024-06-18', 1300.00, 'Paid'),
(18, 3, '2024-06-19', 1000.00, 'Overdue'),
(19, 4, '2024-06-20', 800.00, 'Paid'),
(20, 5, '2024-06-21', 600.00, 'Paid'),
(21, 1, '2024-06-22', 950.00, 'Pending'),
(22, 2, '2024-06-23', 2000.00, 'Paid'),
(23, 3, '2024-06-24', 700.00, 'Overdue'),
(24, 4, '2024-06-25', 500.00, 'Paid'),
(25, 5, '2024-06-26', 750.00, 'Pending'),
(26, 1, '2024-06-27', 850.00, 'Paid'),
(27, 2, '2024-06-28', 1200.00, 'Paid'),
(28, 3, '2024-06-29', 1600.00, 'Overdue'),
(29, 4, '2024-06-30', 650.00, 'Paid'),
(30, 5, '2024-07-01', 950.00, 'Pending');

CREATE INDEX idx_freelancer_id ON Invoices(freelancer_id);
CREATE INDEX idx_payment_status ON Invoices(payment_status);
CREATE INDEX idx_project_date ON Projects(project_date);

CREATE VIEW FreelancerDashboard AS
SELECT 
  f.freelancer_id,
  f.freelancer_name,
  c.client_name,
  p.project_name,
  p.project_date,
  i.invoice_id,
  i.amount AS invoice_amount,
  i.payment_status
FROM Freelancers f
JOIN Projects p ON f.freelancer_id = p.freelancer_id
JOIN Clients c ON p.client_id = c.client_id
JOIN Invoices i ON p.project_id = i.project_id;

SELECT *
FROM FreelancerDashboard
ORDER BY project_date DESC
LIMIT 10;