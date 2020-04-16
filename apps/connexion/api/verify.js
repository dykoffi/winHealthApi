exports.verify_user = {
    name: "verify_user",
    text: "SELECT * FROM Users,Apps WHERE Users.codeApp=Apps.codeApp AND mail=$1 AND pass=$2 ",
}