const router = require('express').Router()

const client = require('../constants/connection')
const { headers, status } = require('../constants/query')
const { verify_user } = require('../apps/connexion/api/verify')



router
    .post('/verify/user', function (req, res) {
        const body = JSON.parse(Object.keys(req.body)[0])
        console.log(body);

        const { login, pass } = body
        client.query(verify_user, [login, pass], function (err, result) {
            if (err) { console.log(err) } else {
                res.header(headers)
                res.status(status)
                const [user] = result.rows
                if (user !== undefined) {
                    res.json(user)
                } else { res.json(false) }
            }
        })
    })
module.exports = router