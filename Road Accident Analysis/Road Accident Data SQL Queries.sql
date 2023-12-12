/*Road Accident Analysis SQL Queries*/
--USE [Road Accident];

--Total CY (Current Year) Casualties--
SELECT SUM(number_of_casualties) AS CY_Casualties
FROM [Road Accident]..road_accident
WHERE YEAR(accident_date) = '2022';

--Total CY Accidents--
SELECT COUNT(DISTINCT accident_index) AS CY_Accidents
FROM [Road Accident]..road_accident
WHERE YEAR(accident_date) = '2022';

--CY Fatal Casualties--
SELECT SUM(number_of_casualties) AS CY_Fatal_Casualties
FROM [Road Accident]..road_accident
WHERE YEAR(accident_date) = '2022' AND accident_severity = 'Fatal';

--CY Serious Casualties--
SELECT SUM(number_of_casualties) AS CY_Serious_Casualties
FROM [Road Accident]..road_accident
WHERE YEAR(accident_date) = '2022' AND accident_severity = 'Serious';

--CY Slight Casualties--
SELECT SUM(number_of_casualties) AS CY_Slight_Casualties
FROM [Road Accident]..road_accident
WHERE YEAR(accident_date) = '2022' AND accident_severity = 'Slight';

--Casualties by Vehicle Type--
SELECT
	CASE
		WHEN vehicle_type LIKE '%Agri%' THEN 'Agricultural'
		WHEN vehicle_type LIKE '%cycle%' THEN 'Bike'
		WHEN vehicle_type LIKE '%[Bb]us%' THEN 'Bus'
		WHEN vehicle_type LIKE '%[Cc]ar%' THEN 'Car'
		WHEN vehicle_type LIKE '%Goods%' THEN 'Van'
		ELSE 'Other'
 	END AS Vehicle_Group, SUM(number_of_casualties) AS CY_Casualties
FROM [Road Accident]..road_accident
WHERE YEAR(accident_date) = '2022'
GROUP BY
	CASE
		WHEN vehicle_type LIKE '%Agri%' THEN 'Agricultural'
		WHEN vehicle_type LIKE '%cycle%' THEN 'Bike'
		WHEN vehicle_type LIKE '%[Bb]us%' THEN 'Bus'
		WHEN vehicle_type LIKE '%[Cc]ar%' THEN 'Car'
		WHEN vehicle_type LIKE '%Goods%' THEN 'Van'
		ELSE 'Other'
 	END;

--CY Casualties Monthly Trend--
SELECT DATENAME(MONTH, accident_date) AS Month_Name, SUM(number_of_casualties) AS CY_Casualties
FROM [Road Accident]..road_accident
WHERE YEAR(accident_date) = '2022'
GROUP BY DATENAME(MONTH, accident_date);

--PY (Previous Year) Casualties Monthly Trend--
SELECT DATENAME(MONTH, accident_date) AS Month_Name, SUM(number_of_casualties) AS PY_Casualties
FROM [Road Accident]..road_accident
WHERE YEAR(accident_date) = '2021'
GROUP BY DATENAME(MONTH, accident_date);

--Casualties by Road Type--
SELECT road_type, SUM(number_of_casualties) AS CY_Casualties
FROM [Road Accident]..road_accident
WHERE YEAR(accident_date) = '2022'
GROUP BY road_type;

--Casualties by Urban/Rural--
SELECT urban_or_rural_area, CAST(CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) * 100 / (SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) FROM road_accident WHERE YEAR(accident_date) = '2022') AS DECIMAL(10,2)) AS PCT
FROM [Road Accident]..road_accident
WHERE YEAR(accident_date) = '2022'
GROUP BY urban_or_rural_area;

--Casualties by Light Conditions--
SELECT
	CASE
		WHEN light_conditions LIKE '%Day%' THEN 'Light'
		WHEN light_conditions LIKE '%Dark%' THEN 'Dark'
	END AS Light_Condition,
	CAST(CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) * 100 / (SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) FROM road_accident WHERE YEAR(accident_date) = '2022') AS DECIMAL(10,2)) AS PCT
FROM [Road Accident]..road_accident
WHERE YEAR(accident_date) = '2022'
GROUP BY 
	CASE
		WHEN light_conditions LIKE '%Day%' THEN 'Light'
		WHEN light_conditions LIKE '%Dark%' THEN 'Dark'
	END;

--Top 10 Cities by Total Casualties--
SELECT TOP 10 local_authority, SUM(number_of_casualties) AS Total_Casualties
FROM [Road Accident]..road_accident
GROUP BY local_authority
ORDER BY Total_Casualties DESC;