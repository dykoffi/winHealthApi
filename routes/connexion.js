const router = require('express').Router()
const moment = require('moment')
const client = require('../constants/connection')
const { headers, status } = require('../constants/query')
const { verify_user } = require('../apps/connexion/api/verify')
const { CONNEXION_SERVEUR } = require('../apps/connexion/logs/actions')
const { addLog } = require('../apps/global/add')
const { CONNEXION } = require('../apps/global/logTypes')

const crypto = require('crypto')

function hash(mot){
    const hash = crypto.createHmac('sha256', mot)
    .digest('hex');

    return hash
}


moment.locale('fr')

router
    .post('/verify/user', function (req, res) {
        const body = JSON.parse(Object.keys(req.body)[0])
        const { login, pass } = body
        client.query(verify_user, [login, hash(pass)], function (err, result) {
            if (err) { console.log(err) } else {
                res.header(headers)
                res.status(status)
                const [user] = result.rows
                if (user !== undefined) {
                    addLog(client, CONNEXION, user.mailuser, CONNEXION_SERVEUR, moment().format("DD MMMM YYYY"),moment().format("HH:mm:ss"), user.codeapp)
                    res.json(user)
                } else { res.json(false) }
            }
        })
    })

module.exports = router