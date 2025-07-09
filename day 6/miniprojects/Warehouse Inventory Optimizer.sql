CREATE DATABASE Warehouse_optimizerDB;
USE Warehouse_optimizerDB;

CREATE TABLE ItemCategories (
  category_id INT AUTO_INCREMENT PRIMARY KEY,
  category_name VARCHAR(100) NOT NULL
);

CREATE TABLE Items (
  item_id INT AUTO_INCREMENT PRIMARY KEY,
  item_name VARCHAR(100) NOT NULL,
  category_id INT,
  FOREIGN KEY (category_id) REFERENCES ItemCategories(category_id)
);

CREATE TABLE Warehouses (
  warehouse_id INT AUTO_INCREMENT PRIMARY KEY,
  warehouse_name VARCHAR(100) NOT NULL,
  location VARCHAR(100)
);

CREATE TABLE StockMovementTypes (
  movement_type_id INT AUTO_INCREMENT PRIMARY KEY,
  movement_type_name VARCHAR(50) NOT NULL -- e.g., IN, OUT, ADJUSTMENT
);

CREATE TABLE StockMovements (
  movement_id INT AUTO_INCREMENT PRIMARY KEY,
  item_id INT NOT NULL,
  warehouse_id INT NOT NULL,
  movement_type_id INT NOT NULL,
  quantity INT NOT NULL,
  movement_date DATE NOT NULL,
  FOREIGN KEY (item_id) REFERENCES Items(item_id),
  FOREIGN KEY (warehouse_id) REFERENCES Warehouses(warehouse_id),
  FOREIGN KEY (movement_type_id) REFERENCES StockMovementTypes(movement_type_id)
);

CREATE INDEX idx_item_name ON Items(item_name);
CREATE INDEX idx_warehouse_id ON StockMovements(warehouse_id);
CREATE INDEX idx_movement_date ON StockMovements(movement_date);


INSERT INTO ItemCategories (category_name) VALUES
('Electronics'),
('Furniture'),
('Apparel');


INSERT INTO Items (item_name, category_id) VALUES
('Laptop', 1),
('Smartphone', 1),
('Desk', 2),
('Chair', 2),
('T-Shirt', 3),
('Jeans', 3);


INSERT INTO Warehouses (warehouse_name, location) VALUES
('Central Warehouse', 'New York'),
('East Warehouse', 'Boston');


INSERT INTO StockMovementTypes (movement_type_name) VALUES
('IN'),
('OUT'),
('ADJUSTMENT');


INSERT INTO StockMovements (item_id, warehouse_id, movement_type_id, quantity, movement_date) VALUES
(1, 1, 1, 50, '2025-07-01'),
(1, 1, 2, -5, '2025-07-02'),
(1, 1, 1, 20, '2025-07-03'),
(2, 1, 1, 30, '2025-07-01'),
(2, 1, 2, -10, '2025-07-02'),
(2, 2, 1, 25, '2025-07-03'),
(3, 1, 1, 15, '2025-07-01'),
(3, 1, 2, -2, '2025-07-02'),
(3, 2, 1, 10, '2025-07-03'),
(4, 1, 1, 20, '2025-07-01'),
(4, 1, 2, -5, '2025-07-02'),
(4, 2, 1, 10, '2025-07-03'),
(5, 1, 1, 40, '2025-07-01'),
(5, 1, 2, -15, '2025-07-02'),
(5, 2, 1, 30, '2025-07-03'),
(6, 1, 1, 25, '2025-07-01'),
(6, 1, 2, -5, '2025-07-02'),
(6, 2, 1, 20, '2025-07-03'),
(1, 2, 1, 15, '2025-07-04'),
(1, 2, 2, -3, '2025-07-05'),
(2, 2, 2, -5, '2025-07-04'),
(3, 2, 2, -1, '2025-07-05'),
(4, 2, 2, -2, '2025-07-04'),
(5, 2, 2, -4, '2025-07-05'),
(6, 2, 2, -2, '2025-07-04'),
(6, 2, 2, -1, '2025-07-05');


EXPLAIN
SELECT 
  sm.movement_id,
  i.item_name,
  w.warehouse_name,
  sm.quantity,
  sm.movement_date
FROM StockMovements sm
JOIN Items i ON sm.item_id = i.item_id
JOIN Warehouses w ON sm.warehouse_id = w.warehouse_id
WHERE i.item_name = 'Laptop'
ORDER BY sm.movement_date DESC;


CREATE OR REPLACE VIEW StockSummary AS
SELECT 
  i.item_id,
  i.item_name,
  ic.category_name,
  w.warehouse_id,
  w.warehouse_name,
  SUM(sm.quantity) AS current_stock
FROM StockMovements sm
JOIN Items i ON sm.item_id = i.item_id
JOIN ItemCategories ic ON i.category_id = ic.category_id
JOIN Warehouses w ON sm.warehouse_id = w.warehouse_id
GROUP BY i.item_id, w.warehouse_id;


SELECT *
FROM StockSummary
WHERE current_stock < 10
ORDER BY current_stock ASC
LIMIT 5;