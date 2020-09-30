
const add_log_with_app = {
    name: "add_log_with_app",
    text: "INSERT INTO admin.Logs(typeLog,objetLog,auteurLog,actionLog,operationLog,App) VALUES ($1,$2,$3,$4,$5,$6)"
}

exports.addLog = (client, type, objet, action, user, operation, app) => {
    client.query(add_log_with_app, [type, objet, user, operation, action, app], function (err, result) {
        if (err) console.log("error add log :" + err)
        else return
    })
}