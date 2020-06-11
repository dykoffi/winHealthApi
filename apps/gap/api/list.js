
//TODO : PATIENTS
exports.list_patient = {
    name: "list_patient",
    text: "SELECT idDossier, ippPatient, nomPatient, prenomsPatient, sexePatient, dateNaissancePatient, lieuNaissancePatient, nationalitePatient,habitationPatient, contactPatient, *  FROM gap.DossierAdministratif ORDER BY idDossier DESC LIMIT 20"
}
exports.details_patient = {
    name: "details_patient",
    text: `SELECT * FROM gap.DossierAdministratif WHERE idDossier=$1`
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
    text: `SELECT get_delai_controle($2) delai,  get_controle_sejour($2) nbcontrole, * FROM 
    gap.Factures, 
    general.Actes, 
    gap.Sejours, 
    general.Etablissement,
    gap.DossierAdministratif
    WHERE 
        sejourFacture=numeroSejour AND
        etablissementSejour=idEtablissement AND
        patientSejour=idDossier AND
        Sejours.idSejour=$1  
    `
}
exports.list_actes = {
    name: "list_actes",
    text: "SELECT * FROM general.Actes"
}

exports.list_actesSejour= {
    name: "list_actesSejour",
    text: "SELECT * FROM general.Actes WHERE codeActe IN ($1)"
}
//TODO : FACTURES
exports.list_all_factures = {
    name: "list_all_factures",
    text: `SELECT * FROM gap.Factures`
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
        Sejours.statusSejour='en attente' ORDER BY idFacture`
}
exports.details_facture = {
    name: "details_facture",
    text: `SELECT * FROM 
    gap.Factures, 
    gap.Sejours,
    gap.DossierAdministratif LEFT OUTER JOIN  gap.Comptes ON ipppatient=patientcompte
    WHERE
        patientSejour=idDossier AND
        sejourFacture=numeroSejour AND
        Sejours.statusSejour='en attente' AND
        numeroFacture=$1`
}
exports.imprimer_facture = {
    name: "imprimer_facture",
    text: `SELECT * FROM 
    gap.Factures, 
    general.Actes, 
    gap.Sejours,
    general.Etablissement,
    gap.DossierAdministratif
    WHERE 
        sejourFacture=numeroSejour AND
        etablissementSejour=idEtablissement AND
        patientSejour=idDossier AND
        idDossier=$1
    ORDER BY idFacture DESC LIMIT 1    
    `
}
exports.annuler_facture = {
    name: "annuler_facture",
    text: `UPDATE gap.Sejours SET  statusSejour='annulé' WHERE idSejour=$1`
}
exports.verify_facture = {
    name: "verify_facture",
    text: `SELECT * FROM 
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
    names:"list_controles",
    text:"SELECT * FROM controles"
}

//TODO : COMPTES 
exports.list_patient_no_compte = {
    name: "list_patient_no_compte",
    text: `SELECT * FROM 
            gap.DossierAdministratif LEFT OUTER JOIN gap.Comptes
            ON Comptes.patientCompte=DossierAdministratif.ipppatient
            WHERE patientCompte ISNULL`
}
exports.list_comptes = {
    name:'list_comptes',
    text:`SELECT * FROM gap.Comptes, gap.DossierAdministratif
        WHERE Comptes.patientCompte=DossierAdministratif.ippPatient ORDER BY idCompte`
}
exports.details_compte = {
    name:'details_comptes',
    text:`SELECT * FROM gap.Comptes, gap.DossierAdministratif
        WHERE Comptes.patientCompte=DossierAdministratif.ippPatient AND Comptes.numeroCompte=$1`
}

//TODO : BORDERAUX
exports.list_factures_by_assurances = {
    name : "list_factures_by_assurances",
    text : `SELECT * FROM `
}

//TODO : ASSURANCES
exports.list_assurances = {
    name : "list_assurances",
    text : `SELECT * FROM gap.Assurances`
}
exports.details_assurance = {
    name : "details_assurance",
    text : `SELECT * FROM gap.Assurances WHERE idAssurance=$1`
}