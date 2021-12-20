CREATE DATABASE IF NOT EXISTS Database;

USE Database;

SHOW TABLES;

SET GLOBAL local_infile=1;

SET GLOBAL sql_mode = '';

CREATE TABLE covid19 (Date_reported date, Country_code varchar(10), Country varchar(30), Who_region char(10),
Newcases int, Cumulative_cases int, Newdeaths int, Cumulative_deaths int);

SELECT * FROM covid19;

DROP TABLE covid19;

LOAD DATA LOCAL INFILE '/Users/jemseenav/covid19.csv' INTO TABLE covid19 FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 ROWS (Date_reported,Country_code, Country ,Who_region ,
Newcases , cumulative_cases , Newdeaths, Cumulative_deaths);

SELECT COLUMN_NAME, data_type FROM information_schema.COLUMNS WHERE table_schema = 'jemseena' AND  TABLE_NAME = 'covid19';

SELECT * FROM covid19 WHERE Who_region IS NULL;

SELECT DISTINCT Who_region FROM covid19;

SELECT DISTINCT Country FROM covid19;

SELECT  * FROM covid19 WHERE (Newdeaths <0 or Newcases <0);

ALTER TABLE covid19 ADD COLUMN  Year int;
ALTER TABLE covid19 ADD COLUMN  Month int;

SET SQL_SAFE_UPDATES = 0;
UPDATE covid19 SET Year = YEAR(Date_reported);
UPDATE covid19 SET Month = MONTH(Date_reported);


/* replacing negative values */
UPDATE covid19 
SET Newcases  = CASE WHEN  Newcases<0 THEN  abs(Newcases)
                    ELSE abs(Newcases)
                END
,   Newdeaths = CASE WHEN Newdeaths<0 THEN  abs(Newdeaths)  
					 ELSE abs(Newdeaths)
                 END
 ;

/* who_region wise */
SELECT Date_reported, sum(Cumulative_cases) as cumulativecases
FROM covid19
GROUP BY  Date_reported
order by Date_reported;

SELECT Date_reported ,Who_region, sum(Cumulative_cases) as cumulativecases
FROM covid19 where Date_reported = '2021-12-16'
GROUP BY  Who_region,Date_reported
order by Date_reported;

SELECT  sum(Cumulative_cases) as cumulativecases
FROM covid19 where Date_reported = '2021-12-15';

SELECT Who_region, sum(Cumulative_cases) as cumulativecases, sum(Cumulative_deaths) as cumulativedeaths
FROM covid19 where Date_reported = '2021-12-16'
GROUP BY  Who_region,Date_reported
order by cumulativecases desc;


/* Finding out total cases country wise  */
SELECT Country, sum(Newcases) as Totalcases
FROM covid19
GROUP BY Country
order by  Totalcases desc;


/* which country is badly hit in 2020*/
SELECT Country, sum(Newcases) as Totalcases
FROM covid19 where Year='2020'
GROUP BY Country
order by  Totalcases desc;

/* which country is badly hit in 2021*/
SELECT Country, sum(Newcases) as Totalcases
FROM covid19 where Year='2021'
GROUP BY Country
order by  Totalcases desc;

/* Finding out total deaths country wise  */
SELECT Country, sum(Newdeaths) as Totalcases
FROM covid19
GROUP BY Country
order by  Totalcases desc;


/* Calculating Infection fatality rate (IFR) */

ALTER TABLE covid19 ADD COLUMN  IFR FLOAT;
UPDATE covid19 SET IFR = (Cumulative_deaths/Cumulative_cases)*100;


SELECT sum(Cumulative_cases) as cumulativecases, Country
FROM covid19 where Date_reported = '2021-12-16'
GROUP BY Country
order by  cumulativecases desc;

SELECT sum(Cumulative_cases) as cumulativecases
FROM covid19 where Date_reported = '2021-12-16';

SELECT IFR FROM covid19;
UPDATE covid19 
SET IFR  = CASE WHEN  IFR is null  THEN  0
			ELSE IFR 
			END
 ;
