-- Clue #1: We recently got word that someone fitting Carmen Sandiego's description has been traveling through Southern Europe. She's most likely traveling someplace where she won't be noticed, so find the least populated country in Southern Europe, and we'll start looking for her there.
-- Write SQL query here

-- modified to grab country code for clue 2
SELECT code, name, population
FROM countries
WHERE region = 'Southern Europe'
ORDER BY population ASC
LIMIT 1;

-- Answer: Vatican City with population of 1000?
-- code: VAT

------------------------------------------------------------------------------

-- Clue #2: Now that we're here, we have insight that Carmen was seen attending language classes in this country's officially recognized language. Check our databases and find out what language is spoken in this country, so we can call in a translator to work with you.
-- Write SQL query here
SELECT language
FROM countrylanguages
WHERE countrycode = 'VAT'
AND isofficial = TRUE;

-- Answer: Italian. Even though we already knew that

------------------------------------------------------------------------------

-- Clue #3: We have new news on the classes Carmen attended – our gumshoes tell us she's moved on to a different country, a country where people speak only the language she was learning. Find out which nearby country speaks nothing but that language.
-- Write SQL query here

-- SELECT countrycode 
-- FROM countrylanguages
-- WHERE language = 'Italian'
-- AND isofficial = TRUE
-- groups by country
-- GROUP BY countrycode
-- ensures that country only has one language listed
-- HAVING COUNT(*) = 1;

-- Answer: Country codes:  CHE, ITA, SMR, VAT

-- NEW QUERY:
-- updated to include code for next clue
SELECT name, code 
FROM countries 
-- filters the countries
-- only returns those whose code is in the below list
WHERE code IN (
    -- inner query (subquery)
    -- retrieves countrycode from countrylanguages table
    SELECT countrycode 
    FROM countrylanguages 
    WHERE language = 'Italian' 
    AND isofficial = TRUE
    -- groups the data by countrycode
    GROUP BY countrycode 
    -- only return countries with exactly 1 language
    HAVING COUNT(*) = 1
);

-- Answer: Switzerland CHE, Italy ITA, San Marino SMR, Holy See VAT

------------------------------------------------------------------------------

-- Clue #4: We're booking the first flight out – maybe we've actually got a chance to catch her this time. There are only two cities she could be flying to in the country. One is named the same as the country – that would be too obvious. We're following our gut on this one; find out what other city in that country she might be flying to.
-- Write SQL query here

-- so... find a city in a country where italian is the only official language
-- exclude city with the same name as the country...

-- dot notation specifies which table the column belongs to 
-- (good for when multiple tables are involved in a query)
-- find city name
SELECT cities.name
-- join these two tables bc their data is related
-- still need to specify how they're connected
FROM cities
-- shows relationship
-- combine rows from both tables where the countrycode (cities table) matches the code (countries table)
JOIN countries ON cities.countrycode = countries.code
-- filters for where italian is the only official language
WHERE countries.code = 'SMR'
AND cities.name <> countries.name;

-- Answer: Serravalle

------------------------------------------------------------------------------

-- Clue #5: Oh no, she pulled a switch – there are two cities with very similar names, but in totally different parts of the globe! She's headed to South America as we speak; go find a city whose name is like the one we were headed to, but doesn't end the same. Find out the city, and do another search for what country it's in. Hurry!
-- Write SQL query here

-- show both city and country
SELECT cities.name
-- look for a city...
FROM cities
-- join the two tables where they're related
JOIN countries ON cities.countrycode = countries.code
-- look for cities that start with Serra, plus the wildcard
WHERE countries.continent = 'South America'
AND cities.name LIKE 'Serra%'
AND cities.name <> 'Serravalle';

-- Answer: Serra

SELECT countries.name
FROM countries
JOIN cities ON cities.countrycode = countries.code
WHERE cities.name = 'Serra';

-- Answer: Brazil!

------------------------------------------------------------------------------

-- Clue #6: We're close! Our South American agent says she just got a taxi at the airport, and is headed towards
-- the capital! Look up the country's capital, and get there pronto! Send us the name of where you're headed and we'll
-- follow right behind you!
-- Write SQL query here

SELECT cities.name
FROM cities
WHERE cities.id = (
    SELECT countries.capital
    FROM countries
    WHERE countries.name = 'Brazil'
);

-- Answer: Brasilia

------------------------------------------------------------------------------

-- Clue #7: She knows we're on to her – her taxi dropped her off at the international airport, and she beat us to the boarding gates. We have one chance to catch her, we just have to know where she's heading and beat her to the landing dock. Lucky for us, she's getting cocky. She left us a note (below), and I'm sure she thinks she's very clever, but if we can crack it, we can finally put her where she belongs – behind bars.


--               Our playdate of late has been unusually fun –
--               As an agent, I'll say, you've been a joy to outrun.
--               And while the food here is great, and the people – so nice!
--               I need a little more sunshine with my slice of life.
--               So I'm off to add one to the population I find
--               In a city of ninety-one thousand and now, eighty five.


-- We're counting on you, gumshoe. Find out where she's headed, send us the info, and we'll be sure to meet her at the gates with bells on.

SELECT * 
FROM cities 
WHERE population = (91084);

-- Answer: Santa Monica CA!!