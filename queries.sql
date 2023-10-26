/*Queries that provide answers to the questions from all projects.*/

-- Find all animals whose name ends in "mon"
SELECT * FROM animals
WHERE name LIKE '%mon';

-- List the name of all animals born between 2016 and 2019
SELECT name FROM animals
WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';

-- List the name of all animals that are neutered and have less than 3 escape attempts
SELECT name FROM animals
WHERE neutered = true AND escape_attempts < 3;

-- List the date of birth of all animals named either "Agumon" or "Pikachu"
SELECT date_of_birth FROM animals
WHERE name IN ('Agumon', 'Pikachu');

-- List name and escape attempts of animals that weigh more than 10.5kg
SELECT name, escape_attempts FROM animals
WHERE weight_kg > 10.5;

-- Find all animals that are neutered
SELECT * FROM animals
WHERE neutered = true;

-- Find all animals not named Gabumon
SELECT * FROM animals
WHERE name != 'Gabumon';

-- Find all animals with a weight between 10.4kg and 17.3kg (including the animals with weights equal to 10.4kg or 17.3kg)
SELECT * FROM animals
WHERE weight_kg BETWEEN 10.4 AND 17.3;

-----------------------------------------------

/*
  * The following code starts a transaction, updates the "species" column to "unspecified," verifies the change within the transaction, and then rolls back the transaction. Finally, it verifies that the "species" column has returned to its original state. 
*/
-- Start a transaction
BEGIN;

-- Update the "species" column to "unspecified"
UPDATE animals SET species = 'unspecified';

-- Verify that the change was made (Check the "species" column)
SELECT * FROM animals;

-- Roll back the transaction
ROLLBACK;

-- Verify that the "species" column returns to its original state
SELECT * FROM animals;

-----------------------------------------------

/*
  * This code begins a transaction, updates the "species" column
    1. to "digimon" for all animals that have a name ending in "mon"
    2. to "pokemon" for all animals that don't have a species already set.

  * This code verifies changes within the transaction, commits the changes, and verifies that the changes persist after the commit.
*/
-- Start a transaction
BEGIN;

-- Update "species" to "digimon" for animals with names ending in "mon"
UPDATE animals SET species = 'digimon'
WHERE name LIKE '%mon';

-- Update "species" to "pokemon" for animals without a species set
UPDATE animals SET species = 'pokemon'
WHERE species IS NULL;

-- Verify changes within the transaction
SELECT * FROM animals;

-- Commit the transaction
COMMIT;

-- Verify that changes persist after the commit
SELECT * FROM animals;

-----------------------------------------------

/*
  * This code begins a transaction,
  * deletes all records in the "animals" table,
  * rolls back the transaction,
  * verifies if all records in the "animals" table still exist.
*/

-- Start a transaction
BEGIN;

-- Delete all records in the "animals" table
DELETE FROM animals;

-- Roll back the transaction
ROLLBACK;

-- Verify if all records in the "animals" table still exist
SELECT * FROM animals;

-----------------------------------------------

/*
  * The following code begins a transaction,
  * deletes all records of animals born after Jan 1st, 2022.
  * creates a savepoint for the transaction,
  * updates all animals' weight to be their weight multiplied by -1,
  * rolls back to the savepoint,
  * updates all animals' weights that are negative to be their weight multiplied by -1,
  * commits the transaction.
*/
BEGIN;
DELETE FROM animals
WHERE date_of_birth > '2022-01-01';
SAVEPOINT my_savepoint;
UPDATE animals SET weight_kg = weight_kg * -1;
ROLLBACK TO my_savepoint;
UPDATE animals SET weight_kg = weight_kg * -1
WHERE weight_kg < 0;
COMMIT;

-----------------------------------------------

-- Find number of animals in the table
SELECT COUNT(*) AS total_animals FROM animals;

-- Find number of animals that have never tried to escape
SELECT COUNT(*) AS never_tried_to_escape FROM animals
WHERE escape_attempts = 0;

-- Find the average weight of animals
SELECT AVG(weight_kg) AS average_weight FROM animals;

-- Animal who escapes the most, neutered or not neutered animals
SELECT neutered, MAX(escape_attempts) AS max_escape_attempts
FROM animals
GROUP BY neutered;

-- Find the minimum and maximum weight of each type of animal
SELECT species, MIN(weight_kg) AS min_weight, MAX(weight_kg) AS max_weight
FROM animals
GROUP BY species;

-- Find the average number of escape attempts per animal type of those born between 1990 and 2000
SELECT species, AVG(escape_attempts) AS average_escape_attempts
FROM animals
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
GROUP BY species;

