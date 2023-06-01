SELECT *
FROM PortfolioProject.dbo.CovidVaccinations
WHERE continent is not Null
ORDER BY 3,4
--- Select the needed data
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.dbo.CovidDeaths

ORDER BY 1,2

---Evaluating total cases VS Total Deaths
---Mortality Percentage for COVID-19 in a given country

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases*100) as Death_Percentage
FROM PortfolioProject.dbo.CovidDeaths
---Mortality Percentage for United States
WHERE Location like '%states%'
and continent is not Null
ORDER BY 1,2


---Evaluating total cases vs Population
---Evaluating the percentage of infected Population
SELECT Location, date, Population, total_cases, (total_cases/population*100) as Infected_Population_Percentage
FROM PortfolioProject.dbo.CovidDeaths

--- YOu can highlight a particular state by using the WHERE statemet: WHERE Location like '%states%'
WHERE continent is not Null
ORDER BY 1,2

---To investigate the country with the highest infection percentage compared to its population

SELECT Location, Population, MAX(total_cases) as Highest_Infection_Count, MAX((total_cases/population*100)) as Max_Infected_Population_Percentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not Null
--- YOu can highlight a particular state by using the WHERE statemet: WHERE Location like '%states%'
Group By Location, Population
ORDER BY Max_Infected_Population_Percentage Desc

---Investigating countries with the Hihest Death Percentage
SELECT Location, MAX(CAST (total_Deaths as int)) as Total_Death_Count
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not Null
--- YOu can highlight a particular state by using the WHERE statemet: WHERE Location like '%states%'
Group By Location
ORDER BY Total_Death_Count Desc

--ANALYZING CONTINENT  WITH THE HIGHEST DEATH COUNT

--Correct querry for actual figures of continents
-----SELECT Location, MAX(CAST (total_Deaths as int)) as Total_Death_Count
--FROM PortfolioProject.dbo.CovidDeaths
--WHERE continent is Null
----- YOu can highlight a particular state by using the WHERE statemet: WHERE Location like '%states%'
--Group By Location
--ORDER BY Total_Death_Count Desc
-------
SELECT continent, MAX(CAST (total_Deaths as int)) as Total_Death_Count
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not Null
--- YOu can highlight a particular state by using the WHERE statemet: WHERE Location like '%states%'
Group By continent
ORDER BY Total_Death_Count Desc

-----
---INVESTIGATING GLOBAL FIGURES
SELECT  Date, 
		SUM(new_cases) AS Total_Cases, 
		SUM(CAST(new_deaths as int) ) AS Total_Deaths, 
		SUM(CAST(new_deaths AS int))/(Sum(new_Cases)) * 100 AS Death_Percentage

FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not Null
--- YOu can highlight a particular state by using the WHERE statemet: WHERE Location like '%states%'
Group By date
ORDER BY 1,2

--- IF WE ARE CONCERNED ABOUT TOTAL CASES ACCROSS THE WORLD WITHOUT BINDING TO DATE, WE SIMPLY REMOVE THE DATE COLUMN AND NOT GROUP BY DATE

SELECT   
		SUM(new_cases) AS Total_Cases, 
		SUM(CAST(new_deaths as int) ) AS Total_Deaths, 
		SUM(CAST(new_deaths AS int))/(Sum(new_Cases)) * 100 AS Death_Percentage

FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not Null
--- YOu can highlight a particular state by using the WHERE statemet: WHERE Location like '%states%'
--Group By date
ORDER BY 1,2
-----------------------------------
---NOW CHECKING THE VACCINATION TABLE
SELECT *
FROM PortfolioProject.dbo.CovidVaccinations
---Joining the CovidDeaths table with CovidVaccination Table using Location and Date as keys

-----
SELECT *
FROM PortfolioProject..CovidDeaths AS death_t
JOIN PortfolioProject.dbo.CovidVaccinations AS vacc_t
on death_t.location = vacc_t.location
and death_t.date = vacc_t.date


---Evaluating Total Population vs Total Vaccinated Population
SELECT  death_t.Continent,
		death_t.Location,
		death_t.Date,
		death_t.Population,
		vacc_t.New_Vaccinations,
		---WE CREATED A COLUMN THAT SHOWS THE CUMMULATIVE SUM OF VACCINATIONS PARTITIONED LOCATION; ORDERED BY LOCATION AND DATE
		SUM(CAST(vacc_t.New_vaccinations AS INT)) OVER (PARTITION BY vacc_t.Location ORDER BY vacc_t.Location, vacc_t.date) AS Cummulative_Vaccinations

