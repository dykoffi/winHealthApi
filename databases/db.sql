DROP TABLE Users;

DROP TABLE Droits;

DROP TABLE Profils;

DROP TABLE Droit_Profil;

DROP TABLE Logs;

DROP TABLE Apps;

CREATE TABLE Users (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(20),
    prenoms VARCHAR(50),
    contact VARCHAR(20),
    mail VARCHAR(30),
    poste VARCHAR(100),
    profil VARCHAR(100),
    codeApp VARCHAR(15),
    pass VARCHAR(200)
);

CREATE TABLE Apps (
    idApp SERIAL PRIMARY KEY,
    codeApp VARCHAR(20),
    nomApp VARCHAR(50),
    descApp VARCHAR(50)
);

CREATE TABLE Droits(
    idDroit SERIAL PRIMARY KEY,
    codeDroit VARCHAR(10),
    codeApp VARCHAR(15),
    labelDroit VARCHAR(100)
);

CREATE TABLE Profils (
    idProfil SERIAL PRIMARY KEY,
    labelProfil VARCHAR(100),
    auteurProfil VARCHAR(30),
    dateProfil VARCHAR(100),
    codeApp VARCHAR(15),
    UNIQUE (labelProfil)
);

CREATE TABLE Droit_Profil (
    idDroitProfil SERIAL PRIMARY KEY,
    idProfil INT NOT NULL,
    codeDroit VARCHAR(10)
);

CREATE TABLE Logs (
    idLogs SERIAL PRIMARY KEY,
    typeLog VARCHAR (200),
    auteurLog VARCHAR(50),
    actionLog VARCHAR(150),
    dateLog VARCHAR(50),
    codeApp VARCHAR(15)
);

\i insert.sql
