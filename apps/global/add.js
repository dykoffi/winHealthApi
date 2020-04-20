
const add_log_with_app = {
    name: "add_log_with_app",
    text: "INSERT INTO Logs(typeLog,auteurLog,actionLog,dateLog,heureLog,codeApp) VALUES ($1,$2,$3,$4,$5,$6)"
}

exports.addLog = (client, type, user, action, date,heure, app) => {
    client.query(add_log_with_app, [type, user, action, date,heure, app], function (err, result) {
        if (err) { console.log("error add log :" +err) } else {
            return
        }
    })
}