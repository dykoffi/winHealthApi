DROP TABLE gap.Bordereaux CASCADE;
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
    statutBordereau VARCHAR(100)
);