exports.list_attente_patients = {
    name: "list_attente_patient",
    text: `SELECT 
    idDossier, 
    ippPatient, 
    nomPatient, 
    prenomsPatient, 
    sexePatient, 
    dateNaissancePatient, 
    lieuNaissancePatient, 
    nationalitePatient,
    habitationPatient, 
    contactPatient,
    typeSejour,
    idSejour,
    dateFacture,
    heureFacture
    FROM gap.DossierAdministratif, gap.Sejours, gap.Factures WHERE 
    Sejours.patientSejour=iddossier AND
    Sejours.statusSejour='validé' AND
    Sejours.FactureSejour=idFacture
    ORDER BY idSejour ASC
    `
}

exports.list_consultations = {
    name: "list_consultations",
    text: `SELECT * FROM dpi.Consultations, gap.Sejours 
    WHERE
     sejourConsultation=idSejour AND 
     patientSejour=$1
    `
}

exports.list_constantes = {
    name: "list_constantes",
    text: `SELECT * FROM dpi.constantes, gap.sejours 
    WHERE idsejour=sejourconstante AND patientsejour=$1 
    ORDER BY idConstante DESC`
}

exports.list_last_constante = {
    name: "list_last_constante",
    text: `SELECT * FROM dpi.constantes, gap.sejours 
    WHERE idsejour=sejourconstante AND patientsejour=$1 
    ORDER BY idConstante DESC`
}

exports.valider_constantes = {
    name: "valider_constantes",
    text: `UPDATE gap.Sejours SET  statusSejour='medecin' WHERE idSejour=$1`
}