DROP SCHEMA general CASCADE;

CREATE SCHEMA general;

CREATE TABLE general.Etablissement (
    idEtablissement SERIAL PRIMARY KEY,
    regionEtabblissement VARCHAR(100),
    districtEtablissement VARCHAR(100),
    nomEtablissement VARCHAR(100),
    statusEtablissement VARCHAR(100),
    adresseEtablissement VARCHAR(200),
    codePostaleEtablissement VARCHAR(100),
    telEtablissement VARCHAR(50),
    faxEtablissement VARCHAR(20),
    emailEtablissement VARCHAR(30),
    sitewebEtablissement VARCHAR(20),
    logoEtablissement VARCHAR(200)
);

CREATE TABLE general.Personnel (idActe SERIAL PRIMARY KEY);

CREATE TABLE general.Actes (
    idActe SERIAL PRIMARY KEY,
    codeActe VARCHAR(30),
    typeActe VARCHAR(100),
    libelle VARCHAR(200),
    regroupementActe VARCHAR(10),
    cotationActe VARCHAR(10),
    prixActe VARCHAR(20)
);

CREATE TABLE general.UniteFonctionnelle ();

CREATE TABLE general.UniteMedicale ();

CREATE TABLE general.Chambre ();

CREATE TABLE general.Liens (
    idLien SERIAL PRIMARY KEY,
    titleLien VARCHAR(50),
    iconLien VARCHAR(50),
    refLien VARCHAR(100)
);

CREATE TABLE general.Onglets (
    idOnglet SERIAL PRIMARY KEY,
    titleOnglet VARCHAR(50),
    iconOnglet VARCHAR(50),
    refOnglet VARCHAR(100),
    lienOnglet INTEGER REFERENCES general.Liens (idLien)
)