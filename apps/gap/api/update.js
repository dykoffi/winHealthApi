//TODO : FACTURES
exports.update_patient_facture = {
    name: "update_patient_facture",
    text: `UPDATE gap.Factures SET restePatientFacture=get_reste_patient((SELECT sejourFacture FROM gap.Factures WHERE numeroFacture=$1),$1) WHERE numeroFacture=$1 RETURNING sejourFacture`
}
exports.update_assurance_facture = {
    name: "update_assurance_facture",
    text: `UPDATE gap.Factures SET resteAssuranceFacture=get_reste_assurance((SELECT sejourFacture FROM gap.Factures WHERE numeroFacture=$1),$1) WHERE numeroFacture=$1`
}

exports.update_reste_encaissement = {
    name: "update_reste_encaissement",
    text: `UPDATE gap.Encaissements SET resteEncaissement=resteEncaissement-$2::INT WHERE numeroEncaissement=$1`
}

//TODO : COMPTE
exports.update_compte = {
    name: 'update_compte',
    text: `UPDATE gap.Comptes SET montantCompte=get_montant_compte($1) WHERE numeroCompte=$1`
}

exports.update_assurance = {
    name: 'update_assurance',
    text: `UPDATE gap.Assurances SET 
        nomAssurance=$1,
        codeAssurance = $2,
        typeAssurance = $3,
        faxAssurance = $4,
        telAssurance = $5,
        mailAssurance = $6,
        localAssurance = $7,
        siteAssurance = $8
         WHERE idAssurance=$9`
}

exports.update_patient = {
    name: "modif_patient",
    text: `UPDATE gap.DossierAdministratif SET 
    nomPatient = $1,
    prenomsPatient =$2,
    civilitePatient =$3,
    sexePatient =$4,
    dateNaissancePatient =$5,
    lieuNaissancePatient =$6,
    nationalitePatient =$7,
    professionPatient =$8,
    situationMatrimonialePatient =$9,
    religionPatient =$10,
    habitationPatient =$11,
    contactPatient =$12,
     nomPerePatient =$13,
    prenomsPerePatient =$14,
    contactPerePatient =$15,
    nomMerePatient =$16,
    prenomsMerePatient =$17,
    contactMerePatient =$18,
    nomTuteurPatient =$19,
    prenomsTuteurPatient =$20,
    contactTuteurPatient =$21,
    nomPersonnesurePatient =$22,
    prenomsPersonnesurePatient =$23,
    contactPersonnesurePatient =$24,
    qualitePersonnesurePatient =$25 WHERE ipppatient=$26 RETURNING idDossier, *`
}

exports.retrait_facture_recue = {
    name: "retrait_facture_recue",
    text: `UPDATE gap.Factures SET statutfacture='attente' WHERE numeroFacture=$1`
}

exports.retrait_facture_valide = {
    name: "retrait_facture_valide",
    text: `UPDATE gap.Factures SET statutfacture='recu' WHERE numeroFacture=$1`
}

exports.retrait_facture_bordereau = {
    name: "retrait_facture_bordereau",
    text: `UPDATE gap.Factures SET statutfacture='recu' WHERE numeroFacture=$1`
}

exports.update_sejour_assurance = {
    name: 'update_sejour_assurance',
    text: `
        UPDATE gap.Sejours SET 
            gestionnaire=$1,
            organisme=$2,
            beneficiaire=$3,
            matriculeAssure=$4,
            assurePrinc=$5,
            numeroPEC=$6,
            taux=$7 WHERE numeroSejour=$8
    `
}

exports.update_facture = {
    name: "update_facture",
    text: `UPDATE gap.Factures SET
        partAssuranceFacture=get_part_assurance($1),
        resteAssuranceFacture=get_reste_assurance($1,$2),
        partPatientFacture=get_part_patient($1),
        restePatientFacture=get_reste_patient($1,$2)
        WHERE sejourFacture=$1
    `
}

exports.update_statut_bordereau = {
    name: 'update_statut_bordereau',
    text: `
        UPDATE gap.Bordereaux SET
            statutBordereau=$1,
            commentaireBordereau=$2
        WHERE numeroBordereau=$3
        `
}

exports.update_montant_bordereau = {
    name: 'update_montant_bordereau',
    text: `UPDATE gap.Bordereaux SET 
        montanttotal=get_montant_total_bordereau($1), 
        partAssurance=get_part_assurance_bordereau($1), 
        partPatient=get_part_patient_bordereau($1) 
    WHERE numeroBordereau=$1`
}

exports.report_facture = {
    name: "report_facture",
    text: `
        UPDATE gap.Factures SET 
            erreurFacture=$1,
            commentaireFacture=$2
        WHERE numeroFacture=$3
   `
}

