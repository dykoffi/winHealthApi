DROP FUNCTION get_ipp CASCADE;
DROP SEQUENCE ipp_sequence;
CREATE SEQUENCE ipp_sequence MINVALUE 1 MAXVALUE 9999 START 1;
CREATE FUNCTION get_ipp() RETURNS TEXT AS $$
SELECT
    concat(
        rpad(current_date :: TEXT, 4),
        (
            current_date + 1 - (concat(rpad(current_date :: TEXT, 4), '-01-01')) :: DATE
        ) :: TEXT,
        '-',
        lpad(nextval('ipp_sequence')::TEXT,4,'000'),
        'P'
    ) $$ LANGUAGE SQL STRICT;


DROP FUNCTION get_NumeroSejour CASCADE;
DROP SEQUENCE NumeroSejour_sequence;
CREATE SEQUENCE NumeroSejour_sequence MINVALUE 1 MAXVALUE 9999 START 1;
CREATE FUNCTION get_NumeroSejour() RETURNS TEXT AS $$
SELECT 
     concat(
        rpad(current_date :: TEXT, 4),
        (
            current_date + 1 - (concat(rpad(current_date :: TEXT, 4), '-01-01')) :: DATE
        ) :: TEXT,
        '-',
        lpad(nextval('numeroSejour_sequence')::TEXT,4,'000'),
        'S'
    ) $$ LANGUAGE SQL STRICT;


DROP FUNCTION get_NumeroFacture CASCADE;
DROP SEQUENCE NumeroFacture_sequence;
CREATE SEQUENCE NumeroFacture_sequence MINVALUE 1 MAXVALUE 9999 START 1;
CREATE FUNCTION get_NumeroFacture() RETURNS TEXT AS $$
SELECT 
     concat(
        lpad(nextval('numeroFacture_sequence')::TEXT,4,'000'),
        'F'
    ) $$ LANGUAGE SQL STRICT;


CREATE OR REPLACE FUNCTION get_total_facture(numeroSejour TEXT) RETURNS INT AS 
$$
    SELECT SUM(prixActe::INT)::INT FROM 
    gap.Sejours, 
    general.Actes, 
    gap.Sejour_Acte WHERE
    Sejours.numeroSejour=Sejour_Acte.numeroSejour AND
    Sejour_Acte.codeActe=Actes.codeActe AND
    Sejours.numeroSejour=$1 GROUP BY Sejours.numeroSejour

$$ LANGUAGE SQL STRICT;

CREATE OR REPLACE FUNCTION get_paye_facture(numeroFacture TEXT) RETURNS INT AS 
$$
    SELECT SUM(montantPaiement::INT)::INT FROM 
    gap.paiements,
    gap.Factures WHERE 
    numeroFacture=facturePaiement AND
    numeroFacture=$1
$$ LANGUAGE SQL STRICT;

CREATE OR REPLACE FUNCTION get_reste_facture(numeroSejour TEXT, numeroFacture TEXT) RETURNS INT AS 
$$
    SELECT get_total_facture(numeroSejour) - get_paye_facture(numeroFacture)
$$ LANGUAGE SQL STRICT;