exports.verify_user = {
    name: "verify_user",
    text: "SELECT * FROM Users,Apps WHERE Users.codeApp=Apps.codeApp AND mailUser=$1 AND passUser=$2 ",
}