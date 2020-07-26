//profils
exports.list_apps = {
    name: "list_apps",
    text: "SELECT * FROM Apps"
}

// TODO LES PROFILS

exports.list_droits_by_app = {
    name: "list_droits_by_app",
    text: "SELECT * FROM Droits WHERE codeApp = $1"
}

exports.list_profils_by_app = {
    name: "list_profils_by_app",
    text: "SELECT * FROM Profils WHERE codeApp = $1 ORDER BY labelProfil"
}

exports.list_all_profils = {
    name: "list_all_profils",
    text: "SELECT * FROM Profils ORDER BY labelProfil"
}

exports.search_profil_by_app = {
    name: "search_profil_by_app",
    text: "SELECT * FROM Profils WHERE  codeApp = $1 AND labelprofil ~* $2 ORDER BY labelProfil"
}

exports.strict_search_profil_by_app = {
    name: "strict_search_profil_by_app",
    text: "SELECT * FROM Profils WHERE  codeApp=$1 AND labelprofil=$2"
}

exports.details_profil_by_app = {
    name: "details_profil_by_app",
    text: "SELECT profils.idProfil, labelProfil, dateProfil, auteurProfil, Droits.codeDroit, labelDroit FROM profils, droit_profil, droits WHERE profils.idProfil=droit_profil.idProfil AND droit_profil.codedroit=droits.codedroit AND  profils.idprofil=$1"
}

// TODO LES LOGS

exports.list_all_logs = {
    name: "list_logs",
    text: "SELECT * FROM Logs"
}

exports.list_logs_by_app_and_type = {
    name: "list_logs_by_app_and_type",
    text: "SELECT * FROM Logs WHERE codeApp=$1 AND typeLog=$2 ORDER BY idLogs DESC"
}

exports.list_logs_by_app = {
    name: "list_logs_by_app",
    text: "SELECT * FROM Logs WHERE codeApp=$1 ORDER BY idLogs DESC"
}

exports.list_logs_users = {
    name: "list_logs_users",
    text: "SELECT DISTINCT(auteurlog) FROM Logs"
}

// TODO LES USERS
exports.list_users_by_app = {
    name: "list_users_by_app",
    text: "SELECT * FROM Users WHERE codeApp = $1 ORDER BY nomUser, prenomsUser"
}

exports.list_all_users = {
    name: "list_all_users",
    text: "SELECT * FROM Users"
}

exports.search_user_by_app = {
    name: "search_user_by_app",
    text: "SELECT * FROM Users WHERE  codeApp = $1 AND nomUser ~* $2 OR prenomsUser ~* $2  ORDER BY nomUser, prenomsUser"
}

exports.details_user_by_app = {
    name: "details_user_by_app",
    text: "SELECT idUser,nomUser, prenomsUser,posteUser, contactUser, mailUser, labelProfil, nomApp, labelDroit, Droit_Profil.codeDroit FROM Profils, Users, Apps,Droits, Droit_Profil WHERE Droits.codeDroit=Droit_Profil.codeDroit AND Profils.idProfil=Droit_Profil.idProfil AND  Users.profilUser=Profils.idProfil AND Profils.codeApp = Apps.codeApp AND idUser=$1"
}