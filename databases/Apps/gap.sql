DROP SCHEMA gap CASCADE;

CREATE SCHEMA gap;

CREATE TABLE gap.DossierAdministratif (
    -- dossier
    idDossier SERIAL PRIMARY KEY,
    -- patient
    ippPatient VARCHAR(200) UNIQUE DEFAULT get_ipp(),
    nomPatient VARCHAR(100),
    prenomsPatient VARCHAR(200),
    civilitePatient VARCHAR(200),
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
    qualitePersonnesurePatient VARCHAR(100),
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

CREATE TABLE gap.Sejours (
    idSejour SERIAL PRIMARY KEY,
    numeroSejour VARCHAR(30) UNIQUE DEFAULT get_numeroSejour(),
    dateDebutSejour VARCHAR(50),
    dateFinSejour  VARCHAR(50),
    heureDebutSejour VARCHAR(50),
    heureFinSejour  VARCHAR(50),
    typeSejour VARCHAR(50), -- consultation, Hospitalisation ou soins
    statusSejour VARCHAR(20), -- en cours, termine ou annule ou les differentes attentes
    patientSejour INTEGER REFERENCES gap.DossierAdministratif (idDossier),
    etablissementSejour INTEGER REFERENCES general.Etablissement (idEtablissement)
);

CREATE TABLE gap.Sejour_Acte (
    idSejourActe SERIAL PRIMARY KEY,
    numeroSejour VARCHAR(20) REFERENCES gap.Sejours (numeroSejour),
    codeActe VARCHAR(20) REFERENCES general.Actes (codeActe)
);

CREATE TABLE gap.Factures (
    idFacture SERIAL PRIMARY KEY,
    numeroFacture VARCHAR(100) UNIQUE DEFAULT get_numeroFacture(),
    dateFacture VARCHAR(20),
    heureFacture VARCHAR(10),
    auteurFacture VARCHAR(100),
    montantTotalFacture INT,
    resteFacture INT,
    sejourFacture VARCHAR(30) REFERENCES gap.Sejours (numeroSejour)
);

CREATE TABLE gap.Paiements (
    idPaiement SERIAL PRIMARY KEY,
    modePaiement VARCHAR(100),
    montantPaiement VARCHAR(50),
    facturePaiement VARCHAR(30) REFERENCES gap.Factures (numeroFacture)
);

CREATE TABLE gap.Comptes (
    idCompte SERIAL PRIMARY KEY,
    numeroCompte  VARCHAR(20) UNIQUE DEFAULT get_numeroCompte(),
    montantCompte INT DEFAULT 0,
    dateCompte VARCHAR(20),
    heureCompte VARCHAR(10),
    patientCompte VARCHAR(20) REFERENCES gap.DossierAdministratif (ippPatient)
);

CREATE TABLE gap.Transactions (
    idTransaction  SERIAL PRIMARY KEY,
    dateTransaction VARCHAR(20),
    heureTransaction VARCHAR(10),
    montantTransaction INT,
    modeTransaction VARCHAR(20),
    typeTransaction VARCHAR(20),
    compteTransaction VARCHAR(20) REFERENCES gap.Comptes (numeroCompte)
);

CREATE TABLE gap.Controles (
    idControle SERIAL PRIMARY KEY,
    dateDebutControle VARCHAR(30),
    heureDebutControle VARCHAR(20),
    dateFinControle VARCHAR(30),
    heureFinControle VARCHAR(20),
    typeControle VARCHAR(30)  DEFAULT 'Controle',   
    statutControle VARCHAR(30) DEFAULT 'attente(infirmier)',
    sejourControle VARCHAR(20) REFERENCES gap.Sejours (numeroSejour)
);

CREATE TABLE gap.Assurances (
    idAssurance SERIAL PRIMARY KEY,
    nomAssurance VARCHAR(50),
    codeAssurance VARCHAR(20),
    faxAssurance VARCHAR(30),
    contactAsssurance VARCHAR(50),
    mailAssurance VARCHAR(30),
    localAssurance VARCHAR(100)
);