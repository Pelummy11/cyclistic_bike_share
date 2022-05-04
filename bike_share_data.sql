--Merging the different tables into a datset using UNION
-- AND putting it into a table
SELECT * INTO bike_share_dataset
 FROM
(SELECT *
FROM [bike_share_data].[dbo].[june]
UNION
SELECT *
FROM [bike_share_data].[dbo].[july]
UNION
SELECT *
FROM [bike_share_data].[dbo].[august]
UNION
SELECT *
FROM [bike_share_data].[dbo].[september]
UNION
SELECT *
FROM [bike_share_data].[dbo].[october]
UNION
SELECT *
FROM [bike_share_data].[dbo].[november]
UNION
SELECT *
FROM [bike_share_data].[dbo].[december]
UNION
SELECT *
FROM [bike_share_data].[dbo].[january]
UNION
SELECT *
FROM [bike_share_data].[dbo].[february]
UNION
SELECT *
FROM [bike_share_data].[dbo].[march]
UNION
SELECT *
FROM [bike_share_data].[dbo].[april]
UNION
SELECT *
FROM [bike_share_data].[dbo].[may]) AS total_bike_share
---

---  Searching for Null values
SELECT *
FROM bike_share_dataset
WHERE rideable_type IS NULL

SELECT started_at
FROM bike_share_dataset
WHERE started_at IS NULL 

SELECT start_station_name
FROM bike_share_dataset
WHERE start_station_name IS NULL 

--- Removing the null values
DELETE
FROM bike_share_dataset
WHERE start_station_name IS NULL


-- Still searching for null values
SELECT start_station_id
FROM bike_share_dataset
WHERE start_station_id IS NULL

---Removing the null values
DELETE
FROM bike_share_dataset
WHERE start_station_id IS NULL

---Still searching for null values
SELECT end_station_name
FROM bike_share_dataset
WHERE end_station_name IS NULL

---Removing the null values
DELETE
FROM bike_share_dataset
WHERE end_station_name IS NULL
---Still searching for null values
SELECT end_station_id
FROM bike_share_dataset
WHERE end_station_id IS NULL
---Removing the null values
DELETE
FROM bike_share_dataset
WHERE end_station_id IS NULL

---Still searching for null values
SELECT start_lat
FROM bike_share_dataset
WHERE start_lat IS NULL

SELECT start_lng
FROM bike_share_dataset
WHERE start_lng IS NULL

SELECT end_lat
FROM bike_share_dataset
WHERE end_lat IS NULL

SELECT end_lng
FROM bike_share_dataset
WHERE end_lng IS NULL

SELECT member_casual
FROM bike_share_dataset
WHERE member_casual IS NULL

SELECT *
FROM bike_share_dataset
--- Checking for the distinct bike type
SELECT DISTINCT(rideable_type) AS bike_type
FROM bike_share_dataset
-- Count the distict bike types
SELECT COUNT(DISTINCT(rideable_type))
FROM bike_share_dataset

--- There are three types of bike
--- Electric, Classic and Docked bikes

--Checking for the distinct member type
SELECT DISTINCT(member_casual) AS user_type
FROM bike_share_dataset
-- There are two membership types: the Members and Casual user

--- Checking for negative time values as that could pose a problem later
SELECT ended_at, started_at
FROM bike_share_dataset
WHERE ended_at <started_at

--  Deleting the negative values
DELETE
FROM bike_share_dataset
WHERE ended_at <started_at

--- Creating a column for that extracts the start time and the end tim only
ALTER TABLE bike_share_dataset
ADD start_time time(7)
ALTER TABLE bike_share_dataset
ADD end_time time(7)

-- Creating a new column for the length of the rides(duration)
ALTER TABLE bike_share_dataset
ADD duration int


--- Extracting time from the started_at timestamp
SELECT  FORMAT(started_at, 'hh:mm:ss')  
FROM bike_share_dataset

---- Inserting the extracted time into the start_time column
UPDATE bike_share_dataset SET start_time = FORMAT(started_at, 'hh:mm:ss')  
FROM bike_share_dataset
WHERE start_time IS NULL

---Extracting time from the ended_at timestamp
SELECT  FORMAT(ended_at, 'hh:mm:ss')  
FROM bike_share_dataset

