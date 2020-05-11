INSERT INTO
    general.Etablissement (regionEtabblissement,districtEtablissement,nomEtablissement,statusEtablissement,adresseEtablissement,codePostaleEtablissement,telEtablissement,faxEtablissement,emailEtablissement,sitewebEtablissement,logoEtablissement )
VALUES
    ('ABIDJAN 2','DS COCODY-BINGERVILLE','POLYCLINIQUE ALTEA','Centre privée de soins','Cocody angré 7ème tranche','Abidjan BP 2014','21 35 60 15','21 55 96 35','info@altea-ci.com','www.altea.com','logoAltea.jpeg');


INSERT INTO
    general.Actes (codeActe,lettreCleActe,typeActe,libelleActe,prixActe)
VALUES
('MAGC001','C','consultation','Consultation par le medecin generaliste',3500),
('MAGC002','CS','consultation','Consultation par le medecin specialiste',4500),
('DAGC003','CD','consultation','Consultation au cabinet du medecin dentiste',7500),
('DAGC004','CDS','consultation','Consultation au cabinet du medecin dentiste specialiste',6500),
('MAGC005','CNPSY','consultation','Consultation au cabinet du medecin psychiatre ou neurologue',12500),
('TAGC006','CSF','consultation','Consultation de la sage femme',13000);