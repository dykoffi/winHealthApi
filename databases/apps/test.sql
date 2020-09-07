DROP TABLE gap.Encaissements;
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