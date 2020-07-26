DROP TABLE gap.Bordereaux CASCADE;
DROP TABLE gap.Factures CASCADE;
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
    resteAssurance INT,
    partPatient INT,
    statutBordereau VARCHAR(100),
    commentaireBordereau TEXT
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
    statutFactures VARCHAR(50) DEFAULT 'attente',
    erreurFacture VARCHAR(100) DEFAULT '',
    commentaireFacture TEXT DEFAULT '',
    sejourFacture VARCHAR(30) REFERENCES gap.Sejours (numeroSejour) ON DELETE CASCADE
);