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
    list_sejours,
    list_all_factures,
    list_factures_attentes,
    list_actes,
    encaisser_facture,
    annuler_facture
} = require("../apps/gap/api/list");

moment.locales('fr')
moment.locale('fr')
//patient
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

//sejours
router
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
        client.query(add_facture, [moment().format('YYYY-DDD'),moment().format('DD-MM-YYYY'),moment().format('hh:mm:ss'),"koffi edy",specialite], (err, result) => {
            if (err) {
                console.log(err)
            } else {
                client.query(add_sejour, [debutDate, finDate, DebutHeure, finHeure, "en attente", type, patient, 1,result.rows[0].idfacture], (err, result) => {
                    err && console.log(err)
                    res.header(headers);
                    res.status(status);

                    res.json({ message: { type: "info", label: "Liste des sejours actualisée" }, ...result });
                });
            }
        })

    })
    .get('/list/sejours/:patient', (req, res) => {
        client.query(list_sejours, [req.params.patient], (err, result) => {
            err && console.log(err)
            res.header(headers);
            res.status(status);
            res.json({ message: { type: "info", label: "Liste des sejours actualisée" }, ...result });
        });
    })

//factures
router
    .get('/list/factures', (req, res) => {
        client.query(list_all_factures, (err, result) => {
            err && console.log(err)
            res.header(headers);
            res.status(status);
            res.json({ message: { type: "info", label: "Liste des factures actualisée" }, ...result });
        });
    })
    .get('/list/factures_attentes', (req, res) => {
        client.query(list_factures_attentes, (err, result) => {
            err && console.log(err)
            res.header(headers);
            res.status(status);
            res.json({ message: { type: "info", label: "Liste des factures actualisée" }, ...result });
        });
    })
    .get('/encaisser/facture/:idsejour', (req, res) => {
        client.query(encaisser_facture,[req.params.idsejour], (err, result) => {
            err && console.log(err)
            res.header(headers);
            res.status(status);
            res.json({ message: { type: "info", label: "Facture encaissée" }, ...result });
        });
    })
    .get('/annuler/facture/:idsejour', (req, res) => {
        client.query(annuler_facture,[req.params.idsejour], (err, result) => {
            err && console.log(err)
            res.header(headers);
            res.status(status);
            res.json({ message: { type: "info", label: "Facture annulée" }, ...result });
        });
    })
   

    //Actes
    .get('/list/actes', (req, res) => {
        client.query(list_actes, (err, result) => {
            err && console.log(err)
            res.header(headers);
            res.status(status);
            res.json({ message: { type: "info", label: "" }, ...result });
        });
    })



module.exports = router