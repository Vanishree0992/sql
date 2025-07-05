CREATE DATABASE Supply_ChainDB;
USE Supply_ChainDB;

CREATE TABLE Suppliers (
  supplier_id INT PRIMARY KEY AUTO_INCREMENT,
  supplier_name VARCHAR(100) NOT NULL,
  contact_email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Inventory (
  item_id INT PRIMARY KEY AUTO_INCREMENT,
  item_name VARCHAR(100) NOT NULL,
  quantity INT NOT NULL DEFAULT 0 CHECK (quantity >= 0),
  reorder_level INT NOT NULL DEFAULT 10 CHECK (reorder_level >= 0),
  is_discontinued BOOLEAN NOT NULL DEFAULT FALSE
  );


CREATE TABLE PurchaseOrders (
  order_id INT PRIMARY KEY AUTO_INCREMENT,
  item_id INT NOT NULL,
  supplier_id INT NOT NULL,
  quantity_ordered INT NOT NULL CHECK (quantity_ordered > 0),
  order_date DATE NOT NULL DEFAULT (CURRENT_DATE),
  FOREIGN KEY (item_id) REFERENCES Inventory(item_id) ON DELETE CASCADE,
  FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id) ON DELETE CASCADE
);

INSERT INTO Suppliers (supplier_name, contact_email)
VALUES
  ('Global Supplies Inc.', 'contact@globalsupplies.com'),
  ('Local Distributors Ltd.', 'info@localdistro.com');

-- Add inventory items
INSERT INTO Inventory (item_name, quantity, reorder_level)
VALUES
  ('Printer Paper', 100, 20),
  ('Ink Cartridge', 50, 15),
  ('Stapler', 25, 5);
  
  -- •	Update quantities and reorder levels.
  UPDATE Inventory
SET quantity = quantity + 50
WHERE item_id = 1;


UPDATE Inventory
SET reorder_level = 30
WHERE item_id = 1;

UPDATE Inventory
SET is_discontinued = TRUE
WHERE item_id = 3;

DELETE FROM Inventory
WHERE is_discontinued = TRUE
  AND item_id > 0; 
  
-- •	Use transactions for batch inventory updates.
START TRANSACTION;

UPDATE Inventory
SET quantity = quantity + 20
WHERE item_id = 1;

UPDATE Inventory
SET quantity = quantity + 10
WHERE item_id = 2;

INSERT INTO PurchaseOrders (item_id, supplier_id, quantity_ordered)
VALUES (1, 1, 20);

INSERT INTO PurchaseOrders (item_id, supplier_id, quantity_ordered)
VALUES (2, 2, 10);

COMMIT;
ROLLBACK;
