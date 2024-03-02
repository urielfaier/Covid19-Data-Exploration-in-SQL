# Covid-19 Data Exploration in SQL

## Overview

This SQL script performs data exploration on Covid-19 related data, focusing on various aspects such as total cases, total deaths, infection rates, death rates, vaccination rates, and more. It utilizes a combination of SQL skills including Joins, Common Table Expressions (CTEs), Temp Tables, Window Functions, Aggregate Functions, and creating Views.

## Queries

1. **Starting Data Selection**
   - Selects data from the "CovidDeaths" table where the continent is not null.

2. **Total Cases vs Total Deaths**
   - Calculates the death-to-cases ratio for Covid-19 in Israel over time.

3. **Total Cases vs Population**
   - Calculates the percentage of the population infected with Covid-19 over time.

4. **Total Death vs Population**
   - Calculates the percentage of the population that died due to Covid-19 in Israel over time.

5. **Countries with Highest Infection Rate compared to Population**
   - Identifies countries with the highest infection rates compared to their population.

6. **Countries with Highest Death Count per Population**
   - Identifies countries with the highest death count per population.

7. **Continental Breakdown of Death Count**
   - Breaks down the total death count by continent.

8. **Global Numbers as a Function of Date**
   - Provides global Covid-19 statistics over time, including total cases, total deaths, and death percentage.

9. **Global Numbers Overall**
   - Provides overall global Covid-19 statistics, including total cases, total deaths, and death percentage.

10. **Total Population vs Vaccinations**
    - Calculates the percentage of the population that has received at least one Covid-19 vaccine dose.

11. **Using Temp Table for Calculations**
    - Utilizes a temporary table to perform calculations on the partitioned data.

12. **Creating View for Data Storage**
    - Creates a view to store data for later visualization.

## Skills Used

- Joins
- Common Table Expressions (CTEs)
- Temp Tables
- Window Functions
- Aggregate Functions
- Creating Views
