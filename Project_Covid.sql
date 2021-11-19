select *
from Project_Covid..Covid_Death
where continent is not null
order by 3,4

--select *
--from Project_Covid..Covid_Vaccination
--where continent is not null
--order by 3,4

Select 
	Location, 
	date, 
	total_cases, 
	new_cases, 
	total_deaths, 
	population 
from Project_Covid..Covid_Death
where continent is not null
order by 1, 2

--Total Cases vs Total Deaths
Select 
	Location, 
	date, 
	total_cases, 
	total_deaths,
	(total_deaths/total_cases)*100 as death_percentage
from Project_Covid..Covid_Death
where continent is not null
order by 1, 2

--The likelihood of dying if you contract Covid in any countries
Select 
	Location, 
	date, 
	total_cases, 
	total_deaths,
	(total_deaths/total_cases)*100 as death_percentage
from Project_Covid..Covid_Death
where location like 'Vietnam'
order by 1, 2

--Total cases vs population
Select 
	location,
	date,
	population,
	total_cases, 
	(total_cases/population)*100 as population_got_covid
from Project_Covid..Covid_Death
where continent is not null
--where location like 'Vietnam'
order by 1, 2

--Countries with highest infection rate compared to population
Select 
	location,
	population,
	max(total_cases) as highest_infection,
	max((total_cases/population)*100) as highest_infection_rate
from Project_Covid..Covid_Death
where continent is not null
group by
	location,
	population
order by highest_infection_rate desc

--Countries with highest deaths count per population
Select 
	location,
	max(cast(total_deaths as int)) as highest_death
from Project_Covid..Covid_Death
where continent is not null
group by location
order by highest_death desc

--Continent with highest deaths count per population
Select 
	continent,
	max(cast(total_deaths as int)) as Total_death_count
from Project_Covid..Covid_Death
where continent is not null
group by continent
order by Total_death_count desc

--Global numbers
Select 
	sum(new_cases) as Total_cases,
	sum(cast(new_deaths as int)) as Total_Death,
	sum(cast(new_deaths as int))/sum(new_cases)*100 as Death_Percentage
from Project_Covid..Covid_Death
where continent is not null
--group by date 
order by 1, 2

--Join table
Select *
From Project_Covid..Covid_Death dea
Join Project_Covid..Covid_Vaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

--Total Population vs Vaccinations
Select 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	vac.new_vaccinations, 
	SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location)
From Project_Covid..Covid_Death dea
Join Project_Covid..Covid_Vaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3