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
