DROP SCHEMA admin CASCADE;
CREATE SCHEMA admin;
CREATE TABLE admin.Users (
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
CREATE TABLE admin.Login (
    idLogin SERIAL PRIMARY KEY,
    loginUser VARCHAR(255),
    passUser VARCHAR(255)
);
CREATE TABLE admin.Apps (
    idApp SERIAL PRIMARY KEY,
    codeApp VARCHAR(20),
    nomApp VARCHAR(50),
    descApp VARCHAR(50)
);
CREATE TABLE admin.Droits(
    idDroit SERIAL PRIMARY KEY,
    codeDroit VARCHAR(10),
    codeApp VARCHAR(15),
    labelDroit VARCHAR(100)
);
CREATE TABLE admin.Profils (
    idProfil SERIAL PRIMARY KEY,
    labelProfil VARCHAR(100),
    auteurProfil VARCHAR(30),
    dateProfil VARCHAR(100),
    codeApp VARCHAR(15),
    UNIQUE (labelProfil)
);
CREATE TABLE admin.Droit_Profil (
    idDroitProfil SERIAL PRIMARY KEY,
    idProfil INT NOT NULL,
    codeDroit VARCHAR(10)
);
CREATE TABLE admin.Logs (
    idLogs SERIAL PRIMARY KEY,
    typeLog VARCHAR (200),
    auteurLog VARCHAR(50),
    actionLog VARCHAR(150),
    dateLog VARCHAR(50),
    heureLog VARCHAR(50),
    codeApp VARCHAR(15)
);