CREATE DATABASE Restaurant_orderDB;
USE Restaurant_orderDB;

CREATE TABLE Tables (
  table_id INT AUTO_INCREMENT PRIMARY KEY,
  table_number INT NOT NULL UNIQUE,
  seats INT
);

CREATE TABLE MenuItems (
  item_id INT AUTO_INCREMENT PRIMARY KEY,
  item_name VARCHAR(100) NOT NULL,
  price DECIMAL(8,2)
);


CREATE TABLE Chefs (
  chef_id INT AUTO_INCREMENT PRIMARY KEY,
  chef_name VARCHAR(100) NOT NULL,
  specialty VARCHAR(100)
);


CREATE TABLE Orders (
  order_id INT AUTO_INCREMENT PRIMARY KEY,
  table_id INT NOT NULL,
  item_id INT NOT NULL,
  chef_id INT NOT NULL,
  order_time DATETIME DEFAULT CURRENT_TIMESTAMP,
  order_status ENUM('Pending', 'In Progress', 'Completed') DEFAULT 'Pending',
  notes TEXT,
  FOREIGN KEY (table_id) REFERENCES Tables(table_id),
  FOREIGN KEY (item_id) REFERENCES MenuItems(item_id),
  FOREIGN KEY (chef_id) REFERENCES Chefs(chef_id)
);

CREATE INDEX idx_order_status ON Orders(order_status);
CREATE INDEX idx_table_id ON Orders(table_id);
CREATE INDEX idx_order_time ON Orders(order_time);


INSERT INTO Tables (table_number, seats) VALUES
(1, 4), (2, 2), (3, 6), (4, 4), (5, 8);

INSERT INTO MenuItems (item_name, price) VALUES
('Margherita Pizza', 8.99),
('Caesar Salad', 5.99),
('Grilled Chicken', 12.50),
('Pasta Alfredo', 9.99),
('Cheesecake', 4.99),
('Burger', 7.99),
('French Fries', 2.99),
('Tiramisu', 5.50),
('Tomato Soup', 3.99),
('Steak', 18.99);


INSERT INTO Chefs (chef_name, specialty) VALUES
('Chef Mario', 'Italian'),
('Chef Linda', 'Salads'),
('Chef John', 'Grill'),
('Chef Alice', 'Desserts');


INSERT INTO Orders (table_id, item_id, chef_id, order_time, order_status, notes) VALUES
(1, 1, 1, '2025-07-09 12:00:00', 'Pending', 'Extra cheese'),
(2, 2, 2, '2025-07-09 12:01:00', 'Pending', 'No croutons'),
(3, 3, 3, '2025-07-09 12:02:00', 'In Progress', 'Medium rare'),
(4, 4, 1, '2025-07-09 12:03:00', 'Pending', 'Add mushrooms'),
(5, 5, 4, '2025-07-09 12:04:00', 'Completed', 'Birthday special'),
(1, 6, 3, '2025-07-09 12:05:00', 'Pending', 'No onions'),
(2, 7, 3, '2025-07-09 12:06:00', 'Pending', 'Extra ketchup'),
(3, 8, 4, '2025-07-09 12:07:00', 'Pending', 'Less sugar'),
(4, 9, 2, '2025-07-09 12:08:00', 'In Progress', 'No cream'),
(5, 10, 3, '2025-07-09 12:09:00', 'Pending', 'Rare'),

(1, 1, 1, '2025-07-09 12:10:00', 'Pending', 'Gluten free crust'),
(2, 4, 1, '2025-07-09 12:11:00', 'In Progress', 'No garlic'),
(3, 5, 4, '2025-07-09 12:12:00', 'Pending', 'Extra strawberries'),
(4, 3, 3, '2025-07-09 12:13:00', 'Pending', 'Well done'),
(5, 2, 2, '2025-07-09 12:14:00', 'Pending', 'Add extra dressing'),
(1, 7, 3, '2025-07-09 12:15:00', 'Pending', 'No salt'),
(2, 8, 4, '2025-07-09 12:16:00', 'Completed', 'Add cocoa powder'),
(3, 9, 2, '2025-07-09 12:17:00', 'Pending', 'Hot'),
(4, 10, 3, '2025-07-09 12:18:00', 'Pending', 'Medium'),
(5, 6, 3, '2025-07-09 12:19:00', 'Pending', 'No pickles'),

(1, 2, 2, '2025-07-09 12:20:00', 'Pending', 'Extra dressing'),
(2, 3, 3, '2025-07-09 12:21:00', 'Pending', 'No sauce'),
(3, 1, 1, '2025-07-09 12:22:00', 'In Progress', 'Extra basil'),
(4, 4, 1, '2025-07-09 12:23:00', 'Pending', 'Add veggies'),
(5, 5, 4, '2025-07-09 12:24:00', 'Pending', 'Birthday plate'),
(1, 10, 3, '2025-07-09 12:25:00', 'Pending', 'Medium rare'),
(2, 9, 2, '2025-07-09 12:26:00', 'Pending', 'Spicy'),
(3, 8, 4, '2025-07-09 12:27:00', 'Pending', 'Extra coffee powder'),
(4, 7, 3, '2025-07-09 12:28:00', 'Pending', 'No salt');


EXPLAIN
SELECT 
  o.order_id,
  t.table_number,
  m.item_name,
  o.order_status,
  o.order_time,
  c.chef_name
FROM Orders o
JOIN Tables t ON o.table_id = t.table_id
JOIN MenuItems m ON o.item_id = m.item_id
JOIN Chefs c ON o.chef_id = c.chef_id
WHERE o.order_status = 'Pending'
ORDER BY o.order_time ASC;



CREATE OR REPLACE VIEW KitchenMonitor AS
SELECT 
  o.order_id,
  t.table_number,
  m.item_name,
  c.chef_name,
  o.order_time,
  o.order_status,
  o.notes
FROM Orders o
JOIN Tables t ON o.table_id = t.table_id
JOIN MenuItems m ON o.item_id = m.item_id
JOIN Chefs c ON o.chef_id = c.chef_id
WHERE o.order_status = 'Pending'
ORDER BY o.order_time ASC;


SELECT * FROM KitchenMonitor
ORDER BY order_time ASC
LIMIT 5;