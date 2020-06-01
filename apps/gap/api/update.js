//TODO : FACTURES
exports.update_facture = {
    name: "update_facture",
    text: `UPDATE gap.Factures SET resteFacture=get_reste_facture((SELECT sejourFacture FROM gap.Factures WHERE numeroFacture=$1),$1) WHERE numeroFacture=$1`
}

//TODO : COMPTE
exports.update_compte = {
    name: 'update_compte',
    text: `UPDATE gap.Comptes SET montantCompte=get_montant_compte($1) WHERE numeroCompte=$1`
}

