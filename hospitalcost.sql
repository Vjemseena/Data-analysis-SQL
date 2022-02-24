CREATE DATABASE  hospital;

USE hospital;

SHOW TABLES;

DROP table healthcost;

SET GLOBAL local_infile=1;

CREATE TABLE healthcost ( Age int, Gendre int,
LOS int, RACE int, TOTCHG double, APRDRG int);

LOAD DATA LOCAL INFILE 'C:/Users/jamsa/Downloads/hospitalcosts.csv' 
INTO TABLE healthcost FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM healthcost;

SELECT *
FROM healthcost 
WHERE Age IS NULL OR Gendre IS NULL OR LOS IS NULL 
OR RACE IS NULL OR TOTCHG IS NULL OR APRDRG IS NULL;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM healthcost WHERE RACE IS NULL;

SELECT Age, COUNT(*) as Frequency
FROM healthcost 
GROUP BY Age
ORDER BY Age ASC;

SELECT RACE, Min(TOTCHG) as mintotchg, ROUND( AVG(TOTCHG),2) as meantotchg, Max(TOTCHG) as maxtotchg
FROM healthcost 
GROUP BY RACE
ORDER BY RACE;

SELECT  MIN(TOTCHG) as min , MAX(TOTCHG) as max
FROM healthcost; 

SELECT APRDRG, COUNT(*) as Frequency
FROM healthcost 
GROUP BY APRDRG
ORDER BY APRDRG ASC;

SELECT LOS, Gendre, COUNT(*) as Frequency
FROM healthcost 
GROUP BY LOS, Gendre
ORDER BY LOS ASC;

SELECT LOS, Gendre, ROUND( AVG(TOTCHG),2) as totalcharge
FROM healthcost 
GROUP BY LOS,Gendre
ORDER BY LOS ASC;

SELECT LOS,  ROUND( AVG(TOTCHG),2) as totalcharge
FROM healthcost 
GROUP BY LOS,Gendre
ORDER BY LOS ASC;

