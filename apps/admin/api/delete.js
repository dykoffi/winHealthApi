exports.delete_profil = {
    name: "delete_profil",
    text: "DELETE FROM Profils WHERE idProfil=$1 RETURNING labelProfil"
}

exports.delete_user = {
    name: "delete_user",
    text: "DELETE FROM Users WHERE idUser=$1"
}


exports.delete_droit_profil = {
    name: "delete_droit_profil",
    text: "DELETE FROM Droit_Profil WHERE idProfil=$1"
}