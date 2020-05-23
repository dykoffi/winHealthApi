exports.add_patient = {
    name: "add_patient",
    text: "INSERT INTO gap.DossierAdministratif (nomPatient,prenomsPatient,civilitePatient,sexePatient,dateNaissancePatient,lieuNaissancePatient,nationalitePatient,professionPatient,situationMatrimonialePatient,religionPatient,habitationPatient,contactPatient, nomPerePatient,prenomsPerePatient,contactPerePatient,nomMerePatient,prenomsMerePatient,contactMerePatient,nomTuteurPatient,prenomsTuteurPatient,contactTuteurPatient,nomPersonnesurePatient,prenomsPersonnesurePatient,contactPersonnesurePatient,qualitePersonnesurePatient,assure,assurance) VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27) RETURNING idDossier"
}

exports.add_sejour = {
    name: "add_sejour",
    text: `INSERT INTO gap.Sejours (
        dateDebutSejour,
        dateFinSejour,
        heureDebutSejour,
        heureFinSejour,
        statusSejour,
        typeSejour,
        patientSejour,
        etablissementSejour
        ) VALUES ($1,$2,$3,$4,$5,$6,$7,$8) RETURNING numeroSejour`
}

exports.add_facture = {
    name: "add_facture",
    text: `INSERT INTO gap.Factures (
        dateFacture,
        heureFacture,
        auteurFacture,
        montantTotalFacture,
        resteFacture,
        sejourFacture
        ) VALUES ($1,$2,$3,get_total_facture($4),get_total_facture($4),$4)`
}

exports.add_sejour_acte = {
    name:`add_sejour_acte`,
    text:`INSERT INTO gap.Sejour_Acte (
        numeroSejour,
        codeActe
    ) VALUES ($1,$2)`
}