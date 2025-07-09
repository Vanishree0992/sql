CREATE DATABASE Ecommerce_fulfillmentDB;
USE Ecommerce_fulfillmentDB;

CREATE TABLE Customers (
  customer_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_name VARCHAR(100) NOT NULL,
  email VARCHAR(100),
  phone VARCHAR(20)
);

CREATE TABLE Orders (
  order_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT NOT NULL,
  order_date DATE NOT NULL,
  FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);


CREATE TABLE OrderItems (
  order_item_id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT NOT NULL,
  product_name VARCHAR(100) NOT NULL,
  quantity INT NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);


CREATE TABLE Shipments (
  shipment_id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT NOT NULL,
  shipment_date DATE NOT NULL,
  shipment_status ENUM('Pending', 'Dispatched', 'Delivered') DEFAULT 'Pending',
  tracking_number VARCHAR(50),
  FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);


CREATE INDEX idx_order_date ON Orders(order_date);
CREATE INDEX idx_shipment_status ON Shipments(shipment_status);
CREATE INDEX idx_customer_id ON Orders(customer_id);



INSERT INTO Customers (customer_name, email, phone) VALUES
('Alice Johnson', 'alice@example.com', '555-111-2222'),
('Bob Smith', 'bob@example.com', '555-222-3333'),
('Carol White', 'carol@example.com', '555-333-4444'),
('David Lee', 'david@example.com', '555-444-5555'),
('Eve Brown', 'eve@example.com', '555-555-6666');


INSERT INTO Orders (customer_id, order_date) VALUES
(1, '2025-07-01'),
(1, '2025-07-02'),
(2, '2025-07-01'),
(2, '2025-07-03'),
(3, '2025-07-01'),
(3, '2025-07-04'),
(4, '2025-07-02'),
(4, '2025-07-04'),
(5, '2025-07-02'),
(5, '2025-07-05');


INSERT INTO OrderItems (order_id, product_name, quantity, price) VALUES
(1, 'Laptop', 1, 1200.00),
(1, 'Mouse', 2, 25.00),
(1, 'Keyboard', 1, 45.00),
(2, 'Smartphone', 1, 800.00),
(2, 'Charger', 1, 20.00),
(3, 'Headphones', 2, 50.00),
(3, 'Laptop Sleeve', 1, 30.00),
(4, 'Monitor', 1, 250.00),
(4, 'HDMI Cable', 2, 15.00),
(5, 'Desk Chair', 1, 150.00),
(5, 'Desk Lamp', 1, 40.00),
(6, 'Webcam', 1, 70.00),
(6, 'Microphone', 1, 90.00),
(7, 'Router', 1, 60.00),
(7, 'Ethernet Cable', 2, 10.00),
(8, 'External Hard Drive', 1, 100.00),
(8, 'USB Hub', 1, 25.00),
(9, 'Printer', 1, 200.00),
(9, 'Ink Cartridge', 2, 35.00),
(10, 'Tablet', 1, 300.00),
(10, 'Stylus Pen', 1, 40.00),
(1, 'Screen Protector', 1, 15.00),
(2, 'Phone Case', 1, 20.00),
(3, 'Gaming Mouse', 1, 60.00),
(4, 'Speakers', 1, 80.00),
(5, 'Whiteboard', 1, 70.00),
(6, 'Flash Drive', 2, 15.00),
(7, 'Smartwatch', 1, 200.00),
(8, 'Power Bank', 1, 30.00),
(9, 'VR Headset', 1, 400.00);


INSERT INTO Shipments (order_id, shipment_date, shipment_status, tracking_number) VALUES
(1, '2025-07-02', 'Pending', 'TRK123'),
(2, '2025-07-03', 'Dispatched', 'TRK124'),
(3, '2025-07-02', 'Pending', 'TRK125'),
(4, '2025-07-04', 'Dispatched', 'TRK126'),
(5, '2025-07-03', 'Delivered', 'TRK127'),
(6, '2025-07-05', 'Pending', 'TRK128'),
(7, '2025-07-04', 'Pending', 'TRK129'),
(8, '2025-07-06', 'Dispatched', 'TRK130'),
(9, '2025-07-05', 'Pending', 'TRK131'),
(10, '2025-07-06', 'Delivered', 'TRK132');


EXPLAIN
SELECT 
  o.order_id,
  o.order_date,
  c.customer_name,
  s.shipment_status,
  s.tracking_number
FROM Orders o
JOIN Shipments s ON o.order_id = s.order_id
JOIN Customers c ON o.customer_id = c.customer_id
WHERE s.shipment_status = 'Pending'
ORDER BY o.order_date ASC;


CREATE OR REPLACE VIEW DeliveryDashboard AS
SELECT 
  o.order_id,
  o.order_date,
  c.customer_name,
  s.shipment_status,
  s.tracking_number,
  SUM(oi.quantity * oi.price) AS total_order_value
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
JOIN Shipments s ON o.order_id = s.order_id
JOIN OrderItems oi ON o.order_id = oi.order_id
GROUP BY o.order_id, o.order_date, c.customer_name, s.shipment_status, s.tracking_number
ORDER BY o.order_date DESC;


SELECT * FROM DeliveryDashboard
WHERE shipment_status = 'Pending'
ORDER BY order_date ASC
LIMIT 5;