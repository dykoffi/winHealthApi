const router = require('express').Router()
const client = require('../constants/connection')
const { headers, status } = require('../constants/query')

const { add_droit_profil, add_log, add_profil, add_user } = require('../apps/admin/api/add')
const { list_droits, list_profils, list_logs, list_users } = require('../apps/admin/api/list')

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





router
    .post('/add/profil', (req, res) => {
        //deserialisation de l'objet result
        const body = JSON.parse(Object.keys(req.body)[0])
        //destructuration et recuperation des varibles
        const { labelProfil, dateProfil, auteurProfil, droits } = body
        client.query(add_profil, [labelProfil, auteurProfil, dateProfil], (err, result) => {
            //si l'insertion se passe bien on a un tableau qui
            if (result.rows[0].idprofil) {
                droits.forEach((codedroit) => {
                    client.query(droitprofil, [result.rows[0].idprofil, codedroit], (err, result) => {
                        res.header(headers)
                        res.status(status)
                        err ? console.log(err) : console.log(result.rows[0])
                    })
                })
            }
        })
    })

module.exports = router