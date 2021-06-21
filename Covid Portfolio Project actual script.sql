SELECT * FROM [Portfolio Projects]..CovidDeaths
Where continent is not null
order by 3,4

--SELECT * FROM [Portfolio Projects]..CovidVaccinations
--order by 3,4

--SELECT DATA that we are going to be using 

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM [Portfolio Projects]..CovidDeaths
Where continent is not null
order by 1,2

-- looking at total Cases Vs Total Deaths
-- shows how likely of dying if you get covid in your country
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercent
FROM [Portfolio Projects]..CovidDeaths
WHERE location like '%states%'
AND continent is not null
order by 1,2


-- looking at total cases vs population
-- shows what percentage of population has covid
SELECT location, date, population, total_cases, round((total_cases/population)*100, 2) as deathpercent
FROM [Portfolio Projects]..CovidDeaths
WHERE location like '%states%'
order by 1,2

-- countries with hightest infection rate compared to population
SELECT location, population, MAX(total_cases) as Highinfection, MAX(round((total_cases/population)*100, 2)) as Percentofpopulationinfected
FROM [Portfolio Projects]..CovidDeaths
group by location, population
--having location like '%ana%'
order by Percentofpopulationinfected  desc


-- LET's BREAK THINGS DOWN BY CONTINENT

--showing the continent with highest death count per population
SELECT continent, MAX(cast(total_deaths as int)) as TotaldeathsCount
FROM [Portfolio Projects]..CovidDeaths
Where continent is not null
group by continent
order by TotaldeathsCount  desc


--Global Numbers

SELECT sum(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, round(SUM(cast(new_deaths as int))/sum(new_cases)*100,2) as DeathPercent
FROM [Portfolio Projects]..CovidDeaths
--WHERE location like '%states%'
Where continent is not null
--group by date
order by 1,2

-- Looking at total population Vs Vaccinations

SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations,
SUm(convert(int,v.new_vaccinations)) over(partition by d.location order by d.location,d.date) as rolling_pple_vac
FROM [Portfolio Projects]..CovidDeaths d
join [Portfolio Projects]..CovidVaccinations v
on d.location = v.location
and d.date = v.date
where d.continent is not null
order by 1,2,3

-- USE CTE

with PopvsVac (Continent, location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as(
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations,
SUm(convert(int,v.new_vaccinations)) over(partition by d.location order by d.location,d.date) as RollingPeopleVaccinated
FROM [Portfolio Projects]..CovidDeaths d
join [Portfolio Projects]..CovidVaccinations v
on d.location = v.location
and d.date = v.date
where d.continent is not null
)
select *, (RollingPeopleVaccinated/Population)*100
from PopvsVac

-- TEMP TABLE

DROP TABLE if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population Numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
insert into #PercentPopulationVaccinated
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations,
SUm(convert(int,v.new_vaccinations)) over(partition by d.location order by d.location,d.date) as RollingPeopleVaccinated
FROM [Portfolio Projects]..CovidDeaths d
join [Portfolio Projects]..CovidVaccinations v
on d.location = v.location
and d.date = v.date
where d.continent is not null
--order by 2,3

select *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated

-- Creating View to store data for later Visualizations

create view PercentPopulationVaccinated as
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations,
SUm(convert(int,v.new_vaccinations)) over(partition by d.location order by d.location,d.date) as RollingPeopleVaccinated
FROM [Portfolio Projects]..CovidDeaths d
join [Portfolio Projects]..CovidVaccinations v
on d.location = v.location
and d.date = v.date
where d.continent is not null
--order by 2,3

select * from PercentPopulationVaccinated