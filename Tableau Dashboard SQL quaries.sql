
-- Looking at Countries with Highest Infection Rate compared to the Population
-- VISUAL
Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Round(Max((total_cases/population))*100,2) as PercentPopulationInfected
From [Portfolio Projects]..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

-- VISUAL
Select Location, Population, date, MAX(total_cases) as HighestInfectionCount,  Round(Max((total_cases/population))*100,2) as PercentPopulationInfected
From [Portfolio Projects]..CovidDeaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc


-- Looking at Countries with Highest Death Count per Population
-- VISUAL
Select Location, sum(cast(Total_deaths as int)) as TotalDeathCount
From [Portfolio Projects]..CovidDeaths
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by Location
order by TotalDeathCount desc







