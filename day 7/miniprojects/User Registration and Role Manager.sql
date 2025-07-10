CREATE DATABASE user_registration;
USE user_registration;

CREATE TABLE Users (
  user_id INT PRIMARY KEY AUTO_INCREMENT,
  user_name VARCHAR(100),
  email VARCHAR(100),
  role_id INT
);

CREATE TABLE Roles (
  role_id INT PRIMARY KEY AUTO_INCREMENT,
  role_name VARCHAR(50)
);

CREATE TABLE UserSettings (
  setting_id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT,
  setting_key VARCHAR(100),
  setting_value VARCHAR(100),
  FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE RoleAudit (
  audit_id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT,
  old_role_id INT,
  new_role_id INT,
  changed_on DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Roles (role_name) VALUES ('Admin'), ('Manager'), ('Employee');

INSERT INTO Users (user_name, email, role_id) VALUES
('Alice', 'alice@example.com', 1),
('Bob', 'bob@example.com', 2),
('Charlie', 'charlie@example.com', 3),
('David', 'david@example.com', 3),
('Eve', 'eve@example.com', 2),
('Frank', 'frank@example.com', 3),
('Grace', 'grace@example.com', 3),
('Heidi', 'heidi@example.com', 2),
('Ivan', 'ivan@example.com', 1),
('Judy', 'judy@example.com', 3);

INSERT INTO UserSettings (user_id, setting_key, setting_value) VALUES
(1, 'theme', 'dark'), (1, 'language', 'en'),
(2, 'theme', 'light'), (2, 'language', 'fr'),
(3, 'theme', 'light'), (3, 'language', 'en'),
(4, 'theme', 'dark'), (4, 'language', 'es'),
(5, 'theme', 'light'), (5, 'language', 'en'),
(6, 'theme', 'dark'), (6, 'language', 'en'),
(7, 'theme', 'light'), (7, 'language', 'en'),
(8, 'theme', 'dark'), (8, 'language', 'fr'),
(9, 'theme', 'light'), (9, 'language', 'en'),
(10, 'theme', 'dark'), (10, 'language', 'es');

-- Views: One for each role
CREATE VIEW vw_admin_users AS
SELECT u.user_id, u.user_name, u.email, r.role_name
FROM Users u JOIN Roles r ON u.role_id = r.role_id;

CREATE VIEW vw_manager_users AS
SELECT u.user_id, u.user_name, r.role_name
FROM Users u JOIN Roles r ON u.role_id = r.role_id;

CREATE VIEW vw_employee_users AS
SELECT u.user_id, u.user_name
FROM Users u;
SELECT * FROM vw_admin_users;

SELECT * FROM vw_manager_users;

SELECT * FROM vw_employee_users;

-- Stored Procedure: Assign a role
DELIMITER $$

CREATE PROCEDURE AssignRole(IN p_user_id INT, IN p_role_id INT)
BEGIN
  DECLARE v_old_role_id INT;

  SELECT role_id INTO v_old_role_id FROM Users WHERE user_id = p_user_id;

  UPDATE Users SET role_id = p_role_id WHERE user_id = p_user_id;

  INSERT INTO RoleAudit (user_id, old_role_id, new_role_id)
  VALUES (p_user_id, v_old_role_id, p_role_id);
END$$

DELIMITER ;

CALL AssignRole(3, 1);

-- Function: Check if user is Admin
DELIMITER $$

CREATE FUNCTION IsAdmin(p_user_id INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
  DECLARE v_role_id INT;

  SELECT role_id INTO v_role_id FROM Users WHERE user_id = p_user_id;

  RETURN v_role_id = 1;
END$$

DELIMITER ;

SELECT IsAdmin(3) AS IsAdminStatus;

--  Trigger: Insert default settings after user creation
DELIMITER $$

CREATE TRIGGER trg_add_default_settings
AFTER INSERT ON Users
FOR EACH ROW
BEGIN
  INSERT INTO UserSettings (user_id, setting_key, setting_value)
  VALUES (NEW.user_id, 'theme', 'light'),
         (NEW.user_id, 'language', 'en');
END$$

DELIMITER ;
SELECT * FROM RoleAudit;