exports.verify_user = {
    name: "verify_user",
    text: "SELECT * FROM Users WHERE mail=$1 AND pass=$2",
}