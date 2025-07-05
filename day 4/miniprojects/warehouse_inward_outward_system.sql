CREATE DATABASE Ware_house_DB;
USE Ware_house_DB;

CREATE TABLE Items (
  item_id INT PRIMARY KEY AUTO_INCREMENT,
  item_name VARCHAR(100) NOT NULL,
  current_stock INT NOT NULL CHECK (current_stock >= 0)
);

CREATE TABLE Inward (
  inward_id INT PRIMARY KEY AUTO_INCREMENT,
  item_id INT NOT NULL,
  inward_date DATETIME DEFAULT CURRENT_TIMESTAMP, -- ✅ Use DATETIME + DEFAULT
  quantity INT NOT NULL CHECK (quantity >= 0),
  FOREIGN KEY (item_id) REFERENCES Items(item_id) ON DELETE CASCADE
);

CREATE TABLE Outward (
  outward_id INT PRIMARY KEY AUTO_INCREMENT,
  item_id INT NOT NULL,
  outward_date DATETIME DEFAULT CURRENT_TIMESTAMP, -- ✅ Use DATETIME + DEFAULT
  quantity INT NOT NULL CHECK (quantity >= 0),
  FOREIGN KEY (item_id) REFERENCES Items(item_id) ON DELETE CASCADE
);

INSERT INTO Items (item_name, current_stock)
VALUES ('Item A', 100);

-- •	Use transactions for batch stock updates.
START TRANSACTION;

INSERT INTO Inward (item_id, quantity) VALUES (1, 20);
UPDATE Items
SET current_stock = current_stock + 20
WHERE item_id = 1 AND item_id > 0; -- Safe mode PK filter

INSERT INTO Outward (item_id, quantity) VALUES (1, 10);
UPDATE Items
SET current_stock = current_stock - 10
WHERE item_id = 1 AND item_id > 0; -- Safe mode PK filter

COMMIT;

-- •	Use DELETE to clear damaged or expired stock.
DELETE FROM Items
WHERE current_stock = 0
  AND item_id > 0;

SELECT * FROM Items;
SELECT * FROM Inward;
SELECT * FROM Outward;