FROM PortfolioProject..CovidDeaths AS death_t
JOIN PortfolioProject.dbo.CovidVaccinations AS vacc_t
on death_t.location = vacc_t.location
and death_t.date = vacc_t.date
WHERE death_t.continent is not NULL
ORDER BY 2,3
------
---CREATE A CTE SO AS TO BE ABLE TO CARRYOUT MANIPULATIONS ON A NEWLY CREATED COLUMN THAT IS NOT YET ON AN EXISTING TABLE
---First select all the existing columns using the "WITH" statement
WITH Pop_vs_Vacc (Continent, Location, Date, Population, New_vaccinations, Cummulative_Vaccinations)
as
(SELECT  death_t.Continent,
		death_t.Location,
		death_t.Date,
		death_t.Population,
		vacc_t.New_Vaccinations,
		---WE CREATED A COLUMN THAT SHOWS THE CUMMULATIVE SUM OF VACCINATIONS PARTITIONED LOCATION; ORDERED BY LOCATION AND DATE
		SUM(CAST(vacc_t.New_vaccinations AS INT)) OVER (PARTITION BY vacc_t.Location ORDER BY vacc_t.Location, vacc_t.date) AS Cummulative_Vaccinations

FROM PortfolioProject..CovidDeaths AS death_t
JOIN PortfolioProject.dbo.CovidVaccinations AS vacc_t
on death_t.location = vacc_t.location
and death_t.date = vacc_t.date
WHERE death_t.continent is not NULL

)
SELECT *, Cummulative_Vaccinations/Population * 100 AS Cummulative_Vaccination_Percentage
FROM Pop_vs_Vacc




------------------------------------------
----TEMP TABLE
-----------------------------------------

----------------------------------------------
---TEMP TABLE
----------------------------------------------

DROP Table if exists #Percent_Population_Vaccinated
CREATE Table #Percent_Population_Vaccinated

(Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 Population numeric,
 New_vaccinations numeric,
 Cummulative_Vaccinations numeric
 )
 INSERT into #Percent_Population_Vaccinated
 SELECT  death_t.Continent,
		death_t.Location,
		death_t.Date,
		death_t.Population,
		vacc_t.New_Vaccinations,
		---WE CREATED A COLUMN THAT SHOWS THE CUMMULATIVE SUM OF VACCINATIONS PARTITIONED LOCATION; ORDERED BY LOCATION AND DATE
		SUM(CAST(vacc_t.New_vaccinations AS INT)) OVER (PARTITION BY vacc_t.Location ORDER BY vacc_t.Location, vacc_t.date) AS Cummulative_Vaccinations

FROM PortfolioProject..CovidDeaths AS death_t
JOIN PortfolioProject.dbo.CovidVaccinations AS vacc_t
on death_t.location = vacc_t.location
and death_t.date = vacc_t.date
WHERE death_t.continent is not NULL

SELECT *, Cummulative_Vaccinations/Population * 100 AS Cummulative_Vaccination_Percentage
FROM #Percent_Population_Vaccinated

------------------------------------------------------
--CREATING VIEWS TO STORE DATA FOR DATA VISUALIZATIONS
------------------------------------------------------

CREATE VIEW Percent_Population_Vaccinated_1 AS 
 SELECT  death_t.Continent,
		death_t.Location,
		death_t.Date,
		death_t.Population,
		vacc_t.New_Vaccinations,
		---WE CREATED A COLUMN THAT SHOWS THE CUMMULATIVE SUM OF VACCINATIONS PARTITIONED LOCATION; ORDERED BY LOCATION AND DATE
		SUM(CAST(vacc_t.New_vaccinations AS INT)) OVER (PARTITION BY vacc_t.Location ORDER BY vacc_t.Location, vacc_t.date) AS Cummulative_Vaccinations

FROM PortfolioProject..CovidDeaths AS death_t
JOIN PortfolioProject.dbo.CovidVaccinations AS vacc_t
on death_t.location = vacc_t.location
and death_t.date = vacc_t.date
WHERE death_t.continent is not NULL
-----------------------
--CREATE POPULATION VIEW
-------------------------

CREATE VIEW Percentage_population_Vaccinated_real AS
WITH Pop_vs_Vacc (Continent, Location, Date, Population, New_vaccinations, Cummulative_Vaccinations)
as
(SELECT  death_t.Continent,
		death_t.Location,
		death_t.Date,
		death_t.Population,
		vacc_t.New_Vaccinations,
		---WE CREATED A COLUMN THAT SHOWS THE CUMMULATIVE SUM OF VACCINATIONS PARTITIONED LOCATION; ORDERED BY LOCATION AND DATE
		SUM(CAST(vacc_t.New_vaccinations AS INT)) OVER (PARTITION BY vacc_t.Location ORDER BY vacc_t.Location, vacc_t.date) AS Cummulative_Vaccinations

FROM PortfolioProject..CovidDeaths AS death_t
JOIN PortfolioProject.dbo.CovidVaccinations AS vacc_t
on death_t.location = vacc_t.location
and death_t.date = vacc_t.date
WHERE death_t.continent is not NULL

)
SELECT *, Cummulative_Vaccinations/Population * 100 AS Cummulative_Vaccination_Percentage
FROM Pop_vs_Vacc

SELECT *
FROM Percentage_population_Vaccinated_real