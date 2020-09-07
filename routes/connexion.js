const router = require('express').Router()
const client = require('../constants/connection')
const { headers, status } = require('../constants/query')
const { verify_user } = require('../apps/connexion/api/verify')
const { addLog } = require('../apps/global/add')

router
    .post('/verify/user', function (req, res) {
        try { body = JSON.parse(Object.keys(req.body)[0]) } catch (error) { body = req.body }
        const { login, pass } = body
        client.query(verify_user, [login, pass], function (err, result) {
            if (err) { console.log(err) } else {
                res.header(headers)
                res.status(status)
                const [user] = result.rows
                if (user !== undefined) {
                    addLog(client, "CONNEXION","Utilisateur", "Connexion au serveur", user.nomuser + " " + user.prenomsuser, { ...body, pass: "****" }, user.codeapp)
                    res.json(user)
                } else { res.json(false) }
            }
        })
    })

module.exports = router