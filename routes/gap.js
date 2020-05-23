const router = require("express").Router();
const client = require("../constants/connection");
const moment = require('moment')
const { headers, status } = require('../constants/query')
const {
    add_patient,
    add_sejour,
    add_facture,
    add_sejour_acte
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
    imprimer_facture,
    details_sejour,
    annuler_facture,
    verify_facture,
    search_facture
} = require("../apps/gap/api/list");

moment.locale('fr')
//patient
router
    .post('/add/patient', function (req, res) {
        const body = JSON.parse(Object.keys(req.body)[0])
        const {
            nom,
            prenoms,
            civilite,
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
            qualitepersonnesure,
            assure,
            assurance
        } = body
        client.query(add_patient, [
            nom,
            prenoms,
            civilite,
            sexe,
            moment(datenaissance).format("DD-MM-YYYY"),
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
            qualitepersonnesure,
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
        console.log(body)
        const {
            type,
            actes,
            nomuser,
            prenomsuser,
            finDate,
            debutDate,
            DebutHeure,
            finHeure
        } = body
        const { params: { patient } } = req
        client.query(add_sejour, [
            moment(debutDate).format("DD-MM-YYYY"),
            moment(finDate).format("DD-MM-YYYY"),
            moment(DebutHeure).format("hh:mm"),
            moment(finHeure).format("hh:mm"),
            "en attente",
            type,
            patient,
            1], (err, result) => {
                if (err) {
                    console.log(err)
                } else {
                    const sejour = result.rows[0].numerosejour
                    actes.forEach(acte => {
                        client.query(add_sejour_acte, [sejour, acte], (err, result) => { })
                    });

                    client.query(add_facture, [
                        moment().format('DD-MM-YYYY'),
                        moment().format('hh:mm'),
                        nomuser + " " + prenomsuser,
                        sejour
                    ], (err, result) => {
                        if (err) { console.log(err) } else {
                            res.header(headers);
                            res.status(status);
                            res.json({message:{type: "info",label: "Liste des sejours actualisée"},...result});
                        }
                    })
                }
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
    .get('/details/sejour/:idsejour', (req, res) => {
        client.query(details_sejour, [req.params.idsejour], (err, result) => {
            err && console.log(err)
            res.header(headers);
            res.status(status);
            res.json({ message: { type: "info", label: "Liste des factures actualisée" }, ...result });
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
    .get('/search/facture/:numeroFacture', (req, res) => {
        client.query(search_facture, [req.params.idFactue], (err, result) => {
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
    .get('/imprimer/facture/:idpatient', (req, res) => {
        client.query(imprimer_facture, [req.params.idpatient], (err, result) => {
            err && console.log(err)
            res.header(headers);
            res.status(status);
            res.json({ message: { type: "info", label: "Liste des factures actualisée" }, ...result });
        });
    })
    .get('/encaisser/facture/:idsejour', (req, res) => {
        client.query(encaisser_facture, [req.params.idsejour], (err, result) => {
            err && console.log(err)
            res.header(headers);
            res.status(status);
            res.json({ message: { type: "info", label: "Facture encaissée" }, ...result });
        });
    })
    .get('/annuler/facture/:idsejour', (req, res) => {
        client.query(annuler_facture, [req.params.idsejour], (err, result) => {
            err && console.log(err)
            res.header(headers);
            res.status(status);
            res.json({ message: { type: "info", label: "Facture annulée" }, ...result });
        });
    })
    .get('/verify/facture/:idfacture', (req, res) => {
        client.query(verify_facture, [req.params.idfacture], (err, result) => {
            err && console.log(err)
            // res.header(headers);
            // res.status(status);
            const { rows } = result
            const { numerofacture } = rows[0]
            res.set('Content-Type', 'text/html')
            res.send(`
            <!DOCTYPE html>
            <html lang="fr">
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta name="theme-color" content="black">
                <title>Verification Facture</title>
                <style>
                    body{
                        padding : 1cm;
                    }
                    h1{
                        margin-top:1cm;
                        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, antarell, 'Open Sans', 'Helvetica Neue', sans-serif;
                    }
                    .valid{
                        font-size:50px;
                        text-align : 'center';
                        color:'green'
                    }
                </style>
            </head>
            <body>
                    <h1 class='valid'>VALID</h1>
                <h1>Facture N° 2563982 DU ${rows[0].datefacture}</h1>
                <h2>Status : En attente</h2>
                <h2>Montant : ${rows[0].prixacte} FCfa</h2>
                <h2>Auteur : ${rows[0].auteurfacture}</h2>
                <h1>Patient</h1>
                <h2>Nom et prenoms :${rows[0].nompatient} ${rows[0].prenomspatient}</h2>
                <h2>Naissance : ${moment(rows[0].datenaissancepatient).format("DD MMM YYYY")} à ${rows[0].lieunaissancepatient}</h2>
                <h2>Domicile : ${rows[0].habitationpatient}</h2>
                <h2>Contact : ${rows[0].contactpatient}</h2>
                <h1>Sejour du ${moment(rows[0].datedebutsejour).format("DD MMM YYYY")}</h1>
                <h2>Entré(e) : ${moment(rows[0].datedebutsejour).format("DD MMM YYYY")} ${rows[0].heuredebutsejour}</h2>
                <h2>Sorti(e) : ${moment(rows[0].datefinsejour).format("DD MMM YYYY")} ${rows[0].heuredebutsejour}</h2>
                <h2>Motif : ${rows[0].typesejour}</h2>
            </body>
            </html>
            `);
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