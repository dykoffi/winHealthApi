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
CREATE TABLE general.Actes (
    idActe SERIAL PRIMARY KEY,
    codeActe VARCHAR(30) UNIQUE,
    typeActe VARCHAR(100),
    libelleActe TEXT,
    lettreCleActe VARCHAR(10),
    regroupementActe VARCHAR(10),
    cotationActe VARCHAR(10),
    prixActe VARCHAR(20)
);
CREATE TABLE general.UniteFonctionnelle ();
CREATE TABLE general.UniteMedicale ();
CREATE TABLE general.Chambre ();