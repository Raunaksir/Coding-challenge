CREATE database Crime_Management;
USE Crime_Management;

CREATE TABLE Crime ( 
    CrimeID INT PRIMARY KEY, 
    IncidentType VARCHAR(255), 
    IncidentDate DATE, 
    Location VARCHAR(255), 
    Description TEXT, 
    Status VARCHAR(20) 
); 
 
CREATE TABLE Victim ( 
    VictimID INT PRIMARY KEY, 
    CrimeID INT, 
    Name VARCHAR(255), 
    ContactInfo VARCHAR(255), 
    Injuries VARCHAR(255), 
    FOREIGN KEY (CrimeID) REFERENCES Crime(CrimeID) 
); 
 
CREATE TABLE Suspect ( 
    SuspectID INT PRIMARY KEY, 
    CrimeID INT, 
    Name VARCHAR(255), 
    Description TEXT, 
    CriminalHistory TEXT, 
    FOREIGN KEY (CrimeID) REFERENCES Crime(CrimeID) 
); 

INSERT INTO Crime (CrimeID, IncidentType, IncidentDate, Location, Description, Status) 
VALUES 
    (1, 'Robbery', '2023-09-15', '123 Main St, Cityville', 'Armed robbery at a convenience store', 'Open'), 
    (2, 'Homicide', '2023-09-20', '456 Elm St, Townsville', 'Investigation into a murder case', 'Under 
Investigation'), 
    (3, 'Theft', '2023-09-10', '789 Oak St, Villagetown', 'Shoplifting incident at a mall', 'Closed'); 
 
INSERT INTO Victim (VictimID, CrimeID, Name, ContactInfo, Injuries) 
VALUES 
    (1, 1, 'John Doe', 'johndoe@example.com', 'Minor injuries'), 
    (2, 2, 'Jane Smith', 'janesmith@example.com', 'Deceased'),
    (3, 3, 'Alice Johnson', 'alicejohnson@example.com', 'None'); 
INSERT INTO Suspect (SuspectID, CrimeID, Name, Description, CriminalHistory) 
VALUES 
(1, 1, 'Robber 1', 'Armed and masked robber', 'Previous robbery convictions'), 
(2, 2, 'Unknown', 'Investigation ongoing', NULL), 
(3, 3, 'Suspect 1', 'Shoplifting suspect', 'Prior shoplifting arrests');

#1
SELECT * FROM Crime WHERE Status = 'Open';

#2
SELECT COUNT(*) AS TotalIncidents FROM Crime;

#3
SELECT DISTINCT IncidentType FROM Crime;

#4
SELECT * FROM Crime 
WHERE IncidentDate BETWEEN '2023-09-01' AND '2023-09-10';

ALTER TABLE Victim ADD Age INT;
ALTER TABLE Suspect ADD Age INT;

UPDATE Victim
SET Age = CASE VictimID
    WHEN 1 THEN 34   -- John Doe
    WHEN 2 THEN 29   -- Jane Smith
    WHEN 3 THEN 22   -- Alice Johnson
END;

UPDATE Suspect
SET Age = CASE SuspectID
    WHEN 1 THEN 40   -- Robber 1
    WHEN 2 THEN NULL -- Unknown
    WHEN 3 THEN 30   -- Suspect 1
END;

#5
SELECT Name, Age FROM Victim
UNION
SELECT Name, Age FROM Suspect
ORDER BY Age DESC;

#6
SELECT AVG(Age) AS AverageAge FROM (
    SELECT Age FROM Victim
    UNION ALL
    SELECT Age FROM Suspect
) AS AllPersons;

#7
SELECT IncidentType, COUNT(*) AS OpenCaseCount 
FROM Crime 
WHERE Status = 'Open' 
GROUP BY IncidentType;

#8
SELECT Name FROM Victim WHERE Name LIKE '%Doe%'
UNION
SELECT Name FROM Suspect WHERE Name LIKE '%Doe%';

#9
-- Open cases
SELECT Name FROM Victim 
WHERE CrimeID IN (SELECT CrimeID FROM Crime WHERE Status = 'Open')
UNION
SELECT Name FROM Suspect 
WHERE CrimeID IN (SELECT CrimeID FROM Crime WHERE Status = 'Open');

-- Closed cases
SELECT Name FROM Victim 
WHERE CrimeID IN (SELECT CrimeID FROM Crime WHERE Status = 'Closed')
UNION
SELECT Name FROM Suspect 
WHERE CrimeID IN (SELECT CrimeID FROM Crime WHERE Status = 'Closed');

#10
SELECT DISTINCT c.IncidentType 
FROM Crime c
JOIN Victim v ON c.CrimeID = v.CrimeID 
WHERE v.Age IN (30, 35)
UNION
SELECT DISTINCT c.IncidentType 
FROM Crime c
JOIN Suspect s ON c.CrimeID = s.CrimeID 
WHERE s.Age IN (30, 35);

#11
SELECT Name FROM Victim 
WHERE CrimeID IN (
    SELECT CrimeID FROM Crime WHERE IncidentType = 'Robbery'
)
UNION
SELECT Name FROM Suspect 
WHERE CrimeID IN (
    SELECT CrimeID FROM Crime WHERE IncidentType = 'Robbery'
);

#12
SELECT IncidentType, COUNT(*) AS OpenCount 
FROM Crime 
WHERE Status = 'Open' 
GROUP BY IncidentType 
HAVING COUNT(*) > 1;

#13
SELECT c.* 
FROM Crime c
JOIN Suspect s ON c.CrimeID = s.CrimeID
WHERE s.Name IN (SELECT Name FROM Victim);

#14
SELECT c.*, v.Name AS VictimName, s.Name AS SuspectName 
FROM Crime c
LEFT JOIN Victim v ON c.CrimeID = v.CrimeID
LEFT JOIN Suspect s ON c.CrimeID = s.CrimeID;

#15
SELECT DISTINCT c.* 
FROM Crime c
JOIN Suspect s ON c.CrimeID = s.CrimeID
WHERE s.Age > ALL (SELECT v.Age FROM Victim v WHERE v.CrimeID = c.CrimeID);

#16
SELECT Name, COUNT(*) AS IncidentCount 
FROM Suspect 
GROUP BY Name 
HAVING COUNT(*) > 1;

#17
SELECT * FROM Crime 
WHERE CrimeID NOT IN (SELECT DISTINCT CrimeID FROM Suspect);

#18
SELECT * FROM Crime 
WHERE IncidentType = 'Homicide'
AND EXISTS (
    SELECT 1 FROM Crime c2 
    WHERE c2.IncidentType = 'Robbery'
);

#19
SELECT c.CrimeID, c.IncidentType, COALESCE(s.Name, 'No Suspect') AS SuspectName 
FROM Crime c
LEFT JOIN Suspect s ON c.CrimeID = s.CrimeID;

#20
SELECT s.* 
FROM Suspect s
JOIN Crime c ON s.CrimeID = c.CrimeID
WHERE c.IncidentType IN ('Robbery', 'Assault');
