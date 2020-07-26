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
        numeroFacture  ~* $1`
}

//TODO : SEJOURS
exports.search_sejour = {
    name: "search_sejour",
    text: ``
}

//TODO : COMPTES
exports.search_compte = {
    name: "search_compte",
    text: `SELECT * FROM gap.DossierAdministratif LEFT OUTER JOIN  gap.Comptes ON ipppatient=patientcompte WHERE numeroCompte ~* $1`
}

//TODO : ASSURANCES
exports.search_assurance = {
    name: "search_assurance",
    text: `SELECT * FROM gap.Assurances WHERE nomAssurance ~* $1`
}

//1
exports.search_bordereaux_for_all_assurance_garant_typesejour = {
    name: "search_bordereaux_for_all_assurance_garant_typesejour",
    text: `SELECT * FROM 
        gap.bordereaux
    WHERE
        Bordereaux.dateCreationBordereau::date >= $1::date AND 
        Bordereaux.dateCreationBordereau::date <= $2::date 
        `
}

//2
exports.search_bordereaux_for_all_assurance_garant = {
    name: "search_bordereaux_for_all_assurance_garant",
    text: `SELECT * FROM 
        gap.bordereaux
    WHERE
        Bordereaux.dateCreationBordereau::date >= $1::date AND 
        Bordereaux.dateCreationBordereau::date <= $2::date AND
        Bordereaux.typeSejourBordereau = $3
        `
}
//3
exports.search_bordereaux_for_all_assurance_typesejour = {
    name: "search_bordereaux_for_all_assurance_typesejour",
    text: `SELECT * FROM 
        gap.bordereaux
    WHERE
        Bordereaux.dateCreationBordereau::date >= $1::date AND 
        Bordereaux.dateCreationBordereau::date <= $2::date AND
        Bordereaux.organismeBordereau = $3
        `
}

//4
exports.search_bordereaux_for_all_assurance = {
    name: "search_bordereaux_for_all_assurance",
    text: `SELECT * FROM 
        gap.bordereaux
    WHERE
        Bordereaux.dateCreationBordereau::date >= $1::date AND 
        Bordereaux.dateCreationBordereau::date <= $2::date AND
        Bordereaux.organismeBordereau = $3 AND
        Bordereaux.typeSejourBordereau = $4
    `
}

//5
exports.search_bordereaux_for_all_garant_typesejour = {
    name: "search_bordereaux_for_all_garant_typesejour",
    text: `SELECT * FROM 
        gap.bordereaux
    WHERE
        Bordereaux.dateCreationBordereau::date >= $1::date AND 
        Bordereaux.dateCreationBordereau::date <= $2::date AND
        Bordereaux.gestionnaireBordereau = $3
`
}

//6

exports.search_bordereaux_for_all_garant = {
    name: "search_bordereaux_for_all_garant",
    text: `SELECT * FROM 
        gap.bordereaux
    WHERE
        Bordereaux.dateCreationBordereau::date >= $1::date AND 
        Bordereaux.dateCreationBordereau::date <= $2::date AND
        Bordereaux.gestionnaireBordereau = $3 AND
        Bordereaux.typeSejourBordereau = $4
        `
}

//7
exports.search_bordereaux_for_all_typesejour = {
    name: "search_bordereaux_for_all_typesejour",
    text: `SELECT * FROM 
        gap.bordereaux
    WHERE
        Bordereaux.dateCreationBordereau::date >= $1::date AND 
        Bordereaux.dateCreationBordereau::date <= $2::date AND
        Bordereaux.gestionnaireBordereau = $3 AND
        Bordereaux.organismeBordereau = $4
        `
}

//8
exports.search_bordereaux_by_assurance_garant_typesejour = {
    name: "search_bordereaux_by_assurance_garant_typesejour",
    text: `SELECT * FROM 
        gap.bordereaux
    WHERE
        Bordereaux.dateCreationBordereau::date >= $1::date AND 
        Bordereaux.dateCreationBordereau::date <= $2::date AND
        Bordereaux.gestionnaireBordereau = $3 AND
        Bordereaux.organismeBordereau = $4 AND
        Bordereaux.typeSejourBordereau = $5
        `
}
