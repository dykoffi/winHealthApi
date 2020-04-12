const router = require('express').Router()
const client = require('../constants/connection')
const { headers, status } = require('../constants/query')

const { add_droit_profil, add_log, add_profil, add_user } = require('../apps/admin/api/add')
const { list_droits, list_profils, list_logs, list_users, details_profil, search_profil } = require('../apps/admin/api/list')

router
    .get('/list/droits', function (req, res) {
        client.query(list_droits, (err, result) => {
            res.header(headers)
            res.status(status)
            res.json(result)
        })
    })
    .get('/list/profils', function (req, res) {
        client.query(list_profils, (err, result) => {
            res.header(headers)
            res.status(status)
            res.json(result)
        })
    })
    .get('/list/logs', function (req, res) {
        client.query(list_logs, (err, result) => {
            res.header(headers)
            res.status(status)
            res.json(result)
        })
    })
    .get('/list/users', function (req, res) {
        client.query(list_users, (err, result) => {
            res.header(headers)
            res.status(status)
            res.json(result)
        })
    })
    .get('/details/profil/:id', function (req, res) {
        client.query(details_profil, [req.params.id], (err, result) => {
            res.header(headers)
            res.status(status)
            res.json(result)
        })
    })
    .get('/search/profil/:mot', function (req, res) {
        client.query(search_profil, [req.params.mot], (err, result) => {
            err && console.log(err)
            res.header(headers)
            res.status(status)
            res.json(result)
        })
    })





router
    .post('/add/profil', (req, res) => {
        //deserialisation de l'objet result
        const body = JSON.parse(Object.keys(req.body)[0])
        //destructuration et recuperation des varibles
        const { labelProfil, dateProfil, auteurProfil, droits } = body
        client.query(add_profil, [labelProfil, auteurProfil, dateProfil], (err, result) => {
            if (err) {
                console.log(err)
            } else {
                //si l'insertion se passe bien on a un tableau qui
                if (result.rows[0].idprofil) {
                    droits.forEach((codedroit, i) => {
                        client.query(add_droit_profil, [result.rows[0].idprofil, codedroit], (err, result) => {
                            if (err) { console.log(err) } else {
                                if (i === droits.length - 1) {
                                    res.header(headers)
                                    res.status(status)
                                    res.json(result)
                                }
                            }
                        })
                    })
                }
            }
        })
    })

module.exports = router