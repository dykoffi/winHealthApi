//TODO : PATIENTS
exports.list_patient = {
    name: "list_patient",
    text: "SELECT idDossier, ippPatient, nomPatient, prenomsPatient, sexePatient, dateNaissancePatient, lieuNaissancePatient, nationalitePatient,habitationPatient, contactPatient, *  FROM gap.DossierAdministratif ORDER BY nomPatient, prenomsPatient"
}
exports.details_patient = {
    name: "details_patient",
    text: `SELECT * FROM gap.DossierAdministratif WHERE ipppatient=$1`
}
exports.dossiers_patient = {
    name: "dossiers_patient",
    text: `SELECT * FROM general.DossierAdministratif`
}

//TODO : SEJOURS
exports.list_sejours = {
    name: "list_sejours",
    text: `SELECT * FROM gap.Sejours WHERE patientSejour=$1 ORDER BY idSejour DESC`
}
exports.details_sejour = {
    name: "details_sejour",
    text: `SELECT get_delai_controle($1) delai, get_controle_sejour($1) nbcontrole, * FROM 
    gap.Factures F, 
    gap.Sejour_Acte SA,
    general.Actes A, 
    gap.Sejours S, 
    general.Etablissement E,
    gap.DossierAdministratif D LEFT JOIN gap.Comptes ON patientCompte=ippPatient
    WHERE 
        F.sejourFacture=S.numeroSejour AND
        S.etablissementSejour=E.idEtablissement AND
        S.patientSejour=D.idDossier AND
        S.numeroSejour=SA.numeroSejour AND
        A.codeActe=SA.codeActe AND
        S.numeroSejour=$1  AND
        F.typeFacture='original'
    `
}
exports.list_actes = {
    name: "list_actes",
    text: "SELECT * FROM general.Actes"
}

exports.list_actesSejour = {
    name: "list_actesSejour",
    text: "SELECT * FROM general.Actes WHERE codeActe IN ($1)"
}
//TODO : FACTURES
exports.list_all_factures = {
    name: "list_all_factures",
    text: `SELECT * FROM 
    gap.Factures, 
    gap.Sejours,
    gap.DossierAdministratif
    WHERE 
        patientSejour=idDossier AND
        sejourFacture=numeroSejour AND
        typeFacture='original'
        ORDER BY idFacture`
}

exports.list_factures_avoir = {
    name: "list_factures_avoir",
    text: `SELECT * FROM 
    gap.Factures, 
    gap.Sejours,
    gap.DossierAdministratif
    WHERE 
        patientSejour=idDossier AND
        sejourFacture=numeroSejour AND
        typeFacture='avoir'
        ORDER BY idFacture`
}

exports.list_factures_attentes = {
    name: "list_factures_attentes",
    text: `SELECT * FROM 
    gap.Factures, 
    gap.Sejours,
    gap.DossierAdministratif
    WHERE 
        patientSejour=idDossier AND
        sejourFacture=numeroSejour AND
        restePatientFacture<>0 AND
        typeFacture='original'
        ORDER BY idFacture`
}

exports.list_factures_patient = {
    name: "list_factures_patient",
    text: `SELECT * FROM 
    gap.Factures, 
    gap.Sejours,
    gap.DossierAdministratif
    WHERE 
        patientSejour=idDossier AND
        sejourFacture=numeroSejour AND
        ipppatient=$1 AND
        typeFacture='original'
        ORDER BY idFacture`
}

exports.list_factures_payees_patient = {
    name: "list_factures_payees_patient",
    text: `SELECT * FROM 
    gap.Factures, 
    gap.Sejours,
    gap.DossierAdministratif
    WHERE 
        patientSejour=idDossier AND
        sejourFacture=numeroSejour AND
        restePatientFacture=0 AND
        ipppatient=$1 AND
        typeFacture='original'
        ORDER BY idFacture`
}

exports.list_factures_impayees_patient = {
    name: "list_factures_impayees_patient",
    text: `SELECT * FROM 
    gap.Factures, 
    gap.Sejours,
    gap.DossierAdministratif
    WHERE 
        patientSejour=idDossier AND
        sejourFacture=numeroSejour AND
        restePatientFacture<>0 AND
        ipppatient=$1 AND
        typeFacture='original'
        ORDER BY idFacture`
}

