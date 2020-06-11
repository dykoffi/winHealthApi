DELETE FROM general.Etablissement;
DELETE FROM general.Actes;
DELETE FROM gap.Factures;
DELETE FROM gap.Sejours;


INSERT INTO
    general.Etablissement (regionEtabblissement,districtEtablissement,nomEtablissement,statusEtablissement,adresseEtablissement,codePostaleEtablissement,telEtablissement,faxEtablissement,emailEtablissement,sitewebEtablissement,logoEtablissement )
VALUES
    ('ABIDJAN 2','DS COCODY-BINGERVILLE','POLYCLINIQUE ALTEA','Centre privée de soins','Cocody angré 7ème tranche','Abidjan BP 2014','21 35 60 15','21 55 96 35','info@altea-ci.com','www.altea.com','logoAltea.jpeg');

--Ajoutes des actes
INSERT INTO
    general.Actes (codeActe,lettreCleActe,typeActe,libelleActe,prixActe)
VALUES
('MAGC001','C','consultation','Consultation par le medecin generaliste',3500),
('MAGC002','CS','consultation','Consultation par le medecin specialiste',4500),
('DAGC003','CD','consultation','Consultation au cabinet du medecin dentiste',7500),
('DAGC004','CDS','consultation','Consultation au cabinet du medecin dentiste specialiste',6500),
('MAGC005','CNPSY','consultation','Consultation au cabinet du medecin psychiatre ou neurologue',12500),
('TAGC006','CSF','consultation','Consultation de la sage femme',13000);

--Ajouter des factures
-- INSERT INTO gap.Factures 
-- (dateFacture,heureFacture,auteurFacture,montantTotalFacture,resteFacture) 
-- VALUES
-- ('12-03-2020','15:30',1,15000,2500);

--Ajouter des sejours
-- INSERT INTO gap.Sejours 
-- (dateDebutSejour, 
-- dateFinSejour,
-- heureDebutSejour,
-- heureFinSejour,
-- typeSejour,
-- statusSejour,
-- patientSejour,
-- etablissementSejour,
-- factureSejour) VALUES 
-- ('12-05-2020','13-05-2020','15:16','15:30','consultation','en attente',1,1,1);

-- --Ajouter sejour acte
-- INSERT INTO gap.Sejour_Acte (numeroSejour,codeActe) VALUES
-- ('2020143-0020S','MAGC001'),
-- ('2020143-0020S','MAGC002'),
-- ('2020143-0020S','DAGC003'),
-- ('2020143-0020S','DAGC004'),
-- ('2020143-0020S','MAGC005');