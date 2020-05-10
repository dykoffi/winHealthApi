const router = require("express").Router();
const client = require("../constants/connection");
const moment = require('moment')
const crypto = require('crypto')
const { headers, status } = require('../constants/query')
const {
    add_patient,
    add_sejour,
    add_facture
} = require("../apps/gap/api/add");
const {
    list_patient,
    search_patient,
    details_patient,
    list_sejours
} = require("../apps/gap/api/list");

router
    .get('/list/patients', (req, res) => {
        client.query(list_patient, (err, result) => {
            err && console.log(err)
            res.header(headers);
            res.status(status);
            res.json({ message: { type: "info", label: "Liste des patients actualisée" }, ...result });
        });
    })
    .get('/details/patient/:id', (req, res) => {
        client.query(details_patient, [req.params.id], (err, result) => {
            err && console.log(err)
            res.header(headers);
            res.status(status);
            res.json({ message: { type: "info", label: "Liste des patients actualisée" }, ...result });
        });
    })
    .get('/search/patients/:info', (req, res) => {
        client.query(search_patient, [req.params.info], (err, result) => {
            err && console.log(err)
            res.header(headers);
            res.status(status);
            res.json({ message: { type: "info", label: "Recherche ok" }, ...result });
        });
    })
    .get('/list/sejours/:patient', (req, res) => {
        client.query(list_sejours, [req.params.patient], (err, result) => {
            err && console.log(err)
            res.header(headers);
            res.status(status);
            res.json({ message: { type: "info", label: "Liste des sejours actualisée" }, ...result });
        });
    })




router
    .post('/add/patient', function (req, res) {
        const body = JSON.parse(Object.keys(req.body)[0])
        const {
            ipp,
            nom,
            prenoms,
            nomjeune,
            sexe,
            datenaissance,
            lieunaissance,
            nationalite,
            habitation,
            contact,
            situation,
            religion,
            profession,
            nompere,
            prenomspere,
            contactpere,
            nommere,
            prenomsmere,
            contactmere,
            nomtuteur,
            prenomstuteur,
            contacttuteur,
            nompersonnesure,
            prenomspersonnesure,
            contactpersonnesure,
            assure,
            assurance
        } = body
        console.log(body)
        client.query(add_patient, [ipp,
            nom,
            prenoms,
            nomjeune,
            sexe,
            datenaissance,
            lieunaissance,
            nationalite,
            profession,
            situation,
            religion,
            habitation,
            contact,
            nompere,
            prenomspere,
            contactpere,
            nommere,
            prenomsmere,
            contactmere,
            nomtuteur,
            prenomstuteur,
            contacttuteur,
            nompersonnesure,
            prenomspersonnesure,
            contactpersonnesure,
            assure,
            assurance], (err, result) => {
                err && console.log(err)
                res.header(headers);
                res.status(status);
                res.json({ message: { type: "success", label: "nouveau patient enregistré" }, ...result });
            });
    })
    .post('/add/sejour/:patient', (req, res) => {
        const body = JSON.parse(Object.keys(req.body)[0])
        const {
            type,
            specialite,
            medecin,
            finDate,
            debutDate,
            DebutHeure,
            finHeure
        } = body
        console.log(body)
        const { params: { patient } } = req
        client.query(add_sejour, [debutDate, finDate, DebutHeure, finHeure, "en attente", type, patient, 1], (err, result) => {
            err && console.log(err)
            res.header(headers);
            res.status(status);
            res.json({ message: { type: "info", label: "Liste des patients actualisée" }, ...result });
        });
    })


module.exports = router