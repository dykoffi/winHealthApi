//TODO : PATIENTS
exports.search_patient = {
    name: "search_patient",
    text: `SELECT 
    idDossier,
    civilitepatient,
    ippPatient,
    nomPatient, 
    prenomsPatient,
    sexePatient,
    dateNaissancePatient,
    lieuNaissancePatient, 
    nationalitePatient,
    habitationPatient,
    contactPatient  
    FROM gap.DossierAdministratif WHERE 
    nomPatient||' '||prenomsPatient ~* $1 OR 
    prenomsPatient||' '||nomPatient ~* $1 OR  
    prenomsPatient||' '||nomPatient||' '|| dateNaissancePatient ~* $1 OR
    nomPatient||' '||prenomsPatient||' '|| dateNaissancePatient ~* $1 OR
    prenomsPatient||' '|| dateNaissancePatient ~* $1 OR
    nomPatient||' '|| dateNaissancePatient ~* $1 OR
    dateNaissancePatient ~* $1
    ORDER BY idDossier DESC`
}

//TODO : FACTURES
exports.search_facture = {
    name: "research_facture",
    text: `SELECT * FROM
    gap.Factures, 
    gap.Sejours,
    gap.DossierAdministratif
    WHERE 
        patientSejour=idDossier AND
        sejourFacture=numeroSejour AND
        Sejours.statusSejour='en attente' AND
        numeroFacture  ~* $1`
}

//TODO : SEJOURS
exports.search_sejour = {
    name : "search_sejour",
    text : ``
}

//TODO : COMPTES
exports.search_compte = {
    name : "search_compte",
    text : ``
}

//TODO : ASSURANCES
exports.search_assurance = {
    name : "search_assurance",
    text : `SELECT * FROM gap.Assurances WHERE nomAssurance ~* $1`
}

