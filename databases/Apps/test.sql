DROP TABLE gap.Bordereau_factures;
DROP TABLE gap.Bordereaux;
CREATE TABLE gap.Bordereaux (
    idBordereau SERIAL PRIMARY KEY,
    numeroBordereau VARCHAR(30) UNIQUE DEFAULT get_numeroBordereau(),
    dateCreationBordereau VARCHAR(30),
    heureCreationBordereau VARCHAR(30),
    dateLimiteBordereau VARCHAR(30),
    gestionnaireBordereau VARCHAR(100),
    organismeBordereau VARCHAR(100),
    typeSejourBordereau VARCHAR(100),
    statutBordereau VARCHAR(100)
);
CREATE TABLE gap.Bordereau_factures (
    idBordereau_facture SERIAL PRIMARY KEY,
    numeroFacture VARCHAR(100) REFERENCES gap.Factures (numerofacture),
    numeroBordereau VARCHAR(100) REFERENCES gap.Bordereaux (numeroBordereau)
);