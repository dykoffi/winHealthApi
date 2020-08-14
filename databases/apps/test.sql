CREATE TABLE gap.Recus (
    idRecu SERIAL PRIMARY KEY,
    numeroRecu VARCHAR(30) UNIQUE DEFAULT get_numeroRecu(),
    montantRecu INT,
    dateRecu DATE,
    patientRecu VARCHAR(100),
    factureRecu VARCHAR(20) REFERENCES gap.Factures(numeroFacture),
    paiementRecu VARCHAR(20) REFERENCES gap.Paiement(numeroPaiement),
    sejourRecu VARCHAR(20) REFERENCES gap.Sejours(numeroSejour),
)