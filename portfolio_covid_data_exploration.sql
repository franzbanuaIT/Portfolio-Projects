/* 
Covid 19 Data Exploration
Raw data was manipulated in MS Excel removing unnecessary columns 
and then created 2 tables: CovidDeaths and CovidVaccinations then imported data as Excel(.xlsx files) in SQL Server

SQL skills used: Joins, Aggregate Functions, Sub Queries, CTE's, Temp Tables, 
Windows Functions,  Creating Views, Converting Data Types

The dataset covers from January 01,2020 to November 22, 2022

The updated dataset is available on this link --https://ourworldindata.org/covid-deaths

*/

use PortfolioProject

select top(20) * from CovidDeaths
order by 3 DESC,4 DESC

select top(20) * from CovidVaccinations
order by 3 DESC,4 DESC

select distinct(iso_code),location from CovidDeaths
where continent IS NULL

--Select data to be used

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2

--Looking at total cases vs total deaths (Global)

SELECT location, date, total_cases, total_deaths, round((total_deaths/total_cases)*100,2) AS death_percentage
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2

--Shows death percentage in my country
SELECT location, date, total_cases, total_deaths, round((total_deaths/total_cases)*100,2) AS death_percentage
FROM PortfolioProject..CovidDeaths
WHERE location like '%Philippines%'
AND continent IS NOT NULL
ORDER BY 1,2

--FILTERED USING WHERE CLAUSE "iso_code NOT like 'OWID%'" TO REMOVE UNNECESSARY RECORDS FROM THE DATASET.
--OUR WORLD IN DATA(OWID RECORDS WITH EITHER NO SPECIFIC COUNTRY NAME/LOCATION OR CONTINENT OR with iso_code starts with OWID)

--Total cases vs population
--Shows what percentage of population is infected with covid

 

--HIGHEST AND LOWEST INFECTION RATES

--Countries with highest infection rate against population
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

--Showing countries with highest death count per population
SELECT location,  population, MAX(CAST(total_deaths as int)) AS 'Highest Death Count',
ROUND(MAX((total_deaths/population)*100),2) AS 'Death Percentage'
FROM PortfolioProject..CovidDeaths
WHERE population IS NOT NULL
AND iso_code NOT like 'OWID%'
GROUP BY location,population
ORDER BY 3 DESC

--Showing countries with lowest death count per population
SELECT location,  population, MAX(CAST(total_deaths as int)) AS 'Death Count',
ROUND(MAX((total_deaths/population)*100),2) AS 'Death Percentage'
FROM PortfolioProject..CovidDeaths
WHERE population IS NOT NULL
AND iso_code NOT like 'OWID%'
GROUP BY location,population
ORDER BY 3,2 DESC

--HIGHEST AND LOWEST DEATH PERCENTAGES

--Showing countries with highest death percentage per population
SELECT location,  population, MAX(CAST(total_deaths as int)) AS 'Death Count',
ROUND(MAX((total_deaths/population)*100),2) AS 'Highest Death Percentage'
FROM PortfolioProject..CovidDeaths
WHERE population IS NOT NULL
AND iso_code NOT like 'OWID%'
GROUP BY location,population
ORDER BY 4 DESC,3 DESC

--Showing countries with lowest death percentage per population
SELECT location,  population, MAX(CAST(total_deaths as int)) AS 'Death Count',
ROUND(MAX((total_deaths/population)*100),2) AS 'Lowest Death Percentage'
FROM PortfolioProject..CovidDeaths
WHERE population IS NOT NULL
AND iso_code NOT like 'OWID%'
GROUP BY location,population
ORDER BY 4 ASC,3 DESC, 2 DESC



--DATA EXPLORATION BY CONTINENT

--TOTAL DEATH COUNT BY CONTINENT

--Incorrect queries
--These 2 queries below only shows the countries in each continent with the MAX(total_deaths) 
--E.g. North America shows United States total death count
SELECT distinct(continent),  MAX(CAST(total_deaths as int)) AS 'Total Death Count'
--ROUND(MAX((total_deaths/population)*100),2) AS 'Lowest Death Percentage'
FROM PortfolioProject..CovidDeaths
--WHERE continent IS NOT NULL
WHERE iso_code NOT like 'OWID%'
GROUP BY continent
ORDER BY [Total Death Count] DESC;

