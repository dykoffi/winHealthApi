CREATE TABLE gap.Bordereaux (
    idBordereau SERIAL PRIMARY KEY,
    numeroBordereau VARCHAR(30),
    statutBordereau VARCHAR(100),
    dateEvnoiBordereaux VARCHAR(20),
    dateReceptionBordereaux VARCHAR(20),
    assuranceBordereau REFERENCES gap.Assurances (idAssurance)
);

CREATE TABLE gap.Bordereau_facture (
    idBordereau_facture SERIAL PRIMARY KEY
    facture VARCHAR(100) REFERENCES gap.Factures (numerofacture),
    bordereau VARCHAR(100) REFERENCES gap.Bordereaux (numeroBordereau)
);