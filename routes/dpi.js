const router = require("express").Router();
const client = require("../constants/connection");
const moment = require('moment')
const crypto = require('crypto')
const { headers, status } = require('../constants/query')
const {
    add_consultation,
    add_contante
} = require("../apps/dpi/api/add");

const {
    list_attente_soins,
    list_attente_consultations,
    list_consultations,
    list_constantes,
    list_last_constante,
    valider_constantes
} = require("../apps/dpi/api/list");


moment.locales('fr')
moment.locale('fr')

router
    .get('/list/constantes/:idpatient', (req, res) => {
        client.query(list_constantes, [req.params.idpatient], (err, result) => {
            err && console.log(err)
            res.header(headers);
            res.status(status);
            res.json({ message: { type: "info", label: "Liste des sejours actualisée" }, ...result });
        });
    })
    .get('/list/last_constante/:idpatient', (req, res) => {
        client.query(list_last_constante, [req.params.idpatient], (err, result) => {
            err && console.log(err)
            res.header(headers);
            res.status(status);
            res.json({ message: { type: "info", label: "Liste des sejours actualisée" }, ...result });
        });
    })
    .get('/list/soins/file_attente', (req, res) => {
        client.query(list_attente_soins, (err, result) => {
            err && console.log(err)
            res.header(headers);
            res.status(status);
            res.json({ message: { type: "info", label: "Liste des sejours actualisée" }, ...result });
        });
    })
    .get('/list/consultations/file_attente', (req, res) => {
        client.query(list_attente_consultations, (err, result) => {
            err && console.log(err)
            res.header(headers);
            res.status(status);
            res.json({ message: { type: "info", label: "Liste des sejours actualisée" }, ...result });
        });
    })
    .get('/list/consultations/:idpatient', (req, res) => {
        client.query(list_consultations, [req.params.patient], (err, result) => {
            err && console.log(err)
            res.header(headers);
            res.status(status);
            res.json({ message: { type: "info", label: "Liste des sejours actualisée" }, ...result });
        });
    })

    .post('/add/constantes/:sejour', (req, res) => {
        const body = JSON.parse(Object.keys(req.body)[0])
        const {
            poids,
            taille,
            temperature,
            pouls,
            tensionArterielle,
            frequenceRespiratoire,
            perimetreOmbrilical,
            perimetreThoracique,
            perimetreBrachial,
            perimetreCranien,
            sejourConstante,
            auteurConstante
        } = body
        console.log(body)
        const { params: { patient } } = req
        client.query(add_contante, [
            moment().format('DD-MM-YYYY'),
            moment().format('hh:mm:ss'),
            poids,
            taille,
            temperature,
            pouls,
            tensionArterielle,
            frequenceRespiratoire,
            perimetreOmbrilical,
            perimetreThoracique,
            perimetreBrachial,
            perimetreCranien,
            sejourConstante,
            auteurConstante
        ], (err, result) => {
            if (err) {
                console.log(err)
            } else {
                client.query(valider_constantes,[sejourConstante],(err,result)=>{
                    res.header(headers);
                    res.status(status);
                    res.json({ message: { type: "info", label: "Liste des sejours actualisée" }, ...result });
                })
            }
        })

    })

module.exports = router