--- Inserting it into the end_time column
UPDATE bike_share_dataset SET end_time = FORMAT(ended_at, 'hh:mm:ss')  
FROM bike_share_dataset
WHERE end_time IS NULL

--- Subtracting the end_time and start_time to get the length of the ride/duration in seconds
SELECT DATEDIFF (second, start_time, end_time)
FROM bike_share_dataset

-- Inserting it into the duration column
UPDATE bike_share_dataset SET duration = DATEDIFF (second, start_time, end_time) 
FROM bike_share_dataset
WHERE duration IS NULL

-- Extrcacting the year from the timestamp
SELECT  DATEPART(YEAR, started_at)  
FROM bike_share_dataset

--- Creating a year column
ALTER TABLE bike_share_dataset
ADD year int

--- Inserting the year into the column
UPDATE bike_share_dataset SET year = DATEPART(YEAR, started_at) 
FROM bike_share_dataset
WHERE year IS NULL

--- extracting the month from the timestamp
SELECT  DATEPART(MONTH, started_at)  
FROM bike_share_dataset

--- Create a column for the month
ALTER TABLE bike_share_dataset
ADD month int

--- Inserting the month into the column
UPDATE bike_share_dataset SET month = DATEPART(MONTH, started_at) 
FROM bike_share_dataset
WHERE month IS NULL

--- extracting the day of the week from the timestamp
SELECT  DATEPART(WEEKDAY, started_at)  
FROM bike_share_dataset

--- Creating a column for weekday
ALTER TABLE bike_share_dataset
ADD week_day int 

--- Inserting the data into the weekday column
UPDATE bike_share_dataset SET week_day= DATEPART(WEEKDAY, started_at) 
FROM bike_share_dataset
WHERE week_day IS NULL

--- Creating a route columns for the ride
ALTER TABLE bike_share_dataset
ADD route nvarchar(max)

--- To creat a route, combining the start_station_name and end_station_name
SELECT CONCAT(start_station_name, ' to ', end_station_name)
FROM bike_share_dataset

---Inserting it into the route column
UPDATE bike_share_dataset SET route = CONCAT(start_station_name, ' to ', end_station_name)
FROM bike_share_dataset
WHERE route IS NULL

SELECT route
FROM bike_share_dataset

-----ANALYSIS

--- the total number of Members
SELECT COUNT(member_casual)
FROM bike_share_dataset
WHERE member_casual = 'member'
--- There are 2016329 Member users

--- the total number of casual riders
SELECT COUNT(member_casual)
FROM bike_share_dataset
WHERE member_casual = 'casual'
--- there are 1371242 casual riders

-- total number of electric bikes
SELECT COUNT(rideable_type) AS total_electric
FROM bike_share_dataset
WHERE rideable_type = 'electric_bike'
-- there are 470592 electric bikes

--- total number of classic bikes
SELECT COUNT(rideable_type) AS total_classic
FROM bike_share_dataset
WHERE rideable_type = 'classic_bike'
-- there are 520156 classic bikes

-- total number of docked_bikes
SELECT COUNT(rideable_type) AS total_docked
FROM bike_share_dataset
WHERE rideable_type = 'docked_bike'
-- there are 2396823 docked bikes

-- number of member riders using electric bike
SELECT member_casual, rideable_type, COUNT(*) AS member_electric
FROM bike_share_dataset
GROUP BY member_casual, rideable_type
HAVING member_casual = 'member'
AND rideable_type = 'electric_bike'
-- there are 285144 members using electric bikes

-- number of member riders using classic bikes
SELECT member_casual, rideable_type, COUNT(*) AS member_classic
FROM bike_share_dataset
GROUP BY member_casual, rideable_type
HAVING member_casual = 'member'
AND rideable_type = 'classic_bike'
-- there are 385194 member riders using classic bikes

-- number of member riders using docked bikes
SELECT member_casual, rideable_type, COUNT(*) AS member_classic
FROM bike_share_dataset
GROUP BY member_casual, rideable_type
HAVING member_casual = 'member'
AND rideable_type = 'docked_bike'
-- there are 1345991 member riders using docked bikes

-- number of casual riders using classic bikes
SELECT member_casual, rideable_type, COUNT(*) AS casual_classic
FROM bike_share_dataset
GROUP BY member_casual, rideable_type
HAVING member_casual = 'casual'
AND rideable_type = 'classic_bike'
-- there are 134962 casual riders using classic bikes

