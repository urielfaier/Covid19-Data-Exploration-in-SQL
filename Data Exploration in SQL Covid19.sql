/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

SELECT *
FROM CovidDeaths
Where continent is not null

-- Select Data that we are going to be starting with

SELECT location, date, total_cases, new_cases, total_deaths, population 
FROM CovidDeaths
ORDER BY location, date


-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in Israel

SELECT 
	location, 
	date, 
	total_cases, 
	total_deaths,
	(total_deaths/total_cases)*100 AS Death_to_cases_ratio
FROM CovidDeaths
WHERE location LIKE '%Israel%'
ORDER BY location, date

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select 
	Location, 
	date, 
	Population, 
	total_cases,  
	(total_cases/population)*100 as PercentPopulationInfected
From CovidDeaths
--Where location like '%Israel%'
order by Location, date

-- Total Death vs Population
-- Shows what percentage of population Died Overall 
	
SELECT 
	location, 
	date, 
	population,
	total_cases,
	(total_deaths/population)*100 AS Death_of_population_ratio
FROM CovidDeaths
WHERE location LIKE '%Israel%'
ORDER BY location, date

-- Countries with Highest Infection Rate compared to Population

Select 
	Location, 
	Population, 
	MAX(total_cases) AS HighestInfectionCount,  
	Max((total_cases/population))*100 AS PercentPopulationInfected
From CovidDeaths
--Where location like '%Israel%'
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC



-- Countries with Highest Death Count per Population

SELECT 
	location, 
	MAX(cast(total_deaths AS INT)) AS TotalDeathCount,
	(MAX(total_deaths/population))*100 AS PercentPopulationDeath
FROM CovidDeaths
WHERE continent is not null -- AND location like '%Israel%'
GROUP BY location
ORDER BY TotalDeathCount DESC


-- BREAKING THINGS DOWN BY continent and countries 

WITH continet_country_groupby AS (
SELECT 
	continent,location,
	MAX(cast(total_deaths AS INT)) AS TotalDeathCount,
	(MAX(total_deaths/population))*100 AS PercentPopulationDeath
FROM CovidDeaths
WHERE continent is not null AND total_deaths IS NOT NULL
GROUP BY continent, location
)

-- Showing total death and ratio of Death to Population on a continent level Using the CTE

SELECT continent, SUM(TotalDeathCount) AS TotalDeathCount
FROM continet_country_groupby
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- Global numbers as a function of Date
	
SELECT 
	date, 
	SUM(new_cases) AS Total_cases,
	SUM(CAST(new_deaths AS INT)) AS Total_deaths,
	SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE continent IS NOT NULL 
GROUP BY date
ORDER BY date

-- Global numbers overall 

SELECT 
	SUM(new_cases) AS Total_cases,
	SUM(CAST(new_deaths AS INT)) AS Total_deaths,
	SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE continent IS NOT NULL 


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

SELECT 
	cd.continent, 
	cd.location, 
	cd.date, 
	cd.population, 
	vac.new_vaccinations,
	SUM(CONVERT(int, vac.new_vaccinations)) OVER(PARTITION BY cd.location ORDER BY cd.date) AS RollingPeopleVaccinated
FROM CovidDeaths cd 
JOIN CovidVaccinations vac
ON cd.location = vac.location 
AND cd.date = vac.date
WHERE cd.continent IS NOT NULL;


-- Using Temp Table to perform Calculation on Partition By in previous query


DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255), 
Location nvarchar(255), 
Date datetime,
Population numeric, 
New_vaccinations numeric, 
RollingPeopleVaccinated numeric
)

INSERT INTO  #PercentPopulationVaccinated
SELECT 
	cd.continent, 
	cd.location, 
	cd.date, 
	cd.population, 
	vac.new_vaccinations,
	SUM(CONVERT(int, vac.new_vaccinations)) OVER(PARTITION BY cd.location ORDER BY cd.date) AS RollingPeopleVaccinated
FROM CovidDeaths cd 
JOIN CovidVaccinations vac
ON cd.location = vac.location 
AND cd.date = vac.date
WHERE cd.continent IS NOT NULL;

SELECT 
	*, 
	(RollingPeopleVaccinated/population)*100 AS Rolling_Ratio_People_Vaccinated
FROM #PercentPopulationVaccinated


-- Creating View to store data for later visualizations

CREATE VIEW PercentPopulationVaccinated AS 
SELECT 
	cd.continent, 
	cd.location, 
	cd.date, 
	cd.population, 
	vac.new_vaccinations,
	SUM(CONVERT(int, vac.new_vaccinations)) OVER(PARTITION BY cd.location ORDER BY cd.date) AS RollingPeopleVaccinated
FROM CovidDeaths cd 
JOIN CovidVaccinations vac
ON cd.location = vac.location 
AND cd.date = vac.date
WHERE cd.continent IS NOT NULL;
