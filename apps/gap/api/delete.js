//TODO : PATIENTS 
exports.delete_patient = {
    name : 'delete_patient',
    text : `DELETE FROM gap.DossierAdministratif WHERE ipppatient=$1`
}

//TODO : SEJOURS 
exports.delete_sejour = {
    name : 'delete_sejour',
    text : `DELETE FROM gap.Sejours WHERE numeroSejour=$1`
}

//TODO : FACTURES 
exports.delete_facture = {
    name : 'delete_facture',
    text : `DELETE FROM gap.Factures WHERE numeroFacture=$1`
}

//TODO : COMPTES 
exports.delete_compte = {
    name : 'delete_compte',
    text : `DELETE FROM gap.Comptes WHERE numeroCompte=$1`
}

//TODO : ASSURANCES 
exports.delete_assurance = {
    name : 'delete_assurance',
    text : `DELETE FROM gap.Assurances WHERE idAssurance=$1`
}

exports.delete_facture_bordereau = {
    name: "delete_facture_bordereau",
    text: `DELETE FROM gap.Bordereau_factures WHERE numeroFacture=$1`
}