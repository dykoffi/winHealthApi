CREATE OR REPLACE FUNCTION test() RETURNS TEXT AS $$
   SELECT nompatient FROM gap.DossierAdministratif WHERE idDossier=1;
$$ LANGUAGE SQL;