exports.verify_compte = {
    name: "verify_facture",
    text: `SELECT * FROM gap.DossierAdministratif LEFT OUTER JOIN  gap.Comptes ON ipppatient=patientcompte WHERE ipppatient=$1`
}

exports.details_facture = {
    name: "details_facture",
    text: `
    SELECT *,get_montant_davoir(numeroFacture) montantAvoir FROM 
        gap.Factures Fa,
        gap.Sejours S,
        gap.DossierAdministratif D LEFT OUTER JOIN  
        gap.Comptes C ON ipppatient=patientcompte 
    WHERE
        patientSejour=idDossier AND
        Fa.sejourFacture=numeroSejour AND
        S.statusSejour='en attente' AND
        Fa.numeroFacture=$1 AND
        Fa.typeFacture='original'`
}

exports.imprimer_facture = {
    name: "imprimer_facture",
    text: `
    SELECT * FROM 
        gap.Factures,
        general.Actes, 
        gap.Sejours,
        general.Etablissement,
        gap.DossierAdministratif
        LEFT JOIN gap.Comptes ON patientCompte=ippPatient
    WHERE 
        sejourFacture=numeroSejour AND
        etablissementSejour=idEtablissement AND
        patientSejour=idDossier AND
        ippPatient=$1 AND
        typeFacture='original'
    ORDER BY idFacture DESC LIMIT 1   
    `
}
exports.annuler_facture = {
    name: "annuler_facture",
    text: `UPDATE gap.Sejours SET  statusSejour='annulé' WHERE idSejour=$1`
}
exports.verify_facture = {
    name: "verify_facture",
    text: `
    SELECT * FROM 
        gap.Factures, 
        general.Actes, 
        gap.Sejours, 
        general.Etablissement,
        gap.DossierAdministratif
    WHERE 
        acteFacture=codeActe AND
        factureSejour=idFacture AND
        etablissementSejour=idEtablissement AND
        patientSejour=idDossier AND
        idFacture=$1
    `
}

//TODO : CONTROLES
exports.list_controles = {
    names: "list_controles",
    text: "SELECT * FROM controles"
}

//TODO : COMPTES 
exports.list_patient_no_compte = {
    name: "list_patient_no_compte",
    text: `
    SELECT * FROM 
        gap.DossierAdministratif LEFT OUTER JOIN gap.Comptes
        ON Comptes.patientCompte=DossierAdministratif.ipppatient
        WHERE patientCompte ISNULL`
}
exports.list_comptes = {
    name: 'list_comptes',
    text: `
    SELECT * FROM 
        gap.Comptes, gap.DossierAdministratif
    WHERE 
        Comptes.patientCompte=DossierAdministratif.ippPatient 
    ORDER BY nomPatient, prenomsPatient, idCompte`
}
exports.details_compte = {
    name: 'details_comptes',
    text: `
    SELECT * FROM 
        gap.Comptes, gap.DossierAdministratif
    WHERE 
        Comptes.patientCompte=DossierAdministratif.ippPatient AND 
        Comptes.numeroCompte=$1`
}

//TODO : BORDERAUX
exports.list_factures_assurances = {
    name: "list_factures_assurances",
    text: `SELECT * FROM 
    gap.Factures, 
    gap.Sejours,
    gap.DossierAdministratif
    WHERE 
        patientSejour=idDossier AND
        sejourFacture=numeroSejour AND
        gestionnaire <> '' AND
        typeFacture='original'
        ORDER BY idFacture`
}
//1
exports.list_factures_for_all_assurance_garant_typesejour = {
    name: "list_factures_for_all_assurance_garant_typesejour",
    text: `
    SELECT *, F.numeroFacture nbfacture FROM
        gap.Sejours,
        gap.Assurances,
        gap.DossierAdministratif,
        gap.Factures F LEFT OUTER JOIN gap.Bordereau_Factures B ON F.numeroFacture=B.numeroFacture
    WHERE
        F.sejourFacture = Sejours.numeroSejour AND
        Sejours.gestionnaire = Assurances.nomAssurance AND
        DossierAdministratif.idDossier = Sejours.patientSejour AND
        F.dateFacture::date >= $1::date AND 
        F.dateFacture::date <= $2::date AND
        typeFacture='original'
        `
}

