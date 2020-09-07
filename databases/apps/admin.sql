DROP SCHEMA admin CASCADE;
CREATE SCHEMA admin;
CREATE TABLE admin.Apps (
    idApp SERIAL PRIMARY KEY,
    codeApp VARCHAR(20) UNIQUE,
    nomApp VARCHAR(50) UNIQUE,
    descApp VARCHAR(50)
);
CREATE TABLE admin.Profils (
    idProfil SERIAL PRIMARY KEY,
    labelProfil VARCHAR(100) UNIQUE,
    dateProfil DATE DEFAULT NOW(),
    codeApp VARCHAR(20) REFERENCES admin.Apps(codeApp),
    permissionsProfil TEXT
);
CREATE TABLE admin.Users (
    idUser SERIAL PRIMARY KEY,
    nomUser VARCHAR(20),
    prenomsUser VARCHAR(50),
    contactUser VARCHAR(20),
    mailUser VARCHAR(30),
    posteUser VARCHAR(100),
    serviceUser VARCHAR(100),
    loginUser VARCHAR(100),
    passUser VARCHAR(255),
    profilUser VARCHAR(100) REFERENCES admin.Profils(labelprofil)
);
CREATE TABLE admin.Connections (
    idConnection SERIAL PRIMARY KEY,
    statusConnection VARCHAR(100),
    userConnection INT REFERENCES admin.Users(idUser)
);
CREATE TABLE admin.Logs (
    idLogs SERIAL PRIMARY KEY,
    dateLog DATE DEFAULT NOW()::DATE,
    heureLog TIME DEFAULT NOW()::TIME,
    typeLog VARCHAR (200),
    objetLog VARCHAR(200),
    auteurLog VARCHAR(50),
    operationLog TEXT,
    actionLog TEXT,
    App VARCHAR(50) REFERENCES admin.Apps(codeApp)
);