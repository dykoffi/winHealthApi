exports.verify_user = {
    name: "verify_user",
    text: `SELECT 
            nomUser,
            posteUser,
            labelProfil,
            loginUser, 
            prenomsUser, 
            contactUser, 
            mailUser, 
            profilUser, 
            A.nomApp, 
            A.codeApp,
            permissionsProfil
        FROM admin.Users U,admin.Apps A,admin.Profils P
        WHERE U.profilUser=P.labelProfil 
        AND P.codeApp=A.codeApp 
        AND loginUser=$1 
        AND passUser=md5($2)`
}