
DROP TABLE IF EXISTS countries;
DROP TABLE IF EXISTS keywords;

CREATE TABLE IF NOT EXISTS countries (

    id SERIAL PRIMARY KEY,
    title TEXT,
    country_name TEXT,
    capital VARCHAR(100),
    population INT,
    isocode VARCHAR(3)
);

CREATE TABLE IF NOT EXISTS keywords (
    id SERIAL PRIMARY KEY,
    country_id INT NOT NULL,
    keyword TEXT
);


DELETE FROM countries;
DELETE FROM keywords;

\copy countries FROM '/home/kristian/Desktop/scikit-cilantro-encounter-notes/week_05/country_scraper/countries.csv' DELIMITER ',' CSV HEADER;
\copy keywords FROM '/home/kristian/Desktop/scikit-cilantro-encounter-notes/week_05/country_scraper/keywords.csv' DELIMITER ',' CSV HEADER;

