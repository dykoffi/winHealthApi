const router = require("express").Router();
const client = require("../constants/connection");
const moment = require('moment')
const { headers, status } = require('../constants/query')
const {
    //ajouter
    add_patient,
    add_sejour,
    add_facture,
    add_sejour_acte,
    add_controle,
    add_compte,
    add_transaction,
    add_assurance,
    //autres
    encaisser_facture,
} = require("../apps/gap/api/add");
const {
    //listes
    list_comptes,
    list_patient,
    list_sejours,
    list_actes,
    list_all_factures,
    list_factures_attentes,
    list_patient_no_compte,
    //details
    details_patient,
    details_sejour,
    details_facture,
    details_compte,
    //autres
    imprimer_facture,
    annuler_facture,
    verify_facture,
} = require("../apps/gap/api/list");
const {
    search_patient,
    search_sejour,
    search_facture,
    search_compte,
    search_assurance
} = require("../apps/gap/api/search")
const {
    update_patient,
    update_sejour,
    update_facture,
    update_compte,
    update_assurance
} = require("../apps/gap/api/update")

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
                            res.json({ message: { type: "info", label: "Liste des sejours actualisée" }, ...result });
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
    .get('/details/sejour/:idsejour/:numerosejour', (req, res) => {
        client.query(details_sejour, [req.params.idsejour, req.params.numerosejour], (err, result) => {
            err && console.log(err)
            res.header(headers);
            res.status(status);
            res.json({ message: { type: "info", label: "Liste des factures actualisée" }, ...result });
        });
    })


//controles 
router
    .post("/add/controle/:sejour", (req, res) => {
        const body = JSON.parse(Object.keys(req.body)[0])
        const {
            datedebut,
            heureDebut,
            dateFin,
            heureFin,
        } = body
        client.query(add_controle, [datedebut, heureDebut, dateFin, heureFin, req.params.numerosejour], (err, result) => {
            err && console.log(err)
            res.header(headers);
            res.status(status);
            res.json({ message: { type: "info", label: "Liste des factures actualisée" }, ...result });
        });
    })

//Comptes
router
    .get('/list/patients_no_compte', (req, res) => {
        client.query(list_patient_no_compte, (err, result) => {
            err && console.log(err)
            res.header(headers);
            res.status(status);
            res.json({ message: { type: "info", label: "Liste des patients actualisée" }, ...result });
        });
    })
    .get("/list/comptes", (req, res) => {
        client.query(list_comptes, (err, result) => {
            err && console.log(err)
            res.header(headers);
            res.status(status);
            res.json({ message: { type: "info", label: "Liste des comptes actualisée" }, ...result });
        });
    })
    .get("/details/compte/:numeroCompte", (req, res) => {
        client.query(details_compte, [req.params.numeroCompte], (err, result) => {
            err && console.log(err)
            res.header(headers);
            res.status(status);
            res.json({ message: { type: "info", label: "Liste des comptes actualisée" }, ...result });
        });
    })
    .post("/add/compte", (req, res) => {
        const body = JSON.parse(Object.keys(req.body)[0])
        const {
            ipp
        } = body
        client.query(add_compte, [0, moment().format('DD-MM-YYYY'), moment().format('hh:ss'), ipp], (err, result) => {
            err && console.log(err)
            res.header(headers);
            res.status(status);
            res.json({ message: { type: "info", label: "Liste des factures actualisée" }, ...result });
        });
    })

