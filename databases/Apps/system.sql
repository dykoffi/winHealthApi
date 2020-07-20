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
FROM gap.Sejours,
    general.Actes,
    gap.Sejour_Acte
WHERE Sejours.numeroSejour = Sejour_Acte.numeroSejour
    AND Sejour_Acte.codeActe = Actes.codeActe
    AND Sejours.numeroSejour = $1
GROUP BY Sejours.numeroSejour $$ LANGUAGE SQL STRICT;
-- Avoir la part de l'assurance pour une facture donnée
CREATE OR REPLACE FUNCTION get_part_assurance(numeroSejour TEXT) RETURNS INT AS $$
SELECT ((taux::INT) *(get_total_facture($1))) / 100
FROM gap.Sejours
WHERE numeroSejour = $1 $$ LANGUAGE SQL STRICT;
-- Avoir la part du patient pour une facture donnée
CREATE OR REPLACE FUNCTION get_part_patient(numeroSejour TEXT) RETURNS INT AS $$
SELECT get_total_facture($1) - get_part_assurance($1) $$ LANGUAGE SQL STRICT;
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
CREATE OR REPLACE FUNCTION get_reste_patient(numeroSejour TEXT, numeroFacture TEXT) RETURNS INT AS $$
SELECT get_part_patient(numeroSejour) - get_paiement_patient(numeroFacture) $$ LANGUAGE SQL STRICT;
-- AVOIR LES RESTES LA FACTURES POUR LES ASSURANCES 
CREATE OR REPLACE FUNCTION get_reste_assurance(numeroSejour TEXT, numeroFacture TEXT) RETURNS INT AS $$
SELECT get_part_assurance(numeroSejour) - get_paiement_assurance(numeroFacture) $$ LANGUAGE SQL STRICT;
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
SELECT COUNT(*)
FROM gap.Bordereau_factures
WHERE numeroBordereau = $1 $$ LANGUAGE SQL STRICT;