//2
exports.list_factures_for_all_assurance_garant = {
    name: "list_factures_for_all_assurance_garant",
    text: `
     SELECT *, F.numeroFacture nbfacture FROM
        gap.Sejours,
        gap.Assurances,
        gap.DossierAdministratif,
        gap.Factures F LEFT OUTER JOIN gap.Bordereau_Factures B ON F.numeroFacture=B.numeroFacture
    WHERE
        F.sejourFacture = Sejours.numeroSejour AND
        Sejours.gestionnaire = Assurances.nomAssurance AND
        DossierAdministratif.idDossier = Sejours.patientSejour AND
        F.dateFacture::date >= $1::date AND F.dateFacture::date <= $2::date AND
        Sejours.typesejour = $3 AND
        typeFacture='original'
        `
}
//3
exports.list_factures_for_all_assurance_typesejour = {
    name: "list_factures_for_all_assurance_typesejour",
    text: ` SELECT *, F.numeroFacture nbfacture FROM
        gap.Sejours,
        gap.Assurances,
        gap.DossierAdministratif,
        gap.Factures F LEFT OUTER JOIN gap.Bordereau_Factures B ON F.numeroFacture=B.numeroFacture
            WHERE
                F.sejourFacture = Sejours.numeroSejour AND
                Sejours.gestionnaire = Assurances.nomAssurance AND
                DossierAdministratif.idDossier = Sejours.patientSejour AND
                F.dateFacture::date >= $1::date AND F.dateFacture::date <= $2::date AND
                Sejours.organisme = $3 AND
                typeFacture='original'
        `
}

//4
exports.list_factures_for_all_assurance = {
    name: "list_factures_for_all_assurance",
    text: ` SELECT *, F.numeroFacture nbfacture FROM
        gap.Sejours,
        gap.Assurances,
        gap.DossierAdministratif,
        gap.Factures F LEFT OUTER JOIN gap.Bordereau_Factures B ON F.numeroFacture=B.numeroFacture
            WHERE
                F.sejourFacture = Sejours.numeroSejour AND
                Sejours.gestionnaire = Assurances.nomAssurance AND
                DossierAdministratif.idDossier = Sejours.patientSejour AND
                F.dateFacture::date >= $1::date AND F.dateFacture::date <= $2::date AND
                Sejours.organisme = $3 AND
                Sejours.typeSejour = $4 AND
                typeFacture='original'
        `
}

//5
exports.list_factures_for_all_garant_typesejour = {
    name: "list_factures_for_all_garant_typesejour",
    text: ` SELECT *, F.numeroFacture nbfacture FROM
        gap.Sejours,
        gap.Assurances,
        gap.DossierAdministratif,
        gap.Factures F LEFT OUTER JOIN gap.Bordereau_Factures B ON F.numeroFacture=B.numeroFacture
            WHERE
                F.sejourFacture = Sejours.numeroSejour AND
                Sejours.gestionnaire = Assurances.nomAssurance AND
                DossierAdministratif.idDossier = Sejours.patientSejour AND
                F.dateFacture::date >= $1::date AND F.dateFacture::date <= $2::date AND
                Sejours.gestionnaire = $3 AND
                typeFacture='original'
        `
}

//6

exports.list_factures_for_all_garant = {
    name: "list_factures_for_all_garant",
    text: ` SELECT *, F.numeroFacture nbfacture FROM
        gap.Sejours,
        gap.Assurances,
        gap.DossierAdministratif,
        gap.Factures F LEFT OUTER JOIN gap.Bordereau_Factures B ON F.numeroFacture=B.numeroFacture
            WHERE
                F.sejourFacture = Sejours.numeroSejour AND
                Sejours.gestionnaire = Assurances.nomAssurance AND
                DossierAdministratif.idDossier = Sejours.patientSejour AND
                F.dateFacture::date >= $1::date AND F.dateFacture::date <= $2::date AND
                Sejours.gestionnaire = $3 AND
                Sejours.typeSejour = $4 AND
                typeFacture='original'
        `
}

