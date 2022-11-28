use PortfolioProject

-- The dataset is from January 01,2020 to November 22, 2022
--The updated dataset is available on this link
--https://ourworldindata.org/covid-deaths

select top(20) * from CovidDeaths
order by 3 DESC,4 DESC

select top(20) * from CovidVaccinations
order by 3 DESC,4 DESC

select distinct(iso_code),location from CovidDeaths
where continent IS NULL

--select data to be used

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2

--looking at total cases vs total deaths (global)

SELECT location, date, total_cases, total_deaths, round((total_deaths/total_cases)*100,2) AS death_percentage
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2

--shows death percentage in my country
SELECT location, date, total_cases, total_deaths, round((total_deaths/total_cases)*100,2) AS death_percentage
FROM PortfolioProject..CovidDeaths
WHERE location like '%Philippines%'
AND continent IS NOT NULL
ORDER BY 1,2

--FILTERED USING WHERE CLAUSE "iso_code NOT like 'OWID%'" TO REMOVE UNNECESSARY RECORDS FROM THE DATASET.
--OUR WORLD IN DATA(OWID RECORDS WITH EITHER NO SPECIFIC COUNTRY NAME/LOCATION OR CONTINENT)

--total cases vs population
--shows what percentage of population infected with covid
SELECT location, date, population,total_cases, round((total_cases/population)*100,2) AS 'Infection Percentage'
FROM PortfolioProject..CovidDeaths
WHERE population IS NOT NULL
AND iso_code NOT like 'OWID%'
ORDER BY 1,2


--HIGHEST AND LOWEST INFECTION RATES

--countries with highest infection rate against population

SELECT location,  population, MAX(total_cases) AS 'Highest Infection Count', ROUND(MAX((total_cases/population)*100),2) AS 'Infection Percentage'
FROM PortfolioProject..CovidDeaths
WHERE population IS NOT NULL
AND iso_code NOT like 'OWID%'
GROUP BY location,population
ORDER BY 4 DESC



--TOP 10 COUNTRIES WITH HIGHEST INFECTION RATE AGAINST POPULATION
SELECT top (10) location,  population, MAX(total_cases) AS 'Highest Infection Count', ROUND(MAX((total_cases/population)*100),2) AS 'Infection Percentage'
FROM PortfolioProject..CovidDeaths
WHERE population IS NOT NULL
AND iso_code NOT like 'OWID%'
GROUP BY location,population
ORDER BY 4 DESC

--TOP 20 COUNTRIES WITH LOWEST INFECTION RATE COMPARED TO POPULATION
--SHOWS COUNTRIES WITH ZERO OR NEAR ZERO INFECTION PERCENTAGE
--SURPRISING DATA SHOWS THAT CHINA WHERE IT ALL STARTED HAS ONE OF THE LOWEST INFECTION RATE
--SINCE IT HAS 14 BILLION POPULATION COMPARED TO ITS INFECTION COUNT OF MORE THAN 1 MILLION
SELECT top (20) location,  population, MAX(total_cases) AS 'Lowest Infection Count', 
ROUND(MAX((total_cases/population)*100),2) AS 'Infection Percentage'
FROM PortfolioProject..CovidDeaths
WHERE population IS NOT NULL
AND iso_code NOT like 'OWID%'
GROUP BY location,population
ORDER BY 4 ASC,2 DESC

--HIGHEST AND LOWEST DEATH COUNT

--showing countries with highest death count per population
SELECT location,  population, MAX(CAST(total_deaths as int)) AS 'Highest Death Count',
ROUND(MAX((total_deaths/population)*100),2) AS 'Death Percentage'
FROM PortfolioProject..CovidDeaths
WHERE population IS NOT NULL
AND iso_code NOT like 'OWID%'
GROUP BY location,population
ORDER BY 3 DESC

--showing countries with lowest death count per population
SELECT location,  population, MAX(CAST(total_deaths as int)) AS 'Death Count',
ROUND(MAX((total_deaths/population)*100),2) AS 'Death Percentage'
FROM PortfolioProject..CovidDeaths
WHERE population IS NOT NULL
AND iso_code NOT like 'OWID%'
GROUP BY location,population
ORDER BY 3,2 DESC

--HIGHEST AND LOWEST DEATH PERCENTAGES

--showing countries with highest death percentage per population
SELECT location,  population, MAX(CAST(total_deaths as int)) AS 'Death Count',
ROUND(MAX((total_deaths/population)*100),2) AS 'Highest Death Percentage'
FROM PortfolioProject..CovidDeaths
WHERE population IS NOT NULL
AND iso_code NOT like 'OWID%'
GROUP BY location,population
ORDER BY 4 DESC,3 DESC

--showing countries with lowest death percentage per population
SELECT location,  population, MAX(CAST(total_deaths as int)) AS 'Death Count',
ROUND(MAX((total_deaths/population)*100),2) AS 'Lowest Death Percentage'
FROM PortfolioProject..CovidDeaths
WHERE population IS NOT NULL
AND iso_code NOT like 'OWID%'
GROUP BY location,population
ORDER BY 4 ASC,3 DESC, 2 DESC

--DATA EXPLORATION BY CONTINENT

--TOTAL DEATH COUNT BY CONTINENT
--this query only shows the max per country
SELECT distinct(continent),  MAX(CAST(total_deaths as int)) AS 'Total Death Count'
--ROUND(MAX((total_deaths/population)*100),2) AS 'Lowest Death Percentage'
FROM PortfolioProject..CovidDeaths
--WHERE continent IS NOT NULL
WHERE iso_code NOT like 'OWID%'
GROUP BY continent
ORDER BY [Total Death Count] DESC;

 --CORRECT QUERY ON SUM OF MAX(TOTAL DEATHS BY CONTINENT)
 select continent, sum(maxtotals) as totalDeathsPerContinent from
(
select continent, location, MAX(CAST(total_deaths as int)) AS maxtotals
FROM PortfolioProject..CovidDeaths
WHERE iso_code NOT like 'OWID%'
group by continent, location
) a
group by continent
order by totalDeathsPerContinent DESC