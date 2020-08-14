DROP FUNCTION get_ipp CASCADE;
DROP SEQUENCE ipp_sequence;
CREATE SEQUENCE ipp_sequence MINVALUE 1 MAXVALUE 9999 START 1;
CREATE FUNCTION get_ipp() RETURNS TEXT AS $$
SELECT concat(
        rpad(current_date::TEXT, 4),
        (
            current_date + 1 - (concat(rpad(current_date::TEXT, 4), '-01-01'))::DATE
        )::TEXT,
        '-',
        lpad(nextval('ipp_sequence')::TEXT, 4, '000'),
        'P'
    ) $$ LANGUAGE SQL STRICT;
--Numero de paiement
DROP FUNCTION get_numeroPaiement CASCADE;
DROP SEQUENCE numeroPaiement_sequence;
CREATE SEQUENCE numeroPaiement_sequence MINVALUE 1 MAXVALUE 9999 START 1;
CREATE FUNCTION get_numeroPaiement() RETURNS TEXT AS $$
SELECT concat(
        rpad(current_date::TEXT, 4),
        (
            current_date + 1 - (concat(rpad(current_date::TEXT, 4), '-01-01'))::DATE
        )::TEXT,
        '-',
        lpad(
            nextval('numeroPaiement_sequence')::TEXT,
            4,
            '000'
        ),
        'P'
    ) $$ LANGUAGE SQL STRICT;
--Numero de paiement
DROP FUNCTION get_numeroRecu CASCADE;
DROP SEQUENCE numeroRecu_sequence;
CREATE SEQUENCE numeroRecu_sequence MINVALUE 1 MAXVALUE 9999 START 1;
CREATE FUNCTION get_numeroRecu() RETURNS TEXT AS $$
SELECT concat(
        rpad(current_date::TEXT, 4),
        (
            current_date + 1 - (concat(rpad(current_date::TEXT, 4), '-01-01'))::DATE
        )::TEXT,
        '-',
        lpad(nextval('numeroRecu_sequence')::TEXT, 4, '000'),
        'R'
    ) $$ LANGUAGE SQL STRICT;
--Numero de sejour
DROP FUNCTION get_NumeroSejour CASCADE;
DROP SEQUENCE NumeroSejour_sequence;
CREATE SEQUENCE NumeroSejour_sequence MINVALUE 1 MAXVALUE 9999 START 1;
CREATE FUNCTION get_NumeroSejour() RETURNS TEXT AS $$
SELECT concat(
        rpad(current_date::TEXT, 4),
        (
            current_date + 1 - (concat(rpad(current_date::TEXT, 4), '-01-01'))::DATE
        )::TEXT,
        '-',
        lpad(
            nextval('numeroSejour_sequence')::TEXT,
            4,
            '00000'
        ),
        'S'
    ) $$ LANGUAGE SQL STRICT;
--Numero de facture
DROP FUNCTION get_NumeroFacture CASCADE;
DROP SEQUENCE NumeroFacture_sequence;
CREATE SEQUENCE NumeroFacture_sequence MINVALUE 1 MAXVALUE 9999 START 1;
CREATE FUNCTION get_NumeroFacture() RETURNS TEXT AS $$
SELECT concat(
        lpad(
            nextval('numeroFacture_sequence')::TEXT,
            4,
            '00000'
        ),
        'F'
    ) $$ LANGUAGE SQL STRICT;
--Numero de bordereau
DROP FUNCTION get_NumeroBordereau CASCADE;
DROP SEQUENCE NumeroBordereau_sequence;
CREATE SEQUENCE NumeroBordereau_sequence MINVALUE 1 MAXVALUE 9999 START 1;
CREATE FUNCTION get_NumeroBordereau() RETURNS TEXT AS $$
SELECT concat(
        lpad(
            nextval('numeroBordereau_sequence')::TEXT,
            4,
            '00000'
        ),
        'B'
    ) $$ LANGUAGE SQL STRICT;
-- Numero de compte
DROP FUNCTION get_numeroCompte CASCADE;
DROP SEQUENCE numeroCompte_sequence;
CREATE SEQUENCE numeroCompte_sequence MINVALUE 1 MAXVALUE 9999 START 1;
CREATE FUNCTION get_numeroCompte() RETURNS TEXT AS $$
SELECT concat(
        rpad(current_date::TEXT, 4),
        (
            current_date + 1 - (concat(rpad(current_date::TEXT, 4), '-01-01'))::DATE
        )::TEXT,
        '-',
        lpad(nextval('numeroCompte_sequence')::TEXT, 4, '000'),
        'C'
    ) $$ LANGUAGE SQL STRICT;
