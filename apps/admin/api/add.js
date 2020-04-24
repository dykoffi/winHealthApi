//liste de toutes les requtes d'ajout auniveau de l'interface ADMIN

exports.add_profil_in_app = {
    name: "add_profil_in_app",
    text: "INSERT INTO Profils(labelProfil,auteurProfil,dateProfil,codeApp) VALUES ($1,$2,$3,$4) RETURNING idProfil, labelProfil"
}

exports.add_user_in_app = {
    name: "add_user_in_app",
    text: "INSERT INTO Users(nomUser, prenomsUser, contactUser, mailUser, posteUser, profilUser, codeApp,loginUser, passUser) VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9)"
}

exports.add_log = {
    name: "add_log",
    text: "INSERT INTO Logs VALUES()"
}

exports.add_droit_profil = {
    name: "add_droit_profil",
    text: "INSERT INTO Droit_Profil(idProfil, codeDroit) VALUES ($1,$2)"
}