//TRANSACTION
router
    .post("/add/transaction", (req, res) => {
        const body = JSON.parse(Object.keys(req.body)[0])
        const {
            montant,
            type,
            mode,
            compte
        } = body
        client.query(add_transaction, [moment().format('DD-MM-YYYY'), moment().format('hh:ss'), montant, type, mode, compte], (err, result) => {
            if (err) {
                console.log(err)
            } else {
                client.query(update_compte, [compte], (err, result) => {
                    err && console.log(err)
                    res.header(headers);
                    res.status(status);
                    res.json({ message: { type: "info", label: "Liste des factures actualisée" }, ...result });
                });
            }
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
        client.query(search_facture, [req.params.numeroFacture], (err, result) => {
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
    .get('/details/facture/:numeroFacture', (req, res) => {
        client.query(details_facture, [req.params.numeroFacture], (err, result) => {
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
    .post('/encaisser/facture/:numeroFacture', (req, res) => {
        const body = JSON.parse(Object.keys(req.body)[0])
        const { modepaiement, montantrecu, compte } = body
        client.query(encaisser_facture, [modepaiement, montantrecu, req.params.numeroFacture], (err, result) => {
            if (err) console.log(err)
            else {
                client.query(update_facture, [req.params.numeroFacture], (err, result) => {
                    if (err) console.log(err)
                    else {
                        if (modepaiement === "Compte") {
                            console.log('paiement par compte')
                            client.query(add_transaction, [moment().format('DD-MM-YYYY'), moment().format('hh:ss'), '-' + montantrecu, 'Retrait', 'Paiement facture', compte], (err, result) => {
                                if (err) {
                                    console.log(err)
                                } else {
                                    client.query(update_compte, [compte], (err, result) => {
                                        err && console.log(err)
                                        res.header(headers);
                                        res.status(status);
                                        res.json({ message: { type: "info", label: "Liste des factures actualisée" }, ...result });
                                    });
                                }
                            });
                        } else {
                            res.header(headers);
                            res.status(status);
                            res.json({ message: { type: "info", label: "Facture encaissée" }, ...result });
                        }
                    }
                })
            }
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

//Assurances
router
    .post("/add/assurance", (req, res) => {
        const body = JSON.parse(Object.keys(req.body)[0])
        console.log(body)
        const {
            nomAssurance,
            codeAssurance,
            faxAssurance,
            contactAsssurance,
            mailAssurance,
            localAssurance
        } = body
        client.query(add_assurance, [nomAssurance,
            codeAssurance,
            faxAssurance,
            contactAsssurance,
            mailAssurance,
            localAssurance], (err, result) => {
                if (err) console.log(err)
                else {
                    res.header(headers);
                    res.status(status);
                    res.json({ message: { type: "info", label: "" }, ...result });
                }
            });
    })
    .put("/update/assurance/:idAssurance", (req, res) => {
        const body = JSON.parse(Object.keys(req.body)[0])
        console.log(body)
        const {
            nomAssurance,
            codeAssurance,
            faxAssurance,
            contactAsssurance,
            mailAssurance,
            localAssurance
        } = body
        client.query(update_assurance, [req.params.idAssurance], [nomAssurance,
            codeAssurance,
            faxAssurance,
            contactAsssurance,
            mailAssurance,
            localAssurance], (err, result) => {
                if (err) console.log(err)
                else {
                    res.header(headers);
                    res.status(status);
                    res.json({ message: { type: "info", label: "" }, ...result });
                }
            });
    })
    .delete('/delete/assurance/:idAssurance', (req, res) => {
        client.query(delete_assurance, [req.params.idAssurance], (err, result) => {
            if (err) console.log(err)
            else {
                res.header(headers);
                res.status(status);
                res.json({ message: { type: "info", label: "Liste des factures actualisée" }, ...result });
            }
        });
    })
    .get('/list/assurances', (req, res) => {
        client.query(list_assurances, (err, result) => {
            if (err) console.log(err)
            else {
                res.header(headers);
                res.status(status);
                res.json({ message: { type: "info", label: "Liste des factures actualisée" }, ...result });
            }
        });
    })
    .get('/details/assurance/:idAssurance', (req, res) => {
        client.query(details_assurance, [req.params.idAssurance], (err, result) => {
            if (err) console.log(err)
            else {
                res.header(headers);
                res.status(status);
                res.json({ message: { type: "info", label: "Liste des factures actualisée" }, ...result });
            }
        });
    })
    .get('/search/assurance/:info', (req, res) => {
        client.query(search_assurance, [req.params.info], (err, result) => {
            if (err) console.log(err)
            else {
                res.header(headers);
                res.status(status);
                res.json({ message: { type: "info", label: "Liste des factures actualisée" }, ...result });
            }
        });
    })

//Actes
router
    .get('/list/actes', (req, res) => {
        client.query(list_actes, (err, result) => {
            if (err) console.log(err)
            else {
                res.header(headers);
                res.status(status);
                res.json({ message: { type: "info", label: "Liste des factures actualisée" }, ...result });
            }
        });
    })


module.exports = router