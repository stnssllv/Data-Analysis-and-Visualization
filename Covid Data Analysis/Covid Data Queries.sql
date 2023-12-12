/*Covid Data SQL Queries*/
--USE [CovidData ];

--View Data--
SELECT * FROM [CovidData ]..CovidDeaths WHERE continent IS NOT NULL ORDER BY 3, 4;
SELECT * FROM [CovidData ]..CovidVaccinations WHERE continent IS NOT NULL ORDER BY 3, 4;

--Data to be used--
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM [CovidData ]..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;

--Total cases vs total deaths (likelihood of dying if you get covid)--
SELECT location, date, total_cases, total_deaths, CAST((total_deaths/total_cases)*100 AS DECIMAL(10,2)) AS DeathPercentage
FROM [CovidData ]..CovidDeaths
WHERE location LIKE 'Bulgaria' AND continent IS NOT NULL
ORDER BY 1, 2;

--Total cases vs population (what percentage of population got covid)--
SELECT location, date, population, total_cases, CAST((total_cases/population)*100 AS DECIMAL(10,2)) AS PercentPopulationInfected
FROM [CovidData ]..CovidDeaths
ORDER BY 1, 2;

--Countries with highest infection rate compared to population--
SELECT location, population, MAX(total_cases), CAST(MAX(total_cases/population)*100 AS DECIMAL(10,2)) AS PercentPopulationInfected
FROM [CovidData ]..CovidDeaths
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC;

--Countries with highest death count per population--
SELECT location, MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM [CovidData ]..CovidDeaths
WHERE continent IS NOT NULL 
GROUP BY location
ORDER BY TotalDeathCount DESC;

--Continents with highest death count per population--
SELECT continent, MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM [CovidData ]..CovidDeaths
WHERE continent IS NOT NULL 
GROUP BY continent
ORDER BY TotalDeathCount DESC;

SELECT location, MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM [CovidData ]..CovidDeaths
WHERE continent IS NULL 
GROUP BY location
ORDER BY TotalDeathCount DESC;

--Global Numbers--
SELECT SUM(new_cases) AS Total_Cases, SUM(CAST(new_deaths AS int)) AS Total_Deaths, 
	CAST(SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS DECIMAL(10,2)) AS DeathPercentage
FROM [CovidData ]..CovidDeaths
WHERE continent IS NOT NULL 
ORDER BY 1, 2;

/*
SELECT date, SUM(new_cases) AS Total_Cases, SUM(CAST(new_deaths AS int)) AS Total_Deaths, 
	CAST(SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS DECIMAL(10,2)) AS DeathPercentage
FROM [CovidData ]..CovidDeaths
WHERE continent IS NOT NULL 
GROUP BY date
ORDER BY 1, 2;
*/

--Total population vs vaccinations--
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations 
FROM [CovidData ]..CovidDeaths d JOIN [CovidData ]..CovidVaccinations v 
	ON d.location = v.location AND d.date = v.date
WHERE d.continent IS NOT NULL
ORDER BY 1, 2, 3;


--Use CTE--
With PopVSvac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated) AS
(SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations, SUM(CAST(v.new_vaccinations AS int)) 
	OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS RollingPeopleVaccinated
FROM [CovidData ]..CovidDeaths d JOIN [CovidData ]..CovidVaccinations v 
	ON d.location = v.location AND d.date = v.date
WHERE d.continent IS NOT NULL)

SELECT *, CAST((RollingPeopleVaccinated/population)*100 AS DECIMAL(10,2)) AS PCT FROM PopVSvac;


--Temp Table--
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(continent nvarchar(255), location nvarchar(255), date datetime, population numeric, new_vaccinations numeric, RollingPeopleVaccinated numeric)

INSERT INTO #PercentPopulationVaccinated
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations, SUM(CAST(v.new_vaccinations AS int)) 
	OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS RollingPeopleVaccinated
FROM [CovidData ]..CovidDeaths d JOIN [CovidData ]..CovidVaccinations v 
	ON d.location = v.location AND d.date = v.date
--WHERE d.continent IS NOT NULL

SELECT *, CAST((RollingPeopleVaccinated/population)*100 AS DECIMAL(10,2)) AS PCT FROM #PercentPopulationVaccinated;


--View to store data for later visualizations--
CREATE VIEW PPV AS
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations, SUM(CAST(v.new_vaccinations AS int)) 
	OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS RollingPeopleVaccinated
FROM [CovidData ]..CovidDeaths d JOIN [CovidData ]..CovidVaccinations v 
	ON d.location = v.location AND d.date = v.date
WHERE d.continent IS NOT NULL

SELECT * FROM PPV;