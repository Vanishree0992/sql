CREATE DATABASE flights;
USE flights;

CREATE TABLE Flights (
  flight_id INT PRIMARY KEY,
  source_airport VARCHAR(10),
  destination_airport VARCHAR(10)
);

INSERT INTO Flights VALUES (1, 'A', 'B');
INSERT INTO Flights VALUES (2, 'B', 'C');
INSERT INTO Flights VALUES (3, 'C', 'D');
INSERT INTO Flights VALUES (4, 'A', 'C');
INSERT INTO Flights VALUES (5, 'B', 'D');
INSERT INTO Flights VALUES (6, 'D', 'E');
INSERT INTO Flights VALUES (7, 'E', 'A'); -- To test loop detection!

WITH RECURSIVE FlightPaths AS (
  -- Start with direct flights
  SELECT
    source_airport,
    destination_airport,
    CONCAT(source_airport, ' -> ', destination_airport) AS path,
    1 AS hops,
    CONCAT(',', source_airport, ',', destination_airport, ',') AS visited
  FROM Flights

  UNION ALL

  -- Add connecting flights
  SELECT
    fp.source_airport,
    f.destination_airport,
    CONCAT(fp.path, ' -> ', f.destination_airport),
    fp.hops + 1,
    CONCAT(fp.visited, f.destination_airport, ',')
  FROM Flights f
  JOIN FlightPaths fp ON f.source_airport = fp.destination_airport
  WHERE fp.hops < 3
    AND fp.visited NOT LIKE CONCAT('%,', f.destination_airport, ',%')  -- prevent loops
)

SELECT
  source_airport,
  destination_airport,
  hops,
  path
FROM FlightPaths
ORDER BY source_airport, destination_airport, hops;


