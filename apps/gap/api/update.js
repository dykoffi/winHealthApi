//TODO : FACTURES
exports.update_patient_facture = {
    name: "update_facture",
    text: `UPDATE gap.Factures SET restePatientFacture=get_reste_patient((SELECT sejourFacture FROM gap.Factures WHERE numeroFacture=$1),$1) WHERE numeroFacture=$1`
}
exports.update_assurance_facture = {
    name: "update_facture",
    text: `UPDATE gap.Factures SET resteAssuranceFacture=get_reste_assurance((SELECT sejourFacture FROM gap.Factures WHERE numeroFacture=$1),$1) WHERE numeroFacture=$1`
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
