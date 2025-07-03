CREATE DATABASE friend_referral;
USE friend_referral;

CREATE TABLE users (
    user_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);


CREATE TABLE referrals (
    referral_id INT PRIMARY KEY,
    user_id INT,              -- who referred
    referred_user_id INT,     -- who was referred
    referral_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (referred_user_id) REFERENCES users(user_id)
);


CREATE TABLE purchases (
    purchase_id INT PRIMARY KEY,
    user_id INT,
    amount DECIMAL(10,2),
    purchase_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);


INSERT INTO users 
VALUES
(1, 'Alice', 'alice@example.com'),
(2, 'Bob', 'bob@example.com'),
(3, 'Charlie', 'charlie@example.com'),
(4, 'Diana', 'diana@example.com'),
(5, 'Eve', 'eve@example.com');


INSERT INTO referrals 
VALUES
(1, 1, 2, '2025-06-01'),
(2, 1, 3, '2025-06-02'),
(3, 2, 4, '2025-06-03');


INSERT INTO purchases 
VALUES
(1, 2, 100.00, '2025-06-10'),
(2, 3, 50.00, '2025-06-12'),
(3, 4, 75.00, '2025-06-15');

-- Count number of referrals per user (self join).
SELECT 
    u.user_id,
    u.name,
    COUNT(r.referred_user_id) AS total_referrals
FROM users u
LEFT JOIN referrals r ON u.user_id = r.user_id
GROUP BY u.user_id, u.name;

-- List users who referred others but made no purchases.
SELECT 
    u.user_id,
    u.name
FROM users u
JOIN referrals r ON u.user_id = r.user_id
LEFT JOIN purchases p ON u.user_id = p.user_id
WHERE p.purchase_id IS NULL
GROUP BY u.user_id, u.name;

-- Identify users with the most referred purchases.
SELECT 
    u.user_id,
    u.name,
    COUNT(p.purchase_id) AS referred_purchases_count,
    SUM(p.amount) AS total_referred_purchase_amount
FROM users u
JOIN referrals r ON u.user_id = r.user_id
JOIN purchases p ON r.referred_user_id = p.user_id
GROUP BY u.user_id, u.name
ORDER BY referred_purchases_count DESC;

