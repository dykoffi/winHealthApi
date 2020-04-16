INSERT INTO Users(nom, prenoms,contact,mail, poste, profil, app, pass) VALUES 
('CI','ALTEA','51 88 64 78','winhealth@altea-ci.com', 'Agent ALTEA', 'ADMIN','admin','@winhealth@');

INSERT INTO Droits(codeDroit, labelDroit) VALUES
('CODR001','Creation de patient'),
('CODR002','Creation de dossier administratif'),
('CODR003','Saisie d acte'),
('CODR004','Edition de facture'),
('CODR005','Encaissement'),
('CODR006','Modification d encaissement'),
('CODR007','Ventilation comptable'),
('CODR008','Validation administrative des dossiers'),
('CODR009','Generation envois bordereaux'),
('CODR010','Suivis bordereaux'),
('CODR011','Encaissement des mutuelles (assurances)'),
('CODR012','Cloture comptabe (journaux de ventes, journaux de banques, journaux de caisse)'),
('CODR013','Honoraires des medecins');

INSERT INTO Apps(codeApp, nomApp, descApp) VALUES
('COAP001','GAP','Gestion administrative du patient'),
('COAP002','DPI','Dossier patient informatisé'),
('COAP003','PUI','Pharmacie à usage interne'),
('COAP004','LIMS','Gestion du systeme d informatoins du laboratoire'),
('COAP005','RIS','Systeme d information de la radiologie'),
('COAP006','ADMIN','Administrateur du systeme');

