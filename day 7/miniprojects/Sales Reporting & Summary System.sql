CREATE DATABASE salesRetailDB;
USE salesRetailDB;

CREATE TABLE Customers (
  customer_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_name VARCHAR(100) NOT NULL,
  email VARCHAR(100)
);


CREATE TABLE Products (
  product_id INT AUTO_INCREMENT PRIMARY KEY,
  product_name VARCHAR(100) NOT NULL,
  price DECIMAL(10,2) NOT NULL
);


CREATE TABLE Orders (
  order_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT,
  order_date DATE,
  FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE OrderDetails (
  order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT,
  product_id INT,
  quantity INT,
  FOREIGN KEY (order_id) REFERENCES Orders(order_id),
  FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE SalesLog (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT,
  log_message VARCHAR(255),
  log_time DATETIME DEFAULT CURRENT_TIMESTAMP
);


INSERT INTO Customers (customer_name, email) VALUES
('Alice Smith', 'alice@example.com'),
('Bob Johnson', 'bob@example.com'),
('Charlie Lee', 'charlie@example.com'),
('David Kim', 'david@example.com'),
('Eva Green', 'eva@example.com'),
('Frank Hall', 'frank@example.com'),
('Grace Liu', 'grace@example.com'),
('Henry Adams', 'henry@example.com'),
('Isla Brown', 'isla@example.com'),
('Jack White', 'jack@example.com');


INSERT INTO Products (product_name, price) VALUES
('Laptop', 55000),
('Smartphone', 30000),
('Tablet', 20000),
('Headphones', 3000),
('Monitor', 12000);
INSERT INTO Orders (customer_id, order_date) VALUES
(1, '2024-01-15'),
(2, '2024-01-18'),
(3, '2024-02-05'),
(4, '2024-02-10'),
(5, '2024-02-20'),
(6, '2024-03-05'),
(7, '2024-03-15'),
(8, '2024-03-18'),
(9, '2024-04-02'),
(10, '2024-04-08');

INSERT INTO OrderDetails (order_id, product_id, quantity) VALUES
(1, 1, 1), (1, 4, 2),
(2, 2, 1), (2, 5, 1),
(3, 1, 1), (3, 3, 1),
(4, 2, 2), (4, 4, 1),
(5, 5, 2),
(6, 3, 3), (6, 4, 1),
(7, 2, 1), (7, 1, 1),
(8, 5, 2),
(9, 4, 4),
(10, 2, 2), (10, 3, 1);

-- View: MonthlySalesSummary
CREATE OR REPLACE VIEW MonthlySalesSummary AS
SELECT
  DATE_FORMAT(o.order_date, '%Y-%m') AS sale_month,
  SUM(od.quantity * p.price) AS total_sales
FROM
  Orders o
  JOIN OrderDetails od ON o.order_id = od.order_id
  JOIN Products p ON od.product_id = p.product_id
GROUP BY
  sale_month;

SELECT * FROM MonthlySalesSummary;

-- Function: Total sales for a specific product
DELIMITER $$
CREATE FUNCTION TotalSalesByProduct(p_product_id INT)
RETURNS DECIMAL(15,2)
DETERMINISTIC
BEGIN
  DECLARE total DECIMAL(15,2);
  SELECT SUM(od.quantity * p.price) INTO total
  FROM OrderDetails od
  JOIN Products p ON od.product_id = p.product_id
  WHERE p.product_id = p_product_id;
  RETURN IFNULL(total, 0);
END $$
DELIMITER ;

SELECT TotalSalesByProduct(1) AS LaptopSales;

-- Stored Procedure: Top 10 customers by order value
DELIMITER $$
CREATE PROCEDURE Top10CustomersByOrderValue()
BEGIN
  SELECT
    c.customer_id,
    c.customer_name,
    SUM(od.quantity * p.price) AS total_spent
  FROM
    Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    JOIN OrderDetails od ON o.order_id = od.order_id
    JOIN Products p ON od.product_id = p.product_id
  GROUP BY
    c.customer_id, c.customer_name
  ORDER BY
    total_spent DESC
  LIMIT 10;
END $$
DELIMITER ;

CALL Top10CustomersByOrderValue();

-- Trigger: Log each new sale
DELIMITER $$
CREATE TRIGGER trg_AfterNewOrder
AFTER INSERT ON Orders
FOR EACH ROW
BEGIN
  INSERT INTO SalesLog (order_id, log_message)
  VALUES (NEW.order_id, CONCAT('New sale recorded: Order ID ', NEW.order_id));
END $$
DELIMITER ;


INSERT INTO Orders (customer_id, order_date) VALUES (1, CURDATE());
SELECT * FROM SalesLog ORDER BY log_id DESC;

-- Role-based views
CREATE OR REPLACE VIEW ManagerView AS
SELECT
  o.order_id,
  c.customer_name,
  p.product_name,
  od.quantity,
  p.price,
  (od.quantity * p.price) AS total_value,
  o.order_date
FROM
  Orders o
  JOIN Customers c ON o.customer_id = c.customer_id
  JOIN OrderDetails od ON o.order_id = od.order_id
  JOIN Products p ON od.product_id = p.product_id;

CREATE OR REPLACE VIEW ClerkView AS
SELECT
  o.order_id,
  c.customer_name,
  p.product_name,
  od.quantity,
  o.order_date
FROM
  Orders o
  JOIN Customers c ON o.customer_id = c.customer_id
  JOIN OrderDetails od ON o.order_id = od.order_id
  JOIN Products p ON od.product_id = p.product_id;

SELECT * FROM ManagerView;
SELECT * FROM ClerkView;
