-- Create the database
CREATE DATABASE MusicStreamingDB;

-- Use the database
USE MusicStreamingDB;

-- creating tables
CREATE TABLE Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    UserName VARCHAR(100) NOT NULL,
    Email VARCHAR(100)
);

CREATE TABLE Songs (
    SongID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(200) NOT NULL,
    Artist VARCHAR(100),
    PlayCount INT DEFAULT 0
);

CREATE TABLE Playlists (
    PlaylistID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    PlaylistName VARCHAR(100) NOT NULL,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE PlaylistSongs (
    PlaylistSongID INT AUTO_INCREMENT PRIMARY KEY,
    PlaylistID INT,
    SongID INT,
    FOREIGN KEY (PlaylistID) REFERENCES Playlists(PlaylistID),
    FOREIGN KEY (SongID) REFERENCES Songs(SongID)
);

-- inserting data
INSERT INTO Users (UserName, Email) VALUES
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com'),
('Charlie', 'charlie@example.com');

INSERT INTO Songs (Title, Artist, PlayCount) VALUES
('Song A', 'Artist X', 50),
('Song B', 'Artist Y', 120),
('Song C', 'Artist Z', 90),
('Song D', 'Artist X', 30),
('Song E', 'Artist Y', 200);

INSERT INTO Playlists (UserID, PlaylistName) VALUES
(1, 'Alice Hits'),
(1, 'Alice Party'),
(1, 'Alice Chill'),
(2, 'Bob Vibes'),
(2, 'Bob Workout'),
(3, 'Charlie Classics');

INSERT INTO PlaylistSongs (PlaylistID, SongID) VALUES
(1, 1),
(1, 2),
(2, 2),
(2, 3),
(3, 4),
(4, 2),
(4, 5),
(5, 3),
(5, 1),
(6, 5);

-- Query most played songs

SELECT 
    SongID,
    Title,
    Artist,
    PlayCount
FROM 
    Songs
ORDER BY 
    PlayCount DESC
LIMIT 5;

--  List users with more than 2 playlists
SELECT 
    u.UserID,
    u.UserName,
    COUNT(p.PlaylistID) AS PlaylistCount
FROM 
    Users u
JOIN 
    Playlists p ON u.UserID = p.UserID
GROUP BY 
    u.UserID, u.UserName
HAVING 
    PlaylistCount > 2;
