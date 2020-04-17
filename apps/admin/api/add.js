//liste de toutes les requtes d'ajout auniveau de l'interface ADMIN

exports.add_profil_in_app = {
    name: "add_profil_in_app",
    text: "INSERT INTO Profils(labelProfil,auteurProfil,dateProfil,codeApp) VALUES ($1,$2,$3,$4) RETURNING idProfil"
}

exports.add_user = {
    name: "add_user",
    text: "INSERT INTO Users VALUES()"
}

exports.add_log = {
    name: "add_log",
    text: "INSERT INTO Logs VALUES()"
}

exports.add_droit_profil = {
    name: "add_droit_profil",
    text: "INSERT INTO Droit_Profil(idProfil, codeDroit) VALUES ($1,$2)"
}
