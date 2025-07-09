CREATE DATABASE ForumDB;
USE ForumDB;

CREATE TABLE Users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  user_name VARCHAR(100) NOT NULL,
  email VARCHAR(100)
);


CREATE TABLE Posts (
  post_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  post_title VARCHAR(200) NOT NULL,
  post_content TEXT,
  post_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES Users(user_id)
);


CREATE TABLE Comments (
  comment_id INT AUTO_INCREMENT PRIMARY KEY,
  post_id INT NOT NULL,
  user_id INT NOT NULL,
  comment_content TEXT,
  comment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (post_id) REFERENCES Posts(post_id),
  FOREIGN KEY (user_id) REFERENCES Users(user_id)
);


CREATE INDEX idx_user_id ON Posts(user_id);
CREATE INDEX idx_post_date ON Posts(post_date);
CREATE INDEX idx_post_title ON Posts(post_title);



INSERT INTO Users (user_name, email) VALUES
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com'),
('Carol', 'carol@example.com'),
('David', 'david@example.com'),
('Eve', 'eve@example.com');


INSERT INTO Posts (user_id, post_title, post_content, post_date) VALUES
(1, 'Welcome to the Forum', 'First post content', '2025-07-01 10:00:00'),
(1, 'Tips for New Members', 'Be kind and follow rules.', '2025-07-01 11:00:00'),
(2, 'Tech Talk', 'Discuss latest tech trends.', '2025-07-02 09:30:00'),
(2, 'Gadget Reviews', 'Share your reviews.', '2025-07-02 10:30:00'),
(3, 'Travel Diaries', 'Post your travel stories.', '2025-07-03 12:00:00'),
(3, 'Food Lovers', 'Discuss recipes.', '2025-07-03 13:00:00'),
(4, 'Fitness Goals', 'Share workouts.', '2025-07-04 14:00:00'),
(4, 'Book Club', 'Recommend books.', '2025-07-04 15:00:00'),
(5, 'Movie Nights', 'Review movies.', '2025-07-05 16:00:00'),
(5, 'Music Lounge', 'Talk about songs.', '2025-07-05 17:00:00');


INSERT INTO Comments (post_id, user_id, comment_content, comment_date) VALUES
(1, 2, 'Thanks for starting this!', '2025-07-01 10:10:00'),
(1, 3, 'Looking forward to contributing.', '2025-07-01 10:15:00'),
(2, 4, 'Good advice.', '2025-07-01 11:05:00'),
(2, 5, 'Excited to join.', '2025-07-01 11:10:00'),
(3, 1, 'Tech is amazing.', '2025-07-02 09:40:00'),
(3, 3, 'Love this topic.', '2025-07-02 09:50:00'),
(3, 4, 'What\'s new?', '2025-07-02 09:55:00'),
(4, 1, 'My review is coming soon.', '2025-07-02 10:35:00'),
(4, 2, 'Love gadgets.', '2025-07-02 10:40:00'),
(5, 4, 'I went to Bali last year.', '2025-07-03 12:05:00'),
(5, 5, 'I want to visit Japan.', '2025-07-03 12:10:00'),
(5, 2, 'Traveling is life.', '2025-07-03 12:15:00'),
(6, 1, 'I tried your recipe!', '2025-07-03 13:05:00'),
(6, 5, 'Delicious.', '2025-07-03 13:10:00'),
(7, 3, 'Today was leg day.', '2025-07-04 14:10:00'),
(7, 2, 'New PR achieved.', '2025-07-04 14:15:00'),
(7, 5, 'Motivated!', '2025-07-04 14:20:00'),
(8, 1, 'Loved this book.', '2025-07-04 15:05:00'),
(8, 4, 'Added to my list.', '2025-07-04 15:10:00'),
(8, 5, 'Reading tonight.', '2025-07-04 15:15:00'),
(9, 2, 'Watched it yesterday.', '2025-07-05 16:10:00'),
(9, 3, 'Must watch!', '2025-07-05 16:15:00'),
(9, 4, 'Classic.', '2025-07-05 16:20:00'),
(10, 1, 'Love this song.', '2025-07-05 17:05:00'),
(10, 2, 'Playlist updated.', '2025-07-05 17:10:00'),
(10, 3, 'Listening now.', '2025-07-05 17:15:00'),
(10, 4, 'Added to my favorites.', '2025-07-05 17:20:00');


EXPLAIN
SELECT 
  p.post_id,
  p.post_title,
  u.user_name AS post_author,
  c.comment_content,
  cu.user_name AS comment_author,
  c.comment_date
FROM Posts p
JOIN Users u ON p.user_id = u.user_id
JOIN Comments c ON p.post_id = c.post_id
JOIN Users cu ON c.user_id = cu.user_id
WHERE p.post_id = 3
ORDER BY c.comment_date DESC;


CREATE OR REPLACE VIEW PostCommentView AS
SELECT 
  p.post_id,
  p.post_title,
  p.post_content,
  p.post_date,
  u.user_name AS post_author,
  c.comment_id,
  c.comment_content,
  c.comment_date,
  cu.user_name AS comment_author
FROM Posts p
JOIN Users u ON p.user_id = u.user_id
LEFT JOIN Comments c ON p.post_id = c.post_id
LEFT JOIN Users cu ON c.user_id = cu.user_id;


SELECT post_id, post_title, post_date, post_author
FROM (
  SELECT DISTINCT p.post_id, p.post_title, p.post_date, u.user_name AS post_author
  FROM Posts p
  JOIN Users u ON p.user_id = u.user_id
  ORDER BY p.post_date DESC
) AS recent_posts
LIMIT 5;