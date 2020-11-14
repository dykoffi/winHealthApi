DELETE FROM admin.Users CASCADE;
DELETE FROM admin.Profils CASCADE;
DELETE FROM admin.Apps CASCADE;
INSERT INTO admin.Apps(codeApp, nomApp, descApp)
VALUES (
        'COAP001',
        'GAP',
        'Gestion administrative du patient'
    ),
    ('COAP002', 'DPI', 'Dossier patient informatisé'),
    ('COAP003', 'PUI', 'Pharmacie à usage interne'),
    ('COAP004', 'ADMIN', 'Administrateur du systeme');
INSERT INTO admin.Profils (
        labelProfil,
        codeApp,
        permissionsProfil
    )
VALUES (
        'Admin_GAP',
        'COAP001',
        '{"nomapp":"GAP","functions":[{"name":"Accueil","subfunctions":[]},{"name":"Admission","subfunctions":[{"target":"listPatient"},{"target":"dossiersPatient"}]},{"name":"Caisse","subfunctions":[{"target":"attenteFacture"},{"target":"patientFacture"},{"target":"avoirFacture"},{"target":"compte"}]},{"name":"Statistiques","subfunctions":[{"target":"bordereaux"}]},{"name":"Assurance","subfunctions":[{"target":"listeAssurances"},{"target":"facturesRecues"},{"target":"facturesValides"},{"target":"bordereaux"}]}]}'
    ),
    (
        'Admission',
        'COAP001',
        '{"nomapp":"GAP","functions":[{"name":"Accueil","subfunctions":[]},{"name":"Admission","subfunctions":[{"target":"listPatient"},{"target":"dossiersPatient"}]}]}'
    ),
    (
        'Caisse',
        'COAP001',
        '{"nomapp":"GAP","functions":[{"name":"Accueil","subfunctions":[]},{"name":"Caisse","subfunctions":[{"target":"attenteFacture"},{"target":"patientFacture"},{"target":"avoirFacture"},{"target":"compte"}]}]}'
    ),
    (
        'Facturation',
        'COAP001',
        '{"nomapp":"GAP","functions":[{"name":"Accueil","subfunctions":[]},{"name":"Statistiques","subfunctions":[{"target":"bordereaux"}]},{"name":"Assurance","subfunctions":[{"target":"listeAssurances"},{"target":"facturesRecues"},{"target":"facturesValides"},{"target":"bordereaux"}]}]}'
    ),
    (
        'Statistique',
        'COAP001',
        '{"nomapp":"GAP","functions":[{"name":"Accueil","subfunctions":[]},{"name":"Statistiques","subfunctions":[{"target":"bordereaux"}]},{"name":"Assurance","subfunctions":[{"target":"listeAssurances"},{"target":"facturesRecues"},{"target":"facturesValides"}]}]}'
    ),
    (
        'Admin',
        'COAP004',
        '{"nomapp":"ADMIN","functions":[{"name":"Accueil","subfunctions":[]},{"name":"Statistiques","subfunctions":[{"target":"bordereaux"}]},{"name":"Assurance","subfunctions":[{"target":"listeAssurances"},{"target":"facturesRecues"},{"target":"facturesValides"}]}]}'
    );
INSERT INTO admin.Users(
        nomUser,
        prenomsUser,
        contactUser,
        mailUser,
        posteUser,
        serviceUser,
        profilUser,
        loginUser,
        passUser
    )
VALUES (
        'KOFFI',
        'Edy',
        '51 88 64 78',
        'edy@altea-ci.com',
        'Agent ALTEA GAP',
        'Assistance',
        'Admin',
        'edy',
        md5('admin')
    ),
    (
        'GBADJE',
        'Wilfried',
        '53 26 58 95',
        'wilfried@altea-ci.com',
        'Agent ALTEA GAP',
        'Assistance',
        'Caisse',
        'wilfried',
        md5('admin')
    ),
    (
        'BOGUI',
        'Audrey',
        '48 56 25 98',
        'audrey@altea-ci.com',
        'Agent ALTEA GAP',
        'Assistance',
        'Admission',
        'audrey',
        md5('admin')
    ),
    (
        'N DONGO',
        'Abdoulaye',
        '01 54 52 56',
        'abdoul@altea-ci.com',
        'Agent ALTEA GAP',
        'Assistance',
        'Facturation',
        'abdoul',
        md5('admin')
    ),
    (
        'KEBE',
        'Almamy',
        '21 45 85 89',
        'almamy@altea-ci.com',
        'Agent ALTEA GAP',
        'Assistance',
        'Statistique',
        'almamy',
        md5('admin')
    );