-- number of casual riders using electric bikes
SELECT member_casual, rideable_type, COUNT(*) AS casual_electric
FROM bike_share_dataset
GROUP BY member_casual, rideable_type
HAVING member_casual = 'casual'
AND rideable_type = 'electric_bike'
-- there are 185448 casual riders using electric bikes

-- number of casual riders using docked bikes
SELECT member_casual, rideable_type, COUNT(*) AS casual_docked
FROM bike_share_dataset
GROUP BY member_casual, rideable_type
HAVING member_casual = 'casual'
AND rideable_type = 'docked_bike'
-- there are 1050832s casual riders using docked bikes

--- Mean ride length
SELECT AVG(CAST(duration AS bigint)) AS avg_duration
FROM bike_share_dataset
---- mean duration is 1311s

--- Max ride length
SELECT MAX(duration) AS max_duration
FROM bike_share_dataset
--- max duration 42714s

--- Minimun ride length
SELECT MIN(duration) AS min_duration
FROM bike_share_dataset
-- min duration is 1s

--- Average ride length for member riders
SELECT member_casual, AVG(duration) AS avg_member_duration
FROM bike_share_dataset
GROUP BY member_casual
HAVING member_casual = 'member'
--- average ride length for a member rider is 893s

--- Average ride length for casual riders
SELECT member_casual, AVG(CAST(duration AS bigint)) AS avg_casual_duration
FROM bike_share_dataset
GROUP BY member_casual
HAVING member_casual = 'casual'
--- average ride length of a casual rider is 1936s

--- Maximum ride length for member riders
SELECT member_casual, MAX (duration) AS max_member_duration
FROM bike_share_dataset
GROUP BY member_casual
HAVING member_casual = 'member'
--- max ride length for member riders is 42576s

--- Minimum ride length for member riders
SELECT member_casual, MIN(duration) AS min_member_duration
FROM bike_share_dataset
GROUP BY member_casual
HAVING member_casual = 'member'
--- min ride length for member riders is 1s

--- Maximum ride length for member riders
SELECT member_casual, MAX (duration) AS max_casual_duration
FROM bike_share_dataset
GROUP BY member_casual
HAVING member_casual = 'casual'
--- max ride length for casual riders is 42714s

--- Minimum ride length for casual riders
SELECT member_casual, MIN (duration) AS min_casual_duration
FROM bike_share_dataset
GROUP BY member_casual
HAVING member_casual = 'casual'
--- max ride length for member riders is 1s

--- Route most taken by casual riders
SELECT  route, member_casual, duration, COUNT(*) AS num_of_trips
FROM bike_share_dataset
GROUP BY route, duration, member_casual
HAVING member_casual = 'casual'
ORDER BY num_of_trips DESC

--- Route most taken  taken by member rider
SELECT  route, member_casual, duration, COUNT(*) AS num_of_trips
FROM bike_share_dataset
GROUP BY route, duration, member_casual
HAVING member_casual = 'member'
ORDER BY num_of_trips DESC

--- Total  number of rides each day of the  week
SELECT  week_day, COUNT(*) AS num_of_rides
FROM bike_share_dataset
GROUP BY week_day
ORDER BY week_day 

---- Total number of rides each day of the  week for member riders
SELECT  week_day, member_casual, COUNT(*) AS member_num_rides
FROM bike_share_dataset
GROUP BY week_day, member_casual
HAVING member_casual = 'member'
ORDER BY week_day 

--- Total  number of rides each day of the  week for casual riders
SELECT  week_day, member_casual, COUNT(*) AS casual_num_rides
FROM bike_share_dataset
GROUP BY week_day, member_casual
HAVING member_casual = 'casual'
ORDER BY week_day 

--- Number of rides per month
SELECT   month, COUNT(*) AS num_rides_month
FROM bike_share_dataset
GROUP BY month
ORDER BY month

--- Number of rides per month for Member riders
SELECT member_casual, month, COUNT(*) AS member_ride_month
FROM bike_share_dataset
GROUP BY member_casual, month
HAVING member_casual = 'member'
ORDER BY month 

--- Number of rides per month for Casual riders
SELECT member_casual, month, COUNT(*) AS casual_ride_month
FROM bike_share_dataset
GROUP BY member_casual, month
HAVING member_casual = 'casual'
ORDER BY month 
