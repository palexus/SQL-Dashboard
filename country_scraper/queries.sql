
-- views: save a query for later
CREATE VIEW biggest_countries AS (
  SELECT country_name, population
    FROM countries
    WHERE population > 0
    ORDER BY population DESC
    LIMIT 10
);

-- duplicates data. CAREFUL WITH THIS!!!
CREATE TABLE biggest_countries_copy AS (
  SELECT country_name, population
    FROM countries
    WHERE population > 0
    ORDER BY population DESC
    LIMIT 10
);

-- unique values
SELECT DISTINCT keyword FROM keywords;

-- sort by population
SELECT country_name, population
  FROM countries
  WHERE population > 0
  ORDER BY population DESC
  LIMIT 10;

-- most popular country initials for small countries
SELECT count(country_name), substr(title, 1, 1) firstchar
  FROM countries
  WHERE population <= 1000000
  GROUP BY firstchar
  HAVING count(country_name) >= 3
  ORDER BY count(id) DESC
  LIMIT 10;


-- most popular first characters
SELECT count(country_name), substr(title, 1, 1) firstchar
  FROM countries
  GROUP BY firstchar
  ORDER BY count(id) DESC
  LIMIT 10;

-- first characters
SELECT country_name, substr(country_name, 1, 1) firstchar
  FROM countries
  LIMIT 5;


-- total population
SELECT sum(population), avg(population),
       max(population), min(population)
  FROM countries;

-- use an aggregation function
SELECT count(id)
  FROM countries;

-- count the country names grouped by population
SELECT count(id), (population / 1000000) pop_mil
  FROM countries
  GROUP BY pop_mil
  LIMIT 5;

-- use arithmetics and name the result
SELECT country_name, capital, (population / 1000000) pop_mil
  FROM countries
  LIMIT 5;

-- query with a RegEx
SELECT country_name,capital,population 
  FROM countries
  WHERE country_name ~ '^R.{10,}'
  LIMIT 10;

-- query with a RegEx combined
SELECT country_name,capital,population 
  FROM countries
  WHERE country_name ~ 'Arab' AND population > 10000000;


SELECT country_name,capital,population 
  FROM countries
  WHERE country_name ~ 'Egypt';



SELECT country_name,capital,population 
  FROM countries
  WHERE country_name = 'Tuvalu';


SELECT country_name,capital,population 
  FROM countries
  WHERE population < 100000
  LIMIT 5;


SELECT country_name,capital,population 
  FROM countries
  WHERE id >= 7 AND id < 14
  LIMIT 5;