select location, MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
where continent is null
group by location
order by TotalDeathCount desc


--SKILL: USING SUBQUERIES
 --CORRECT QUERY USING SUM OF MAX(HIGHEST TOTAL DEATHS BY CONTINENT)
 select continent, sum(maxtotals) as totalDeathsPerContinent from
(
select continent, location, MAX(CAST(total_deaths as int)) AS maxtotals
FROM PortfolioProject..CovidDeaths
WHERE iso_code NOT like 'OWID%'
group by continent, location
) a
group by continent
order by totalDeathsPerContinent DESC

--test
 select location, maxtotals from
(
select location, MAX(CAST(total_deaths as int)) AS maxtotals
FROM PortfolioProject..CovidDeaths
WHERE iso_code NOT like 'OWID%'
AND continent='Asia'
group by location
) a
order by maxtotals desc


--GLOBAL NUMBERS
--total cases, total deaths and death percentage(deaths/cases) per date
SELECT date,  sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,  round((sum(cast(new_deaths as int))/sum(new_cases))*100,2) AS 'Death Percentage'
FROM PortfolioProject..CovidDeaths
WHERE population IS NOT NULL
AND iso_code NOT like 'OWID%'
group by date
ORDER BY 1,2

--total cases as of november 22, 2022
select sum(new_cases) as overall_cases, sum(cast(new_deaths as int)) as overall_deaths, round((sum(cast(new_deaths as int))/sum(new_cases))*100,2) AS 'Death Percentage'
from PortfolioProject..CovidDeaths
WHERE population IS NOT NULL
AND iso_code NOT like 'OWID%'

--death percentage deaths/population
select sum(population) as total_population, sum(new_cases) as overall_cases, sum(cast(new_deaths as int)) as overall_deaths, round((sum(cast(new_deaths as int))/sum(population)),5) AS 'Death Percentage'
from PortfolioProject..CovidDeaths
WHERE population IS NOT NULL
AND iso_code NOT like 'OWID%'




--VACCINATIONS



--total population vs vaccinations

SELECT * from PortfolioProject..CovidVaccinations

--SKILL: USING OVER PARTITION

--SHOWS ERROR: ORDER BY list of RANGE window frame has total size of 1020 bytes. Largest size supported is 900 bytes.
--ADDED: ROWS UNBOUNDED PRECEEDING
--FROM STACKOVERFLOW.COM ROWS UNBOUNDED PRECEDING
--Together with the ORDER BY it defines the window on which the result is calculated.

--Running total of vaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date ROWS UNBOUNDED PRECEDING) AS vaccinated_running_total
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
WHERE dea.population IS NOT NULL
AND dea.iso_code NOT like 'OWID%'
order by 2,3

--SKILL: USING CTE

--people vaccination versus population percentage

--with must have same columns with subquery

--ERROR: The ORDER BY clause is invalid in views, inline functions, derived tables, subqueries, and common table expressions, unless TOP, OFFSET or FOR XML is also specified.
--SOLUTION: REMOVED ORDER BY 2,3 IN THE INNER QUERY SINCE IT IS ALREADY USED IN THE PARTITION CLAUSE

With PopuVsVac (continent, location, date, population, new_vaccinations, vaccinated_running_total)
as 
(

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date ROWS UNBOUNDED PRECEDING) AS vaccinated_running_total
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
WHERE dea.population IS NOT NULL
AND dea.iso_code NOT like 'OWID%'
--AND dea.location like '%Philippines%'
)
Select *, round((vaccinated_running_total/population)*100,2) as vaccination_percentage from PopuVsVac



--SKILL: CREATING TEMP TABLES
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
vaccinated_running_total numeric
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date ROWS UNBOUNDED PRECEDING) AS vaccinated_running_total
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
WHERE dea.population IS NOT NULL
AND dea.iso_code NOT like 'OWID%'
--AND dea.location like '%Philippines%'

Select *, round((vaccinated_running_total/population)*100,2) as vaccination_percentage 
from #PercentPopulationVaccinated


--SKILL: Creating views for data visualizations

Create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date ROWS UNBOUNDED PRECEDING) AS vaccinated_running_total
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
WHERE dea.population IS NOT NULL
AND dea.iso_code NOT like 'OWID%'

select * from PercentPopulationVaccinated


