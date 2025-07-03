CREATE DATABASE hotel_dashboard;
USE hotel_dashboard;

-- Rooms Table
CREATE TABLE rooms (
    room_id INT PRIMARY KEY,
    room_number VARCHAR(10),
    room_type VARCHAR(50)
);

CREATE TABLE guests (
    guest_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);


CREATE TABLE bookings (
    booking_id INT PRIMARY KEY,
    guest_id INT,
    room_id INT,
    check_in DATE,
    check_out DATE,
    FOREIGN KEY (guest_id) REFERENCES guests(guest_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);


INSERT INTO rooms
 VALUES
(1, '101', 'Single'),
(2, '102', 'Double'),
(3, '103', 'Suite');


INSERT INTO guests
 VALUES
(1, 'Alice', 'alice@example.com'),
(2, 'Bob', 'bob@example.com'),
(3, 'Charlie', 'charlie@example.com');


INSERT INTO bookings 
VALUES
(1, 1, 1, '2025-06-01', '2025-06-05'),
(2, 2, 2, '2025-06-03', '2025-06-07'),
(3, 1, 2, '2025-06-10', '2025-06-12');


-- Calculate occupancy rates per room.
WITH room_days AS (
    SELECT 
        r.room_id,
        r.room_number,
        SUM(
            GREATEST(
                DATEDIFF(
                    LEAST(b.check_out, '2025-06-30'),
                    GREATEST(b.check_in, '2025-06-01')
                ), 
                0
            )
        ) AS occupied_days
    FROM rooms r
    LEFT JOIN bookings b 
        ON r.room_id = b.room_id
        AND b.check_out >= '2025-06-01'
        AND b.check_in <= '2025-06-30'
    GROUP BY r.room_id, r.room_number
)
SELECT 
    room_id,
    room_number,
    COALESCE(ROUND(occupied_days / 30.0 * 100, 2), 0) AS occupancy_rate_percent
FROM room_days;


-- Find guests with multiple bookings.
SELECT 
    g.guest_id,
    g.name,
    COUNT(b.booking_id) AS bookings_count
FROM guests g
JOIN bookings b ON g.guest_id = b.guest_id
GROUP BY g.guest_id, g.name
HAVING COUNT(b.booking_id) > 1;

-- List rooms never booked.

SELECT 
    r.room_id,
    r.room_number,
    r.room_type
FROM rooms r
LEFT JOIN bookings b ON r.room_id = b.room_id
WHERE b.booking_id IS NULL;
