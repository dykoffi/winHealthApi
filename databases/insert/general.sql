DELETE FROM general.Etablissement;
INSERT INTO general.Etablissement (
        regionEtabblissement,
        districtEtablissement,
        nomEtablissement,
        statusEtablissement,
        adresseEtablissement,
        codePostaleEtablissement,
        telEtablissement,
        faxEtablissement,
        emailEtablissement,
        sitewebEtablissement,
        logoEtablissement
    )
VALUES (
        'ABIDJAN 2',
        'DS COCODY-BINGERVILLE',
        'POLYCLINIQUE ALTEA',
        'Centre privée de soins',
        'Cocody angré 7ème tranche',
        'Abidjan BP 2014',
        '21 35 60 15',
        '21 55 96 35',
        'info@altea-ci.com',
        'www.altea.com',
        'logoAltea.jpeg'
    );