
exports.list_droits = {
    name: "list_droits",
    text: "SELECT * FROM Droits"
}

exports.list_profils = {
    name: "list_profils",
    text: "SELECT * FROM Profils ORDER BY labelProfil"
}

exports.list_logs = {
    name: "list_logs",
    text: "SELECT * FROM Logs"
}

exports.list_users = {
    name: "list_users",
    text: "SELECT * FROM Users"
}

exports.list_apps = {
    name: "list_apps",
    text: "SELECT * FROM Apps"
}

exports.list_profils_by_app = {
    name: "list_profils_by_app",
    text: "SELECT * FROM Profils WHERE appProfil = $1"
}

exports.details_profil = {
    name: "details_profil",
    text: "SELECT labelProfil, dateProfil, auteurProfil, Droits.codeDroit, labelDroit FROM profils, droit_profil, droits WHERE profils.idProfil=droit_profil.idProfil AND droit_profil.codedroit=droits.codedroit AND  profils.idprofil=$1"
}

exports.search_profil = {
    name: "search_profil",
    text: "SELECT * FROM Profils WHERE labelprofil ~* $1 ORDER BY labelProfil"
}
