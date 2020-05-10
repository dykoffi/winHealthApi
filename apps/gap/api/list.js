exports.list_patient = {
    name : "list_patient",
    text : "SELECT idDossier, ippPatient, nomPatient, prenomsPatient, sexePatient, dateNaissancePatient, lieuNaissancePatient, nationalitePatient,habitationPatient, contactPatient  FROM gap.DossierAdministratif ORDER BY idDossier DESC LIMIT 20"
}

exports.search_patient = {
    name : "search_patient",
    text : `SELECT 
    idDossier,
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


exports.details_patient = {
    name :"details_patient",
    text : `SELECT * FROM gap.DossierAdministratif WHERE idDossier=$1`
}

exports.dossiers_patient = {
    name :"dossiers_patient",
    text : `SELECT * FROM general.DossierAdministratif`
}

exports.list_sejours = {
    name:"list_sejours",
    text : `SELECT * FROM gap.Sejours WHERE patientSejour = $1`
}