INSERT INTO Users(nomUser, prenomsUser,contactUser,mailUser, posteUser, profilUser, codeapp, passUser) VALUES 
('ALTEA','CI','51 88 64 78','winhealth@altea-ci.com', 'Agent ALTEA', 'ADMIN','COAP004','@winhealth@');

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
('CODR013','COAP001','Honoraires des medecins');

INSERT INTO Apps(codeApp, nomApp, descApp) VALUES
('COAP001','GAP','Gestion administrative du patient'),
('COAP002','DPI','Dossier patient informatisé'),
('COAP003','PUI','Pharmacie à usage interne'),
('COAP004','ADMIN','Administrateur du systeme');

