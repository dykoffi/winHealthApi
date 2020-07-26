CREATE OR REPLACE FUNCTION get_prix_acte (lettreCle TEXT) RETURNS INT AS $$
SELECT prixActe::INT
FROM general.Prix_Actes
WHERE lettreCleActe = $1 $$ LANGUAGE SQL STRICT;