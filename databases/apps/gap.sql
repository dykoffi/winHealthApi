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
    qualitePersonnesurePatient VARCHAR(100)
);
CREATE TABLE gap.Assurances (
    idAssurance SERIAL PRIMARY KEY,
    nomAssurance VARCHAR(50) NOT NULL,
    codeAssurance VARCHAR(20),
    typeAssurance VARCHAR(20),
    faxAssurance VARCHAR(30),
    telAssurance VARCHAR(50),
    mailAssurance VARCHAR(30),
    localAssurance VARCHAR(100),
    siteAssurance VARCHAR(100)
);
CREATE TABLE gap.Sejours (
    idSejour SERIAL PRIMARY KEY,
    numeroSejour VARCHAR(30) UNIQUE DEFAULT get_numeroSejour(),
    dateDebutSejour VARCHAR(50),
    dateFinSejour VARCHAR(50),
    heureDebutSejour VARCHAR(50),
    heureFinSejour VARCHAR(50),
    specialiteSejour VARCHAR(50),
    typeSejour VARCHAR(50),
    -- consultation, Hospitalisation ou soins
    statusSejour VARCHAR(50),
    -- en cours, termine ou annule ou les differentes attentes
    medecinSejour VARCHAR(200),
    patientSejour INTEGER REFERENCES gap.DossierAdministratif (idDossier) ON DELETE CASCADE,
    etablissementSejour INTEGER REFERENCES general.Etablissement (idEtablissement) ON DELETE RESTRICT,
    --assurance
    gestionnaire VARCHAR(100),
    organisme VARCHAR(100),
    beneficiaire VARCHAR(50),
    assurePrinc VARCHAR(100),
    matriculeAssure VARCHAR(50),
    numeroPEC VARCHAR(20),
    taux INT DEFAULT 0
);
CREATE TABLE gap.Sejour_Acte (
    idSejourActe SERIAL PRIMARY KEY,
    numeroSejour VARCHAR(20) REFERENCES gap.Sejours (numeroSejour) ON DELETE CASCADE ON UPDATE CASCADE,
    codeActe VARCHAR(20) REFERENCES general.Actes (codeActe) ON DELETE CASCADE ON UPDATE CASCADE,
    prixUnique NUMERIC(15, 2),
    plafondAssurance NUMERIC(15, 2),
    quantite INT,
    prixActe NUMERIC(15, 2),
    prixActeAssurance NUMERIC(15, 2) GENERATED ALWAYS AS (plafondAssurance * quantite) STORED
);
CREATE TABLE gap.Factures (
    idFacture SERIAL PRIMARY KEY,
    numeroFacture VARCHAR(100) UNIQUE DEFAULT get_numeroFacture(),
    typeFacture VARCHAR(40),
    parentFacture VARCHAR(50) DEFAULT '',
    dateFacture VARCHAR(20),
    heureFacture VARCHAR(10),
    auteurFacture VARCHAR(100),
    montantTotalFacture INT DEFAULT 0,
    partAssuranceFacture INT DEFAULT 0,
    partPatientFacture INT DEFAULT 0,
    resteAssuranceFacture INT DEFAULT 0,
    restePatientFacture INT DEFAULT 0,
    statutFacture VARCHAR(50) DEFAULT 'attente',
    erreurFacture VARCHAR(100) DEFAULT '',
    commentaireFacture TEXT DEFAULT '',
    sejourFacture VARCHAR(30) REFERENCES gap.Sejours (numeroSejour) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE gap.Paiements (
    idPaiement SERIAL PRIMARY KEY,
    numeroPaiement VARCHAR(30) UNIQUE DEFAULT get_numeroPaiement(),
    modePaiement VARCHAR(100),
    montantPaiement VARCHAR(50) NOT NULL,
    sourcePaiement VARCHAR(30),
    facturePaiement VARCHAR(30) REFERENCES gap.Factures (numeroFacture) ON DELETE CASCADE
);
CREATE TABLE gap.Recus (
    idRecu SERIAL PRIMARY KEY,
    numeroRecu VARCHAR(30) UNIQUE DEFAULT get_numeroRecu(),
    montantRecu INT,
    dateRecu DATE,
    patientRecu VARCHAR(100),
    factureRecu VARCHAR(30) REFERENCES gap.Factures(numeroFacture) ON DELETE CASCADE ON UPDATE CASCADE,
    paiementRecu VARCHAR(30) REFERENCES gap.Paiements(numeroPaiement) ON DELETE CASCADE ON UPDATE CASCADE,
    sejourRecu VARCHAR(30) REFERENCES gap.Sejours(numeroSejour) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE gap.Comptes (
    idCompte SERIAL PRIMARY KEY,
    numeroCompte VARCHAR(30) UNIQUE DEFAULT get_numeroCompte(),
    montantCompte INT DEFAULT 0,
    dateCompte VARCHAR(20),
    heureCompte VARCHAR(10),
    patientCompte VARCHAR(20) REFERENCES gap.DossierAdministratif (ippPatient) ON DELETE CASCADE
);
CREATE TABLE gap.Transactions (
    idTransaction SERIAL PRIMARY KEY,
    dateTransaction VARCHAR(20),
    heureTransaction VARCHAR(10),
    montantTransaction INT,
    modeTransaction VARCHAR(20),
    typeTransaction VARCHAR(20),
    compteTransaction VARCHAR(20) REFERENCES gap.Comptes (numeroCompte) ON DELETE CASCADE
);
CREATE TABLE gap.Controles (
    idControle SERIAL PRIMARY KEY,
    dateDebutControle VARCHAR(30),
    heureDebutControle VARCHAR(20),
    dateFinControle VARCHAR(30),
    heureFinControle VARCHAR(20),
    typeControle VARCHAR(30) DEFAULT 'Controle',
    statutControle VARCHAR(30) DEFAULT 'attente(infirmier)',
    sejourControle VARCHAR(20) REFERENCES gap.Sejours (numeroSejour) ON DELETE CASCADE
);
CREATE TABLE gap.Bordereaux (
    idBordereau SERIAL PRIMARY KEY,
    numeroBordereau VARCHAR(30) UNIQUE DEFAULT get_numeroBordereau(),
    dateCreationBordereau VARCHAR(30),
    heureCreationBordereau VARCHAR(30),
    dateLimiteBordereau VARCHAR(30),
    gestionnaireBordereau VARCHAR(100),
    organismeBordereau VARCHAR(100),
    typeSejourBordereau VARCHAR(100),
    montantTotal INT,
    partAssurance INT,
    partPatient INT,
    statutBordereau VARCHAR(100),
    commentaireBordereau TEXT
);
CREATE TABLE gap.Bordereau_factures (
    idBordereau_facture SERIAL PRIMARY KEY,
    numeroFacture VARCHAR(100) REFERENCES gap.Factures (numerofacture) ON DELETE CASCADE ON UPDATE CASCADE,
    numeroBordereau VARCHAR(100) REFERENCES gap.Bordereaux (numeroBordereau) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE gap.Encaissements (
    id SERIAL PRIMARY KEY,
    numeroEncaissement VARCHAR(30) UNIQUE DEFAULT get_numeroPaiement(),
    dateEncaissement DATE DEFAULT NOW()::DATE,
    heureEncaissement TIME DEFAULT NOW()::TIME,
    modePaiementEncaissement VARCHAR(100),
    commentaireEncaissement TEXT,
    montantEncaissement INT,
    resteEncaissement INT,
    assuranceEncaissement VARCHAR(200),
    recepteurEncaissement VARCHAR(200)
)