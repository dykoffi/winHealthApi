//TODO : PATIENTS 
exports.delete_patient = {
    name : 'delete_patient',
    text : `DELETE FROM gap.DossierAdministratif WHERE ippPatient=$1`
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