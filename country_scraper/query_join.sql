
-- count the keywords for every country
SELECT country_name, count(keywords.id) FROM countries

  INNER JOIN keywords 
    ON keywords.country_id = countries.id

  GROUP BY country_name
  ORDER BY count(keywords.id) DESC

  LIMIT 10;

-- use the view
SELECT DISTINCT keyword FROM country_keywords 
  WHERE country_name ~ 'Egypt'
  LIMIT 10; 

-- all keywords for one country, cleaner
CREATE VIEW country_keywords AS (

SELECT c.id country_id, k.id keyword_id, country_name, keyword FROM countries c

  INNER JOIN keywords k
    ON k.country_id = c.id
);


-- all keywords for one country
SELECT country_name, keyword FROM countries

  INNER JOIN keywords 
    ON keywords.country_id = countries.id

  WHERE country_name ~ 'Finland'

  LIMIT 20;
