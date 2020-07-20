exports.verify_user = {
    name: "verify_user",
    text: `SELECT nomUser,posteUser,labelProfil,loginUser, prenomsUser, contactUser, mailUser, profilUser, Apps.nomApp, Apps.codeApp 
                FROM Users,Apps,Profils 
                WHERE Users.codeApp=Apps.codeApp 
                AND Users.profilUser=Profils.idProfil 
                AND loginUser=$1 
                AND passUser=md5($2)`
}