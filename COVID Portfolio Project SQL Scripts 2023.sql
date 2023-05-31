
Select *
From PortfolioProject.dbo.CovidDeaths
Where continent is not null
order by 3,4



---- Looking at Total Cases vs Total Deaths in USA

Select Location, date, total_cases, total_deaths
From PortfolioProject.dbo.CovidDeaths
Where location like '%states%'
Where continent is not null
order by 1,2

---- Looking at Total Cases vs Population in USA or what percentage of population contracted COVID
Select Location, date, total_cases, population, (total_cases/population)*100 as CovidInfectionrate
From PortfolioProject.dbo.CovidDeaths
Where location like '%states%'
Where continent is not null
order by 1,2

---- Looking at Countries with highets infection rate compared to population
Select Location, population, MAX(cast(total_cases as int)) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject.dbo.CovidDeaths
--- Where location like '%states%'
Where continent is not null
Group by Location, Population
order by PercentPopulationInfected desc

-- Showing Countries with Highest Death Count per Population
Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject.dbo.CovidDeaths
--- Where location like '%states%'
Where continent is not null
Group by Location
order by TotalDeathCount desc

-- Continents with highest death count per population
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject.dbo.CovidDeaths
--- Where location like '%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc


-- Global Covid Numbers
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths
From PortfolioProject.dbo.CovidDeaths
Where continent is not null
--Group by date
order by 1,2

-- Total population vs vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingVaccinationCount
From PortfolioProject.dbo.CovidDeaths dea
Join PortfolioProject.dbo.CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order by 2,3


-- Using CTE

With PopulationVsVaccination (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingVaccinationCount
From PortfolioProject.dbo.CovidDeaths dea
Join PortfolioProject.dbo.CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 as percentvaccinated
From PopulationVsVaccination

-- Creating View to store data for visualizations

Create View ContinentDeathCounts as
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject.dbo.CovidDeaths
--- Where location like '%states%'
Where continent is not null
Group by continent
--order by TotalDeathCount desc\

Select *
From ContinentDeathCounts