const router = require("express").Router();
const format = require('pg-format')
const client = require("../constants/connection");
const moment = require('moment')
const { headers, status } = require('../constants/query')
const { test1, test2 } = require('../apps/gap/api/test')
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
    encaisser_patient_facture,
    encaisser_assurance_facture
} = require("../apps/gap/api/add");
const {
    //listes
    list_comptes,
    list_patient,
    list_sejours,
    list_actes,
    list_actesSejour,
    list_all_factures,
    list_factures_attentes,
    list_factures_patient,
    list_factures_payees_patient,
    list_factures_impayees_patient,
    list_patient_no_compte,
    list_assurances,
    list_controles,
    list_factures_by_assurances,
    //details
    details_patient,
    details_sejour,
    details_facture,
    details_compte,
    details_assurance,
    //autres
    imprimer_facture,
    annuler_facture,
    verify_facture,
    verify_compte
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
    update_patient_facture,
    update_assurance_facture,
    update_compte,
    update_assurance
} = require("../apps/gap/api/update")
const {
    delete_patient,
    delete_sejour,
    delete_facture,
    delete_compte,
    delete_assurance
} = require("../apps/gap/api/delete")

moment.locale('fr')

//patient
router
    .post('/add/patient', function (req, res) {
        try { body = JSON.parse(Object.keys(req.body)[0]) } catch (error) { body = req.body }
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
        ], (err, result) => {
            err && console.log(err)
            res.header(headers);
            res.status(status);
            res.json({ message: { type: "success", label: "nouveau patient enregistré" }, ...result });
        });
    })
    .post('/update/patient/:ipppatient', function (req, res) {
        try { body = JSON.parse(Object.keys(req.body)[0]) } catch (error) { body = req.body }
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

        } = body
        client.query(update_patient, [
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
            req.params.ipppatient
        ], (err, result) => {
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
    .get('/delete/patient/:ipppatient', (req, res) => {
        client.query(delete_patient, [req.params.ipppatient], (err, result) => {
            err && console.log(err)
            res.header(headers);
            res.status(status);
            res.json({ message: { type: "info", label: "Liste des patients actualisée" }, ...result });
        });
    })
    .get('/details/patient/:ipppatient', (req, res) => {
        client.query(details_patient, [req.params.ipppatient], (err, result) => {
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
        try { body = JSON.parse(Object.keys(req.body)[0]) } catch (error) { body = req.body }
        const {
            type,
            actes,
            nomuser,
            prenomsuser,
            finDate,
            debutDate,
            DebutHeure,
            finHeure,
            gestionnaire,
            organisme,
            beneficiaire,
            assurePrinc,
            matriculeAssure,
            numeroPEC,
            taux
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
            gestionnaire,
            organisme,
            beneficiaire,
            assurePrinc,
            matriculeAssure,
            numeroPEC,
            taux,
            1
        ], (err, result) => {
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
            res.json({ message: { type: "info", label: "" }, ...result });
        });
    })


//controles 
router
    .post("/add/controle/:sejour", (req, res) => {
        try { body = JSON.parse(Object.keys(req.body)[0]) } catch (error) { body = req.body }
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
            res.json({ message: { type: "info", label: " " }, ...result });
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
    .get("/verify/compte/:patient", (req, res) => {
        client.query(verify_compte, [req.params.patient], (err, result) => {
            if (err) console.log(err)
            else {
                res.header(headers);
                res.status(status);
                res.json({ message: { type: "info", label: "Liste des comptes actualisée" }, ...result });
            }
        });
    })
    .post("/add/compte", (req, res) => {
        try { body = JSON.parse(Object.keys(req.body)[0]) } catch (error) { body = req.body }
        const {
            ipp
        } = body
        client.query(add_compte, [0, moment().format('DD-MM-YYYY'), moment().format('hh:ss'), ipp], (err, result) => {
            err && console.log(err)
            res.header(headers);
            res.status(status);
            res.json({ message: { type: "info", label: " " }, ...result });
        });
    })


//TRANSACTION
router
    .post("/add/transaction", (req, res) => {
        try { body = JSON.parse(Object.keys(req.body)[0]) } catch (error) { body = req.body }
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
                    res.json({ message: { type: "info", label: " " }, ...result });
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
            res.json({ message: { type: "info", label: " " }, ...result });
        });
    })
    .get('/search/facture/:numeroFacture', (req, res) => {
        client.query(search_facture, [req.params.numeroFacture], (err, result) => {
            err && console.log(err)
            res.header(headers);
            res.status(status);
            res.json({ message: { type: "info", label: " " }, ...result });
        });
    })
    .get('/list/factures_attentes', (req, res) => {
        client.query(list_factures_attentes, (err, result) => {
            err && console.log(err)
            res.header(headers);
            res.status(status);
            res.json({ message: { type: "info", label: " " }, ...result });
        });
    })
    .get('/list/factures_patient/:ipppatient', (req, res) => {
        client.query(list_factures_patient, [req.params.ipppatient], (err, result) => {
            err && console.log(err)
            res.header(headers);
            res.status(status);
            res.json({ message: { type: "info", label: " " }, ...result });
        });
    })
    .get('/list/factures_payees_patient/:ipppatient', (req, res) => {
        client.query(list_factures_payees_patient, [req.params.ipppatient], (err, result) => {
            err && console.log(err)
            res.header(headers);
            res.status(status);
            res.json({ message: { type: "info", label: " " }, ...result });
        });
    })
    .get('/list/factures_impayees_patient/:ipppatient', (req, res) => {
        client.query(list_factures_impayees_patient, [req.params.ipppatient], (err, result) => {
            err && console.log(err)
            res.header(headers);
            res.status(status);
            res.json({ message: { type: "info", label: " " }, ...result });
        });
    })
    .get('/details/facture/:numeroFacture', (req, res) => {
        client.query(details_facture, [req.params.numeroFacture], (err, result) => {
            err && console.log(err)
            res.header(headers);
            res.status(status);
            res.json({ message: { type: "info", label: " " }, ...result });
        });
    })
    .get('/imprimer/facture/:idpatient', (req, res) => {
        client.query(imprimer_facture, [req.params.idpatient], (err, result) => {
            err && console.log(err)
            res.header(headers);
            res.status(status);
            res.json({ message: { type: "info", label: " " }, ...result });








        });
    })
    .post('/encaisser_patient/facture/:numeroFacture', (req, res) => {
        try { body = JSON.parse(Object.keys(req.body)[0]) } catch (error) { body = req.body }
        console.log(body);

        const { modepaiement, montantrecu, compte } = body
        client.query(encaisser_patient_facture, [modepaiement, montantrecu, req.params.numeroFacture], (err, result) => {
            if (err) console.log(err)
            else {
                client.query(update_patient_facture, [req.params.numeroFacture], (err, result) => {
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
                                        res.json({ message: { type: "info", label: " " }, ...result });
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
    .post('/encaisser_patient/all_factures', (req, res) => {
        var body = []
        try { body = JSON.parse(Object.keys(req.body)[0]) } catch (error) { body = req.body }
        const compte = body.pop()
        client.query(format(`INSERT INTO gap.Paiements (modePaiement,sourcePaiement,montantPaiement,facturePaiement) VALUES %L`, body), (err, result) => {
            if (err) console.log(err)
            else {
                body.map(([modepaiement, sourcepaiement, montantrecu, numerofacture]) =>
                    client.query(update_patient_facture, [numerofacture], (err, result) => {
                        if (err) console.log(err)
                        else {
                            if (modepaiement === "Compte") {
                                client.query(add_transaction, [moment().format('DD-MM-YYYY'), moment().format('hh:ss'), '-' + montantrecu, 'Retrait', 'Paiement facture', compte], (err, result) => {
                                    if (err) {
                                        console.log(err)
                                    } else {
                                        client.query(update_compte, [compte], (err, result) => {
                                            if (err) console.log(err)

                                        });
                                    }
                                });
                            }
                        }
                    }))
                res.header(headers);
                res.status(status);
                res.json({ message: { type: "info", label: "Facture encaissée" }, ...result });
            }
        });
    })
    .post('/encaisser_assurance/facture/:numeroFacture', (req, res) => {
        try { body = JSON.parse(Object.keys(req.body)[0]) } catch (error) { body = req.body }
        const { modepaiement, montantrecu, compte } = body
        client.query(encaisser_assurance_facture, [modepaiement, montantrecu, req.params.numeroFacture], (err, result) => {
            if (err) console.log(err)
            else {
                client.query(update_assurance_facture, [req.params.numeroFacture], (err, result) => {
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
                                        res.json({ message: { type: "info", label: " " }, ...result });
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
        try { body = JSON.parse(Object.keys(req.body)[0]) } catch (error) { body = req.body }
        console.log(body)
        const { nom, code, type, fax, telephone, mail, adresse, site_web } = body
        client.query(add_assurance, [nom, code, type, fax, telephone, mail, adresse, site_web], (err, result) => {
            if (err) console.log(err)
            else {
                res.header(headers);
                res.status(status);
                res.json({ message: { type: "info", label: "" }, ...result });
            }
        });
    })
    .post("/update/assurance/:idAssurance", (req, res) => {
        try { body = JSON.parse(Object.keys(req.body)[0]) } catch (error) { body = req.body }
        const { nom, code, type, fax, telephone, mail, adresse, site_web } = body
        client.query(update_assurance, [nom, code, type, fax, telephone, mail, adresse, site_web, req.params.idAssurance], (err, result) => {
            if (err) console.log(err)
            else {
                res.header(headers);
                res.status(status);
                res.json({ message: { type: "info", label: "" }, ...result });
            }
        });
    })
    .get('/delete/assurance/:idAssurance', (req, res) => {
        client.query(delete_assurance, [req.params.idAssurance], (err, result) => {
            if (err) console.log(err)
            else {
                res.header(headers);
                res.status(status);
                res.json({ message: { type: "info", label: " " }, ...result });
            }
        });
    })
    .get('/list/assurances', (req, res) => {
        client.query(list_assurances, (err, result) => {
            if (err) console.log(err)
            else {
                res.header(headers);
                res.status(status);
                res.json({ message: { type: "info", label: "" }, ...result });
            }
        });
    })
    .get('/details/assurance/:idAssurance', (req, res) => {
        client.query(details_assurance, [req.params.idAssurance], (err, result) => {
            if (err) console.log(err)
            else {
                res.header(headers);
                res.status(status);
                res.json({ message: { type: "info", label: "" }, ...result });
            }
        });
    })
    .get('/search/assurance/:info', (req, res) => {
        client.query(search_assurance, [req.params.info], (err, result) => {
            if (err) console.log(err)
            else {
                res.header(headers);
                res.status(status);
                res.json({ message: { type: "info", label: "" }, ...result });
            }
        });
    })


//borderaus
router
    // .get('/list/borderaux/:assurances', (req, res) => {
    //     client.query(search_assurance, [req.params.info], (err, result) => {
    //         if (err) console.log(err)
    //         else {
    //             res.header(headers);
    //             res.status(status);
    //             res.json({ message: { type: "info", label: "" }, ...result });
    //         }
    //     });
    // })
    .get('/list/factures/:assurance/:dateDebut/:dateFin', (req, res) => {
        client.query(list_factures_by_assurances, [req.params.assurance, req.params.dateDebut, req.params.dateFin], (err, result) => {
            if (err) console.log(err)
            else {
                res.header(headers);
                res.status(status);
                res.json({ message: { type: "info", label: "" }, ...result });
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
                res.json({ message: { type: "info", label: "" }, ...result });
            }
        });
    })
    .post('/list/actesSejour', (req, res) => {
        var body
        try { body = JSON.parse(Object.keys(req.body)[0]) } catch (error) { body = req.body }
        const { actesList } = body
        console.log(body);

        if (actesList.length === 0) {
            client.query(format("SELECT * FROM general.Actes WHERE codeActe IN ('default')", actesList), (err, result) => {
                if (err) console.log(err)
                else {
                    res.header(headers);
                    res.status(status);
                    res.json({ message: { type: "info", label: "" }, ...result });
                }
            });
        } else {
            client.query(format("SELECT * FROM general.Actes WHERE codeActe IN (%L) ORDER BY idacte", actesList), (err, result) => {
                if (err) console.log(err)
                else {
                    res.header(headers);
                    res.status(status);
                    res.json({ message: { type: "info", label: "" }, ...result });
                }
            });
        }
    })

module.exports = router