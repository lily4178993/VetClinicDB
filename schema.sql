/* Database schema to keep the structure of entire database. */
CREATE TABLE animals
(
    id INT NOT NULL GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(255) NOT NULL,
    date_of_birth DATE NOT NULL,
    escape_attempts INT NOT NULL,
    neutered BOOLEAN NOT NULL,
    weight_kg NUMERIC(5, 2) NOT NULL
);

-- Add a comment to the "animals" table
COMMENT ON TABLE animals IS 'Table containing information about animals in the vet clinic';

-- Add comments to the columns of the "animals" table
COMMENT ON COLUMN animals.id IS 'Unique identifier for each animal';
COMMENT ON COLUMN animals.name IS 'Name of the animal';
COMMENT ON COLUMN animals.date_of_birth IS 'Date of birth of the animal';
COMMENT ON COLUMN animals.escape_attempts IS 'Number of escape attempts made by the animal';
COMMENT ON COLUMN animals.neutered IS 'Indicates if the animal is neutered (true/false)';
COMMENT ON COLUMN animals.weight_kg IS 'Weight of the animal in kilograms';


/* =========== Update "animals" table =========== */

-- Add a column species of type string to the "animals" table
ALTER TABLE animals ADD COLUMN species VARCHAR(255);

-- Add comments to the "species" columns of the "animals" table
COMMENT ON COLUMN animals.species IS 'Specy of the animal';
