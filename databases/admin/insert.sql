DELETE FROM Apps;
DELETE FROM Droits;
DELETE FROM Droit_Profil;
DELETE FROM Profils;
DELETE FROM Users;

INSERT INTO Apps(codeApp, nomApp, descApp) VALUES
('COAP001','GAP','Gestion administrative du patient'),
('COAP002','DPI','Dossier patient informatisé'),
('COAP003','PUI','Pharmacie à usage interne'),
('COAP004','ADMIN','Administrateur du systeme');

INSERT INTO Droits(codeDroit,codeApp, labelDroit) VALUES
('CODR001','COAP001','Creation de patient'),
('CODR002','COAP001','Creation de dossier administratif'),
('CODR003','COAP001','Saisie d acte'),
('CODR004','COAP001','Edition de facture'),
('CODR005','COAP001','Encaissement'),
('CODR006','COAP001','Modification d encaissement'),
('CODR007','COAP001','Ventilation comptable'),
('CODR008','COAP001','Validation administrative des dossiers'),
('CODR009','COAP001','Generation envois bordereaux'),
('CODR010','COAP001','Suivis bordereaux'),
('CODR011','COAP001','Encaissement des mutuelles (assurances)'),
('CODR012','COAP001','Cloture comptabe (journaux de ventes, journaux de banques, journaux de caisse)'),
('CODR013','COAP001','Honoraires des medecins'),
('CODR014','COAP004','Creation de services'),
('CODR015','COAP004','Suppression de services'),
('CODR016','COAP004','Creation de profils'),
('CODR017','COAP004','Suppression de profils'),
('CODR018','COAP004','Creation utilisateurs'),
('CODR019','COAP004','Suppression utilisateurs');

INSERT INTO Droit_Profil(idProfil, codeDroit) VALUES
(1,'CODR014'),
(1,'CODR015'),
(1,'CODR016'),
(1,'CODR017'),
(1,'CODR018'),
(1,'CODR019');

INSERT INTO Profils(labelProfil, auteurProfil,dateProfil, codeApp) VALUES 
('ALTEA ADMIN','koffiedy@gmail.com','23 avril 2020','COAP004'),
('ALTEA DPI','koffiedy@gmail.com','23 avril 2020','COAP002');

INSERT INTO Users(nomUser, prenomsUser,contactUser,mailUser, posteUser, profilUser, codeapp,loginUser, passUser) VALUES 
('ALTEA','CI','51 88 64 78','winhealth@altea-ci.com', 'Agent ALTEA', 1,'COAP004','admin',md5('admin')),
('Edy','Koffi','51 88 64 78','winhealth@altea-ci.com', 'Agent ALTEA DPI', 2,'COAP002','dpi',md5('admin')),

('GBADJE','Wilfried','51 88 64 78','wilfried@altea-ci.com', 'Infirmier', 2,'COAP002','wilfried',md5('admin')),
('Abdoul','N DONGO','51 88 64 78','abdoulaye@altea-ci.com', 'Medecin', 2,'COAP002','abdoul',md5('admin')),

('Audrey','BOGUI','51 88 64 78','audrey@altea-ci.com', 'Caissière', 1,'COAP001','audrey',md5('admin')),
('Yasser','Diakité','51 88 64 78','yasser@altea-ci.com', 'Secretaire', 1,'COAP001','yasser',md5('admin'));
