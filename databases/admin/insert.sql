INSERT INTO Users(nomUser, prenomsUser,contactUser,mailUser, posteUser, profilUser, codeapp,loginUser, passUser) VALUES 
-- ('ALTEA','CI','51 88 64 78','winhealth@altea-ci.com', 'Agent ALTEA', 1,'COAP004','admin','47dfbc37d2577197c6db50e5e52693a27dee2f3725671e2bb917f9b38fd44795'),
('Edy','Koffi','51 88 64 78','winhealth@altea-ci.com', 'Agent ALTEA DPI', 2,'COAP002','dpi','47dfbc37d2577197c6db50e5e52693a27dee2f3725671e2bb917f9b38fd44795');


-- INSERT INTO Droits(codeDroit,codeApp, labelDroit) VALUES
-- ('CODR001','COAP001','Creation de patient'),
-- ('CODR002','COAP001','Creation de dossier administratif'),
-- ('CODR003','COAP001','Saisie d acte'),
-- ('CODR004','COAP001','Edition de facture'),
-- ('CODR005','COAP001','Encaissement'),
-- ('CODR006','COAP001','Modification d encaissement'),
-- ('CODR007','COAP001','Ventilation comptable'),
-- ('CODR008','COAP001','Validation administrative des dossiers'),
-- ('CODR009','COAP001','Generation envois bordereaux'),
-- ('CODR010','COAP001','Suivis bordereaux'),
-- ('CODR011','COAP001','Encaissement des mutuelles (assurances)'),
-- ('CODR012','COAP001','Cloture comptabe (journaux de ventes, journaux de banques, journaux de caisse)'),
-- ('CODR013','COAP001','Honoraires des medecins'),
-- ('CODR014','COAP004','Creation de services'),
-- ('CODR015','COAP004','Suppression de services'),
-- ('CODR016','COAP004','Creation de profils'),
-- ('CODR017','COAP004','Suppression de profils'),
-- ('CODR018','COAP004','Creation utilisateurs'),
-- ('CODR019','COAP004','Suppression utilisateurs');

-- INSERT INTO Apps(codeApp, nomApp, descApp) VALUES
-- ('COAP001','GAP','Gestion administrative du patient'),
-- ('COAP002','DPI','Dossier patient informatisé'),
-- ('COAP003','PUI','Pharmacie à usage interne'),
-- ('COAP004','ADMIN','Administrateur du systeme');

INSERT INTO Profils(labelProfil, auteurProfil,dateProfil, codeApp) VALUES 
-- ('ALTEA ADMIN','koffiedy@gmail.com','23 avril 2020','COAP004');
('ALTEA DPI','koffiedy@gmail.com','23 avril 2020','COAP002');

-- INSERT INTO Droit_Profil(idProfil, codeDroit) VALUES
-- (1,'CODR014'),
-- (1,'CODR015'),
-- (1,'CODR016'),
-- (1,'CODR017'),
-- (1,'CODR018'),
-- (1,'CODR019');