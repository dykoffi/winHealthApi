const router = require('express').Router()

const client = require('../constants/connection')
const { headers, status } = require('../constants/query')

const { verify_user } = require('../apps/connexion/api/verify')

router
    .post('/verify/user', function (req, res) {
        const body = JSON.parse(Object.keys(req.body)[0])
        const { login, pass } = body
        client.query(verify_user, [login, pass], function (err, result) {
            res.header(headers)
            res.status(status)
            result.rows[0] !== undefined ? res.json(result.rows[0]) : res.json(false)
        })
    })
module.exports = router