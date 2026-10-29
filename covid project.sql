/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/
select *
from covid_deaths.covid_death_data
order by 3,4;

-- Select Data that we are going to be starting with
select *
from covid_deaths.covid_vacci
order by 3,4;

-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

select location, date, total_cases, new_cases, total_deaths, population
from covid_deaths.covid_death_data
order by 1,2;


select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
from covid_deaths.covid_death_data
order by 1,2;


select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
from covid_deaths.covid_death_data
where location like '%states%'
and continent is not null
order by 1,2;

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid
select location, date, total_cases, population, (cast(total_cases as decimal(15,4))/population)*100 as INFECTEDpercentage
from covid_deaths.covid_death_data
where location like 'india'
and continent is  null
order by 1,2;

-- Countries with Highest Infection Rate compared to Population
select location, population, max(total_cases) AS HIGHESTINFECTIONCOUNT, max((cast(total_cases as decimal(15,4))/population)*100) as INFECTEDpercentage
from covid_deaths.covid_death_data
WHERE continent is not null
GROUP BY location,population
order by INFECTEDpercentage DESC;

-- Countries with Highest Death Count per Population
select location, max(total_deaths)  AS HIGHESTDEATHS
from covid_deaths.covid_death_data
WHERE continent is not  null 
GROUP BY location
order by HIGHESTDEATHS desc; 

select *
from covid_deaths.covid_death_data
WHERE continent is  null
order by 3,4;

-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

select continent, max(total_deaths)  AS HIGHESTDEATHS
from covid_deaths.covid_death_data
WHERE continent is not  null 
GROUP BY continent
order by HIGHESTDEATHS desc;

-- GLOBAL NUMBERS
select date, Sum(new_cases) as total_cases , sum(new_deaths) as toatal_death, sum(new_deaths)/sum(new_cases)*100 as deathpercentage
from covid_deaths.covid_death_data
where continent is not null
group by date
order by 1,2;

select Sum(new_cases) as total_cases , sum(new_deaths) as toatal_death, sum(new_deaths)/sum(new_cases)*100 as deathpercentage
from covid_deaths.covid_death_data
where continent is not null
order by 1,2;

select *
from covid_deaths.covid_death_data dea
join  covid_deaths.covid_vacci vac
	on dea.location = vac.location
    and dea.date = vac.date;
    
select  dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from covid_deaths.covid_death_data dea
join  covid_deaths.covid_vacci vac
	on dea.location = vac.location
    and dea.date = vac.date
    where dea.continent is not null
	order by 2,3;

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

select  dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (partition by dea.location, dea.date) as rollingpeoplevacci
from covid_deaths.covid_death_data dea
join  covid_deaths.covid_vacci vac
	on dea.location = vac.location
    and dea.date = vac.date
    where dea.continent is not null
	order by 2,3;
    
-- Using CTE to perform Calculation on Partition By in previous query
    
    with  popvsvac (continent, location, date, population, new_vaccinations, rollingpeoplevacci)
    as
    (
    select  dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (partition by dea.location, dea.date) as rollingpeoplevacci
from covid_deaths.covid_death_data dea
join  covid_deaths.covid_vacci vac
	on dea.location = vac.location
    and dea.date = vac.date
    )
    select* , ((rollingpeoplevacci/population)*100) as rpvf
    from popvsvac;
    
 -- Using Temp Table to perform Calculation on Partition By in previous query
DROP TEMPORARY TABLE IF EXISTS percentpopulationvaccinated;

CREATE TEMPORARY TABLE percentpopulationvaccinated (
    continent VARCHAR(255),
    location VARCHAR(255),
    date DATETIME,
    population NUMERIC,
    new_vaccinations NUMERIC,
    rollingpeoplevaccinated NUMERIC
);
    insert into percentpopulationvaccinated
     select  dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (partition by dea.location, dea.date) as rollingpeoplevacci
from covid_deaths.covid_death_data dea
join  covid_deaths.covid_vacci vac
	on dea.location = vac.location
    and dea.date = vac.date
    ;
    

SELECT *, (rollingpeoplevaccinated / population) * 100 AS rpvf 
FROM percentpopulationvaccinated;


-- Creating View to store data for later visualizations
create view percentpopulationvaccinated as
select  dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (partition by dea.location, dea.date) as rollingpeoplevacci
from covid_deaths.covid_death_data dea
join  covid_deaths.covid_vacci vac
	on dea.location = vac.location
    and dea.date = vac.date
    where dea.continent is not null
	; 
    
    select *
    FROM percentpopulationvaccinated
     

    