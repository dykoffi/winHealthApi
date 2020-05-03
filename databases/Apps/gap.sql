DROP SCHEMA gap CASCADE;
CREATE SCHEMA gap;

-- CREATE gap.Fonctions (
--     idFontcion SERIAL PRIMARY KEY,
--     codeFonction INTEGER,
--     nomFonction VARCHAR(50),
--     pageFonction VARCHAR(100)
-- );

CREATE TABLE gap.Personnes (
    idPersonne SERIAL PRIMARY KEY,
    nomPersonne VARCHAR(50),
    prenomsPersonne VARCHAR(100),
    contactPersonne VARCHAR(70),
    mailPersonne VARCHAR(50)
);

CREATE TABLE gap.Referencement (
    idReferencement SERIAL PRIMARY KEY,
    dateReferencement VARCHAR(20),
    centreReferencement VARCHAR(100)
);

CREATE TABLE gap.Patients (
    idPatient SERIAL PRIMARY KEY,
    ippPatient VARCHAR(200),
    nomPatient VARCHAR(100),
    prenomsPatient VARCHAR(200),
    sexePatient VARCHAR(15),
    dateNaissancePatient VARCHAR(100),
    lieuNaissancePatient VARCHAR(100),
    nationalitePatient VARCHAR(50),
    profesionPatient VARCHAR(100),
    situationMatrimonialePatient VARCHAR(50),
    religionPatient VARCHAR(100),
    habitationPatient VARCHAR(100),
    contactPatient VARCHAR(50),
    mailPatient VARCHAR(70),
    nomprenomsPerePatient VARCHAR(100),
    nomprenomsMerePatient VARCHAR(100),
    tuteur INTEGER REFERENCES gap.personnes (idPersonne),
    personneContact INTEGER REFERENCES gap.Personnes (idPersonne),
    referencement INTEGER REFERENCES gap.Referencement (idReferencement)
);

