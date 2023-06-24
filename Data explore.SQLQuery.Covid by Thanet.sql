--View all Table
Select * 
from CovidDeaths
WHERE continent is not null
order by 3,4

--Select *
--from CovidVaccinations
--Order by 3,4

--Select Data that we are going to be using

Select Location, DATE, total_cases, new_cases, total_deaths, population
From CovidDeaths
Order by 1,2

-- Looking at total cases vs total deaths of Thailand
-- Shows likelyhood of dying if you contract covid

Select Location, DATE, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidDeaths
where location = 'Thailand' and total_cases is not null
Order by 1,2

-- Looking at Total Cases vs Population of Thailand
-- Show what percentage of pipulation got covid

Select Location, DATE, total_cases, Population, (total_cases/Population)*100 as Percentageofpopulation
From CovidDeaths
where location = 'Thailand' and total_cases is not null
Order by 1,2

-- Looking at Country with highest infection rate compared to Population 

Select Location, Population, Max(total_cases) as HighestInfectioncount, MAX((total_cases/Population))*100 as Percentageofpopulation
From CovidDeaths
--where location = 'Thailand' and total_cases is not null
Group by location, population
Order by Percentageofpopulation DESC

--Showing Country with highest death count per population

Select Location, Max(cast(total_deaths as int)) as TotalDeathcount
From CovidDeaths
--where location = 'Thailand' and total_cases is not null
where continent is not null
Group by location
Order by TotalDeathcount DESC


-- Let's break things down by continent
-- Showing the continent with the highest death count per population

Select continent, Max(cast(total_deaths as int)) as TotalDeathcount
From CovidDeaths
--where location = 'Thailand' and total_cases is not null
where continent is not null
Group by continent
Order by TotalDeathcount DESC

--GLOBAL NUMBERS

Select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From CovidDeaths
where continent is not null
--Group by date
Order by 1,2

-- Let's see data in Coviddeaths join CovidVaccinations

Select *
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date

-- Looking at total population vs vaccinations

Select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null and vac.new_vaccinations is not null
order by 4 desc

-- Show cases vaccinated

Select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations, 
sum(CONVERT(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, 
dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null and vac.new_vaccinations is not null
order by 2,3


-- USE CTE

WITH PopvsVAC (Continent, Location, Date, Population,New_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations, 
sum(CONVERT(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, 
dea.date) as RollingPeopleVaccinated --(RollingPeopleVaccinated/population)*100
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null and vac.new_vaccinations is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/Population)*100 as Percentage
from PopvsVac

-- TEMP TABLE
Create table #PercentagePopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentagePopulationVaccinated
Select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations, 
sum(CONVERT(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, 
dea.date) as RollingPeopleVaccinated --(RollingPeopleVaccinated/population)*100
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null and vac.new_vaccinations is not null
--order by 2,3

select *, (RollingPeopleVaccinated/Population)*100 as Percentage
from #PercentagePopulationVaccinated

-- Create View to store data for later visualizations

Create View PercentagePopulationVaccinated as 
Select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations, 
sum(CONVERT(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, 
dea.date) as RollingPeopleVaccinated --(RollingPeopleVaccinated/population)*100
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null and vac.new_vaccinations is not null
--order by 2,3

--**** Script for select TopNRows command from SSMS

Select TOP (1000) [continent], [location],[date], [population], [new_vaccinations], [RollingPeopleVaccinated]
from dbo.PercentagePopulationVaccinated