-- FACTURE
-- Avoir le montant total de la facture
CREATE OR REPLACE FUNCTION get_total_facture(numeroSejour TEXT) RETURNS INT AS $$
SELECT SUM(prixActe::INT)::INT
FROM gap.Sejour_Acte
WHERE Sejour_Acte.numeroSejour = $1
GROUP BY Sejour_Acte.numeroSejour $$ LANGUAGE SQL STRICT;
-- Avoir le montant total de la facture pour l'assurance avec les plafond
DROP FUNCTION get_total_facture_Assurance;
CREATE FUNCTION get_total_facture_Assurance(numeroSejour TEXT) RETURNS INT AS $$
SELECT SUM(prixActeAssurance::INT)::INT
FROM gap.Sejour_Acte
WHERE Sejour_Acte.numeroSejour = $1
GROUP BY Sejour_Acte.numeroSejour $$ LANGUAGE SQL STRICT;
-- Avoir la part de l'assurance pour une facture donnée
DROP FUNCTION get_part_assurance;
CREATE FUNCTION get_part_assurance(numeroSejour TEXT) RETURNS NUMERIC(15, 2) AS $$
SELECT (
        ((taux::INT) *(get_total_facture_Assurance($1))) / 100
    )::NUMERIC(15, 2)
FROM gap.Sejours
WHERE numeroSejour = $1 $$ LANGUAGE SQL STRICT;
-- Avoir la part du patient pour une facture donnée
DROP FUNCTION get_part_patient;
CREATE OR REPLACE FUNCTION get_part_patient(numeroSejour TEXT) RETURNS NUMERIC(15, 2) AS $$
SELECT (get_total_facture($1) - get_part_assurance($1))::NUMERIC(15, 2) $$ LANGUAGE SQL STRICT;
-- AVOIR LES PAIEMENT D'UN PATIENT DONNÉ
CREATE OR REPLACE FUNCTION get_paiement_patient(numeroFacture TEXT) RETURNS INT AS $$
SELECT SUM(montantPaiement::INT)::INT
FROM gap.paiements,
    gap.Factures
WHERE numeroFacture = facturePaiement
    AND sourcePaiement = 'Patient'
    AND numeroFacture = $1 $$ LANGUAGE SQL STRICT;
-- AVOIR LES PAIEMENT D'UNE ASSURANCE DONNÉE
CREATE OR REPLACE FUNCTION get_paiement_assurance(numeroFacture TEXT) RETURNS INT AS $$
SELECT SUM(montantPaiement::INT)::INT
FROM gap.paiements,
    gap.Factures
WHERE numeroFacture = facturePaiement
    AND sourcePaiement = 'Assurance'
    AND numeroFacture = $1 $$ LANGUAGE SQL STRICT;
-- AVOIR LE RESTE DE LA FACTURE POUR LES PATIENTS
DROP FUNCTION get_reste_patient;
CREATE FUNCTION get_reste_patient(numeroSejour TEXT, numeroFacture TEXT) RETURNS NUMERIC(15, 2) AS $$
SELECT get_part_patient(numeroSejour) - get_paiement_patient(numeroFacture) $$ LANGUAGE SQL STRICT;
-- AVOIR LES RESTES LA FACTURES POUR LES ASSURANCES 
DROP FUNCTION get_reste_assurance;
CREATE OR REPLACE FUNCTION get_reste_assurance(numeroSejour TEXT, numeroFacture TEXT) RETURNS NUMERIC(15, 2) AS $$
SELECT (
        get_part_assurance(numeroSejour) - get_paiement_assurance(numeroFacture)
    )::NUMERIC(15, 2) $$ LANGUAGE SQL STRICT;
--CONTROLE
CREATE OR REPLACE FUNCTION get_controle_sejour(numeroSejour TEXT) RETURNS INT AS $$
SELECT COUNT(*)::INT nb_controle
FROM gap.Controles,
    gap.Sejours
WHERE sejourControle = $1 $$ LANGUAGE SQL STRICT;
CREATE OR REPLACE FUNCTION get_date_sejour(numeroSejour TEXT) RETURNS DATE AS $$
SELECT dateDebutSejour::DATE
FROM gap.Sejours
WHERE numerosejour = $1 $$ LANGUAGE SQL STRICT;
CREATE OR REPLACE FUNCTION get_delai_controle (numeroSejour TEXT) RETURNS INT AS $$
SELECT (current_date - get_date_sejour($1));
$$ LANGUAGE SQL STRICT;
-- COMPTES
CREATE OR REPLACE FUNCTION get_montant_compte (numeroCompte TEXT) RETURNS INT AS $$
SELECT SUM(montantTransaction::INT)::INT
FROM gap.Comptes,
    gap.Transactions
WHERE Comptes.numeroCompte = $1
    AND compteTransaction = numeroCompte
GROUP BY numeroCompte $$ LANGUAGE SQL STRICT;
CREATE OR REPLACE FUNCTION get_nbfacture_bordereau (numeroBordereau TEXT) RETURNS INT AS $$
SELECT COUNT(*)::INT
FROM gap.Bordereau_factures
WHERE numeroBordereau = $1 $$ LANGUAGE SQL STRICT;