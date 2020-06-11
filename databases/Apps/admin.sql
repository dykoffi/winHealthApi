DROP TABLE Users;

DROP TABLE Droits;

DROP TABLE Profils;

DROP TABLE Droit_Profil;

DROP TABLE Logs;

DROP TABLE Apps;

CREATE TABLE Users (
    idUser SERIAL PRIMARY KEY,
    nomUser VARCHAR(20),
    prenomsUser VARCHAR(50),
    contactUser VARCHAR(20),
    mailUser VARCHAR(30),
    posteUser VARCHAR(100),
    profilUser INTEGER,
    codeApp VARCHAR(15),
    loginUser VARCHAR(100),
    passUser VARCHAR(255)
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
    heureLog VARCHAR(50),
    codeApp VARCHAR(15)
);