-----------------------------------------------

-- Find which animals belong to Melody Pond
SELECT a.name
FROM animals AS a
JOIN owners AS o ON a.owner_id = o.id
WHERE o.full_name = 'Melody Pond';

-- List of all animals that are Pokemon (their type is Pokemon)
SELECT a.name
FROM animals AS a
JOIN species AS s ON a.species_id = s.id
WHERE s.name = 'Pokemon';

-- List all owners and their animals, including those who don't own any animals
SELECT o.full_name, a.name
FROM owners AS o
LEFT JOIN animals AS a ON o.id = a.owner_id;

-- Number of animals per species
SELECT s.name AS species_name, COUNT(a.id) AS animal_count
FROM species AS s
LEFT JOIN animals AS a ON s.id = a.species_id
GROUP BY s.name;

-- List all Digimon owned by Jennifer Orwell
SELECT a.name
FROM animals AS a
JOIN species AS s ON a.species_id = s.id
JOIN owners AS o ON a.owner_id = o.id
WHERE o.full_name = 'Jennifer Orwell' AND s.name = 'Digimon';

-- List all animals owned by Dean Winchester that haven't tried to escape
SELECT a.name
FROM animals AS a
JOIN owners AS o ON a.owner_id = o.id
WHERE o.full_name = 'Dean Winchester' AND a.escape_attempts = 0;

-- Person who owns the most animals
SELECT o.full_name, COUNT(a.id) AS animal_count
FROM owners AS o
LEFT JOIN animals AS a ON o.id = a.owner_id
GROUP BY o.full_name
ORDER BY animal_count DESC
LIMIT 1;

-- Who was the last animal seen by William Tatcher?
SELECT a.name FROM visits AS v
JOIN vets AS vet ON v.vet_id = vet.id
JOIN animals AS a ON v.animal_id = a.id
WHERE vet.name = 'William Tatcher'
ORDER BY v.visit_date DESC
LIMIT 1;

-- How many different animals did Stephanie Mendez see?
SELECT COUNT(DISTINCT a.name) FROM visits AS v
JOIN vets AS vet ON v.vet_id = vet.id
JOIN animals AS a ON v.animal_id = a.id
WHERE vet.name = 'Stephanie Mendez';

-- List all vets and their specialties, including vets with no specialties.
SELECT v.name, s.name AS specialty FROM vets AS v
LEFT JOIN specializations AS sp ON v.id = sp.vet_id
LEFT JOIN species AS s ON sp.species_id = s.id;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT a.name FROM visits AS v
JOIN vets AS vet ON v.vet_id = vet.id
JOIN animals AS a ON v.animal_id = a.id
WHERE vet.name = 'Stephanie Mendez'
AND v.visit_date BETWEEN '2020-04-01' AND '2020-08-30';

-- What animal has the most visits to vets?
SELECT a.name, COUNT(v.id) AS visit_count FROM visits AS v
JOIN animals AS a ON v.animal_id = a.id
GROUP BY a.name
ORDER BY visit_count DESC
LIMIT 1;

-- Who was Maisy Smith's first visit?
SELECT a.name FROM visits AS v
JOIN vets AS vet ON v.vet_id = vet.id
JOIN animals AS a ON v.animal_id = a.id
WHERE vet.name = 'Maisy Smith'
ORDER BY v.visit_date
LIMIT 1;

-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT a.name AS animal_name, a.date_of_birth AS animal_birthday, a.weight_kg AS animal_weight_kg, a.neutered AS animal_neutered, a.escape_attempts AS animal_escape_attempts, vet.name AS vet_name, vet.age AS vet_age,  vet.date_of_graduation AS vet_date_of_graduation, v.visit_date AS animal_visit_date
FROM visits AS v
JOIN vets AS vet ON v.vet_id = vet.id
JOIN animals AS a ON v.animal_id = a.id
ORDER BY v.visit_date DESC
LIMIT 1;

-- How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(*) AS non_specialized_visits FROM visits AS v
JOIN vets AS vet ON v.vet_id = vet.id
JOIN animals AS a ON v.animal_id = a.id
LEFT JOIN specializations AS sp ON vet.id = sp.vet_id AND a.species_id = sp.species_id
WHERE sp.vet_id IS NULL;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT COUNT(*) AS visit_count, s.name AS specialty_recommendaded FROM visits AS v
JOIN vets AS vet ON v.vet_id = vet.id
JOIN animals AS a ON v.animal_id = a.id
JOIN species AS s ON a.species_id = s.id
WHERE vet.name = 'Maisy Smith'
GROUP BY s.name
ORDER BY visit_count DESC
LIMIT 1;
