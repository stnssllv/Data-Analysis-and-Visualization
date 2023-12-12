/*SQL Queries for Tableau Dashboard*/
--USE [CovidData ];

--Data for Table 1--
SELECT SUM(new_cases) AS Total_Cases, SUM(CAST(new_deaths AS int)) AS Total_Deaths, 
	CAST(SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS DECIMAL(10,2)) AS DeathPercentage
FROM [CovidData ]..CovidDeaths
WHERE continent IS NOT NULL 
ORDER BY 1, 2;


/*SELECT SUM(new_cases) AS Total_Cases, SUM(CAST(new_deaths AS int)) AS Total_Deaths, 
	CAST(SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS DECIMAL(10,2)) AS DeathPercentage
FROM [CovidData ]..CovidDeaths
WHERE location = 'World' 
ORDER BY 1, 2;*/


--Data for Table 2--
SELECT Location, SUM(CAST(new_deaths AS int)) AS TotalDeathCount
FROM [CovidData ]..CovidDeaths
WHERE continent IS NULL AND location NOT IN ('World', 'European Union', 'International')
GROUP BY location
ORDER BY TotalDeathCount DESC;


--Data for Table 3--
SELECT Location, Population, MAX(total_cases) AS HighestInfectionCount, CAST(MAX(total_cases/population)*100 AS DECIMAL(10,2)) AS PercentPopulationInfected
FROM [CovidData ]..CovidDeaths
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC;


--Data for Table 4--
Select Location, Population, Date, MAX(total_cases) AS HighestInfectionCount, CAST(MAX(total_cases/population)*100 AS DECIMAL(10,2)) AS PercentPopulationInfected
From [CovidData ]..CovidDeaths
GROUP BY location, population, date
ORDER BY PercentPopulationInfected DESC;