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
        'Pr TEA',
        'ZEKOU BASILIDE',
        '51 88 64 78',
        '',
        'MEDECIN ORL',
        'ORL-CHIRURGIEN-CERVICO-FACIAL',
        'Admin_GAP',
        'tea',
        md5('tea@medecin')
    ),(
        'Pr N GOUAN',
        'JEAN LICHEL',
        '51 88 64 78',
        'edy@altea-ci.com',
        'Agent ALTEA GAP',
        'Assistance',
        'Admin_GAP',
        'edy',
        md5('admin')
    ),(
        'KOFFI',
        'Edy',
        '51 88 64 78',
        'edy@altea-ci.com',
        'Agent ALTEA GAP',
        'Assistance',
        'Admin_GAP',
        'edy',
        md5('admin')
    );