//7
exports.list_factures_for_all_typesejour = {
    name: "list_factures_for_all_typesejour",
    text: ` SELECT *, F.numeroFacture nbfacture FROM
        gap.Sejours,
        gap.Assurances,
        gap.DossierAdministratif,
        gap.Factures F LEFT OUTER JOIN gap.Bordereau_Factures B ON F.numeroFacture=B.numeroFacture
            WHERE
                F.sejourFacture = Sejours.numeroSejour AND
                Sejours.gestionnaire = Assurances.nomAssurance AND
                DossierAdministratif.idDossier = Sejours.patientSejour AND
                F.dateFacture::date >= $1::date AND 
                F.dateFacture::date <= $2::date AND
                Sejours.gestionnaire = $3 AND
                Sejours.organisme = $4 AND
                typeFacture='original'
        `
}

//8
exports.list_factures_by_assurance_garant_typesejour = {
    name: "list_factures_by_assurance_garant_typesejour",
    text: ` SELECT *, F.numeroFacture nbfacture FROM
        gap.Sejours,
        gap.Assurances,
        gap.DossierAdministratif,
        gap.Factures F LEFT OUTER JOIN gap.Bordereau_Factures B ON F.numeroFacture=B.numeroFacture
            WHERE
                F.sejourFacture = Sejours.numeroSejour AND
                Sejours.gestionnaire = Assurances.nomAssurance AND
                DossierAdministratif.idDossier = Sejours.patientSejour AND
                F.dateFacture::date >= $1::date AND F.dateFacture::date <= $2::date AND
                Sejours.gestionnaire = $3 AND
                Sejours.organisme = $4 AND
                Sejours.typeSejour = $5 AND
                typeFacture='original'
        `
}

// 
exports.list_bordereaux = {
    name: 'list_bordereaux',
    text: `
        SELECT B.numeroBordereau,
        datecreationbordereau,
        datelimitebordereau,
        typesejourbordereau,
        statutbordereau,
        gestionnairebordereau,
        organismebordereau,
        montanttotal,
        partassurance,
        partpatient,
        COUNT(*) nbFacture
    FROM gap.Bordereaux B
        INNER JOIN gap.Bordereau_factures BF ON B.numeroBordereau = BF.numeroBordereau
    GROUP BY B.numeroBordereau,
        datecreationbordereau,
        datelimitebordereau,
        typesejourbordereau,
        statutbordereau,
        gestionnairebordereau,
        organismebordereau,
        montanttotal,
        partassurance,
        partpatient
        ORDER BY B.numeroBordereau
    `
}

exports.list_bordereaux_by_type = {
    name: "list_bordereaux_by_type",
    text: `SELECT * FROM gap.Bordereaux WHERE statutBordereau=$1 ORDER BY numeroBordereau`
}

exports.details_bordereau = {
    name: 'details_bordereau',
    text: `SELECT * FROM gap.Bordereaux B
        INNER JOIN gap.Bordereau_factures BF ON B.numeroBordereau=BF.numeroBordereau 
        INNER JOIN gap.Factures F ON BF.numeroFacture=F.numeroFacture 
        INNER JOIN gap.Sejours S ON S.numeroSejour=F.sejourFacture 
        INNER JOIN gap.DossierAdministratif D ON S.patientSejour=D.idDossier 
        WHERE B.numeroBordereau=$1`
}

//

//TODO : ASSURANCES
exports.list_assurances = {
    name: "list_assurances",
    text: `SELECT * FROM gap.Assurances ORDER BY nomAssurance`
}
exports.details_assurance = {
    name: "details_assurance",
    text: `SELECT * FROM gap.Assurances WHERE idAssurance=$1`
}

exports.list_encaissements = {
    name: 'list_encaissements',
    text: 'SELECT * FROM gap.Encaissements'
}

exports.details_encaissement = {
    name: "details_encaissement",
    text: `SELECT * FROM gap.Encaissements WHERE numeroEncaissement = $1`
}

//LOGS
exports.list_gap_logs = {
    name: 'list_gap_logs',
    text: `SELECT * FROM admin.Logs WHERE app = 'COAP001'`
}

exports.list_gap_logs_users = {
    name: 'list_gap_logs_users',
    text: `SELECT DISTINCT(auteurLog) FROM admin.Logs WHERE app = 'COAP001'`
}