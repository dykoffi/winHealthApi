DROP TABLE Droits;

DROP TABLE Profils;

DROP TABLE Droit_Profil;

CREATE TABLE Droits(
    idDroit SERIAL,
    codeDroit VARCHAR(10),
    labelDroit VARCHAR(100)
);

CREATE TABLE Profils (
    idProfil SERIAL,
    labelProfil VARCHAR(100),
    auteurProfil VARCHAR(30),
    dateProfil VARCHAR(20),
    UNIQUE (labelProfil)
);

CREATE TABLE Droit_Profil (
    idDroitProfil SERIAL PRIMARY KEY,
    idProfil INT NOT NULL,
    codeDroit VARCHAR(10)
);

\i databases/insert.sql