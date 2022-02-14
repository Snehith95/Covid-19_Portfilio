/*Covid 19 Data Exploration
Cited: From the Alextheanalyst*/
select *
from PortfilioProject..covidDeaths
order by 3,4

--select *
--from PortfilioProject..covidvacinations
--order by 3,4


select location, date, total_cases, new_cases, total_deaths, population
from PortfilioProject..covidDeaths
order by 1,2

--looking at total_cases vs total_deaths
--Shows chances of dying if you got covid in your country

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfilioProject..covidDeaths
where location like '%Germany%'
order by 1,2

--Total cases vs population
--Showing the percentage of people infected by covid

select location, date, Population,total_cases, (total_cases/Population)*100 as percentageofPupulationinfected
from PortfilioProject..covidDeaths
--where location like '%Italy%'
order by 1,2

--Looking at highest infection rate compared to population

select location, Population,Max(total_cases) as highestInfectionCount, Max((total_cases/Population))*100 as percentageofPupulationinfected
from PortfilioProject..covidDeaths
--where location like '%Italy%'
Group by location, Population
order by percentageofPupulationinfected Desc

--countries with highest death count per poulation

select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
from PortfilioProject..covidDeaths
--where location like '%Italy%'
Where continent is not null
Group by location
order by TotalDeathCount Desc

-- Covid deaths according to the continent

select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
from PortfilioProject..covidDeaths
--where location like '%Italy%'
Where continent is not null
Group by continent
order by TotalDeathCount Desc

--Number of deaths around the world according to date

select date, sum(new_cases), sum(cast(new_deaths as int)), sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfilioProject..covidDeaths
--where location like '%Italy%'
Where continent is not null
Group by date
order by 1,2

--total cases and deaths around the world

select sum(new_cases), sum(cast(new_deaths as int)), sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfilioProject..covidDeaths
--where location like '%Italy%'
Where continent is not null
--Group by date
order by 1,2


--joining two tables

select *
from PortfilioProject..covidDeaths dea
join PortfilioProject..covidVacinations vac
on dea.location = vac.location
and dea.date = vac. date

--total population vs vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from PortfilioProject..covidDeaths dea
join PortfilioProject..covidVacinations vac
on dea.location = vac.location
and dea.date = vac. date
where dea.continent is not null
order by 2,3

--adding new vaccinations according to location and date

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from PortfilioProject..covidDeaths dea
join PortfilioProject..covidVacinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

--Totalpopulation vs vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfilioProject..covidDeaths dea
join PortfilioProject..covidVacinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null 
order by 2,3



With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100

from PortfilioProject..covidDeaths dea
join PortfilioProject..covidVacinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


Create View PercentPopulationVaccinated1 as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfilioProject..covidDeaths dea
join PortfilioProject..covidVacinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null 

