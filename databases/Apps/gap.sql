DROP SCHEMA gap CASCADE;

CREATE SCHEMA gap;

CREATE TABLE gap.DossierAdministratif (
    -- dossier
    idDossier SERIAL PRIMARY KEY,
    codeDossier VARCHAR(20) UNIQUE,
    -- etablissement
    -- patient
    ippPatient VARCHAR(200) UNIQUE,
    nomPatient VARCHAR(100),
    prenomsPatient VARCHAR(200),
    nomJeuneFille VARCHAR(200),
    sexePatient VARCHAR(15),
    dateNaissancePatient VARCHAR(100),
    lieuNaissancePatient VARCHAR(100),
    nationalitePatient VARCHAR(50),
    professionPatient VARCHAR(100),
    situationMatrimonialePatient VARCHAR(50),
    religionPatient VARCHAR(100),
    habitationPatient VARCHAR(100),
    contactPatient VARCHAR(50),
    -- pere patient
    nomPerePatient VARCHAR(100),
    prenomsPerePatient VARCHAR(100),
    contactPerePatient VARCHAR(100),
    -- mere patient
    nomMerePatient VARCHAR(100),
    prenomsMerePatient VARCHAR(100),
    contactMerePatient VARCHAR(100),
    -- tuteur patient
    nomTuteurPatient VARCHAR(100),
    prenomsTuteurPatient VARCHAR(100),
    contactTuteurPatient VARCHAR(100),
    -- personne sur
    nomPersonnesurePatient VARCHAR(100),
    prenomsPersonnesurePatient VARCHAR(100),
    contactPersonnesurePatient VARCHAR(100),
    -- assurance
    assure VARCHAR(10),
    assurance VARCHAR(50)
);

CREATE TABLE gap.DossierMedical (
    idDossier SERIAL PRIMARY KEY,
    codeDossier VARCHAR(20) UNIQUE
);

CREATE TABLE gap.DossierParamedical (
    idDossier SERIAL PRIMARY KEY,
    codeDossier VARCHAR(20) UNIQUE
);

-- CREATE TABLE gap.DossierPatient (
--     idDossier SERIAL PRIMARY KEY,
--     codeDossier VARCHAR(20),
--     DossierAdministratif VARCHAR(20) REFERENCES gap.DossierAdministratif (codeDossier),
--     DossierMedical VARCHAR(20) REFERENCES gap.DossierMedical (codeDossier),
--     DossierParamedical VARCHAR(20) REFERENCES gap.DossierParamedical (codeDossier),
--     UNIQUE (
--         DossierAdministratif,
--         DossierMedical,
--         DossierParamedical
--     )
-- );

CREATE TABLE gap.Factures (
    idFacture SERIAL PRIMARY KEY,
    numeroFacture INTEGER,
    dateFacture DATE,
    heureFacture TIME,
    auteurFacture INTEGER REFERENCES public.Users (idUser)
);

CREATE TABLE gap.Sejours (
    idSejour SERIAL PRIMARY KEY,
    dateDebutSejour VARCHAR(50),
    dateFinSejour  VARCHAR(50),
    heureDebutSejour VARCHAR(50),
    heureFinSejour  VARCHAR(50),
    typeSejour VARCHAR(50), -- consultation, Hospitalisation ou soins
    statusSejour VARCHAR(20), -- en cours, termine ou annule
    patientSejour INTEGER REFERENCES gap.DossierAdministratif (idDossier),
    etablissementSejour INTEGER REFERENCES general.Etablissement (idEtablissement),
    factureSejour INTEGER REFERENCES gap.Factures (idFacture)
);
