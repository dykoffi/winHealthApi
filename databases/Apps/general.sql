DROP SCHEMA general CASCADE;

CREATE SCHEMA general;

CREATE TABLE general.Actes (
    idActe SERIAL PRIMARY KEY,
    codeActe VARCHAR(20),
    typeActe VARCHAR(50),
    libelleActe VARCHAR(200),
    cotationActe VARCHAR(10),
    regroupementActe VARCHAR(50)
);

CREATE TABLE general.DossierAdministratif (
    idDossier SERIAL PRIMARY KEY,
    codeDossier VARCHAR(20) UNIQUE
)INHERITS(gap.Patients);

CREATE TABLE general.DossierMedical (
    idDossier SERIAL PRIMARY KEY,
    codeDossier VARCHAR(20) UNIQUE
);

CREATE TABLE general.DossierParamedical (
    idDossier SERIAL PRIMARY KEY,
    codeDossier VARCHAR(20) UNIQUE
);

CREATE TABLE general.DossierPatient (
    idDossier SERIAL PRIMARY KEY,
    codeDossier VARCHAR(20),
    DossierAdministratif VARCHAR(20) REFERENCES general.DossierAdministratif (codeDossier),
    DossierMedical VARCHAR(20) REFERENCES general.DossierMedical (codeDossier),
    DossierParamedical VARCHAR(20) REFERENCES general.DossierParamedical (codeDossier),
    UNIQUE (DossierAdministratif, DossierMedical, DossierParamedical)
);
