const router = require("express").Router();
const format = require('pg-format')
const client = require("../constants/connection");
const moment = require('moment')
const { headers, status } = require('../constants/query')
const { addLog } = require('../apps/global/add')
const io = require('socket.io-client')
const {
    //ajouter
    add_patient,
    add_sejour,
    add_facture,
    add_recu,
    add_sejour_acte,
    add_controle,
    add_compte,
    add_transaction,
    add_assurance,
    add_bordereau,
    add_facture_avoir,
    add_encaissement,
    //autres
    encaisser_patient_facture,
    encaisser_patient_facture_with_notransaction,
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
    list_factures_avoir,
    list_factures_assurances,
    list_factures_attentes,
    list_factures_patient,
    list_factures_payees_patient,
    list_factures_impayees_patient,
    list_patient_no_compte,
    list_assurances,
    list_controles,
    list_encaissements,
    //bordereau
    list_factures_for_all_assurance_garant_typesejour,
    list_factures_for_all_assurance_garant,
    list_factures_for_all_assurance_typesejour,
    list_factures_for_all_assurance,
    list_factures_for_all_garant_typesejour,
    list_factures_for_all_garant,
    list_factures_for_all_typesejour,
    list_factures_by_assurance_garant_typesejour,
    //details
    details_patient,
    details_sejour,
    details_facture,
    details_compte,
    details_assurance,
    details_bordereau,
    details_encaissement,
    //logs
    list_gap_logs,
    list_gap_logs_users,
    //autres
    imprimer_facture,
    annuler_facture,
    verify_facture,
    verify_compte,
    list_bordereaux
} = require("../apps/gap/api/list");
const {
    search_patient,
    search_sejour,
    search_facture,
    search_compte,
    search_assurance,
    //bordereaux
    search_bordereaux_for_all_assurance_garant_typesejour,
    search_bordereaux_for_all_assurance_garant,
    search_bordereaux_for_all_assurance_typesejour,
    search_bordereaux_for_all_assurance,
    search_bordereaux_for_all_garant_typesejour,
    search_bordereaux_for_all_garant,
    search_bordereaux_for_all_typesejour,
    search_bordereaux_by_assurance_garant_typesejour,
} = require("../apps/gap/api/search")
const {
    update_patient,
    update_sejour,
    update_patient_facture,
    update_assurance_facture,
    update_compte,
    retrait_facture_recue,
    retrait_facture_valide,
    retrait_facture_bordereau,
    update_assurance,
    update_sejour_assurance,
    update_statut_bordereau,
    update_facture,
    report_facture,
    update_montant_bordereau,
    update_reste_encaissement
} = require("../apps/gap/api/update")
const {
    delete_patient,
    delete_sejour,
    delete_facture,
    delete_facture_bordereau,
    delete_compte,
    delete_assurance
} = require("../apps/gap/api/delete")
const { execSync } = require('child_process')
function getIP() {
    try { let stdout = execSync(`hostname -I`, { stdio: ['pipe', 'pipe', 'ignore'], }).toString(); return stdout.trim(); } catch (e) { return ''; }
}
moment.locale('fr')
const host = getIP()
const socket = io(`http://${host}:8000`)

//patient
router
    .post('/add/patient', function (req, res) {
        try { body = JSON.parse(Object.keys(req.body)[0]) } catch (error) { body = req.body }
        const {
            user,
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
            if (err) console.log(err)
            else {
                addLog(client, "Création", "Patient", `Création du patient ${result.rows[0].ipppatient}`, user.nomuser + " " + user.prenomsuser, result.rows[0], "COAP001")
                res.header(headers);
                res.status(status);
                res.json({ message: { type: "success", label: "nouveau patient enregistré" }, ...result });
            }

        });
    })
    .post('/update/patient/:ipppatient', function (req, res) {
        try { body = JSON.parse(Object.keys(req.body)[0]) } catch (error) { body = req.body }
        const {
            user,
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
            if (err) console.log(err)
            else {
                addLog(client, "MODIFICATION", "Patient", `Modification du patient ${result.rows[0].ipppatient}`, user.nomuser + " " + user.prenomsuser, result.rows[0], "COAP001")
                res.header(headers);
                res.status(status);
                res.json({ message: { type: "success", label: "nouveau patient enregistré" }, ...result });
            }
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
        console.log(body);
        const {
            user,
            type,
            specialite,
            actes,
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
            medecin,
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
            specialite,
            patient,
            gestionnaire,
            organisme,
            beneficiaire,
            assurePrinc,
            matriculeAssure,
            numeroPEC,
            taux,
            medecin,
            1
        ], (err, result) => {
            if (err) {
                console.log(err)
            } else {
                const sejour = result.rows[0].numerosejour
                addLog(client, "CREATION", "Séjour", `Création du séjour ${sejour}`, user.nomuser + " " + user.prenomsuser, result.rows[0], "COAP001")
                client.query(format("INSERT INTO gap.Sejour_Acte (numeroSejour,codeActe,prixUnique,plafondAssurance,quantite,prixActe) VALUES %L", actes.map(acte => [sejour, acte])), (err, result) => {
                    if (err) { console.log(err) } else {
                        client.query(add_facture, [
                            moment().format('DD-MM-YYYY'),
                            moment().format('hh:mm'),
                            user.nomuser + " " + user.prenomsuser,
                            sejour
                        ], (err, result) => {
                            if (err) { console.log(err) } else {
                                socket.emit('facture_nouvelle')
                                addLog(client, "CREATION", "Facture", `Création de la facture ${result.rows[0].numerofacture}`, user.nomuser + " " + user.prenomsuser, result.rows[0], "COAP001")
                                res.header(headers);
                                res.status(status);
                                res.json({ message: { type: "info", label: "Liste des sejours actualisée" }, ...result });
                            }
                        })
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
    .get('/details/sejour/:numerosejour', (req, res) => {
        client.query(details_sejour, [req.params.numerosejour], (err, result) => {
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


//Encaissements
router
    .post("/add/encaissement", (req, res) => {
        try { body = JSON.parse(Object.keys(req.body)[0]) } catch (error) { body = req.body }
        const {
            mode,
            recepteur,
            montant,
            assurance,
            numeroTransaction,
            commentaire,
            user
        } = body
        client.query(add_encaissement, [mode, montant, assurance, recepteur, commentaire], (err, result) => {
            if (err) console.log(err)
            else {
                addLog(client, "CREATION", "Encaissement", `Ajout de l'encaissement ${result.rows[0].numeroencaissement}`, user.nomuser + " " + user.prenomsuser, result.rows[0], "COAP001")
                res.header(headers);
                res.status(status);
                res.json({ message: { type: "info", label: " " }, ...result });
            }
        });
    })
    .get('/list/encaissements', (req, res) => {
        client.query(list_encaissements, (err, result) => {
            if (err) console.log(err)
            else {
                res.header(headers);
                res.status(status);
                res.json({ message: { type: "info", label: "Liste des encaissement actualisée" }, ...result });
            }
        });
    })
    .get("/details/encaissement/:numeroEncaissement", (req, res) => {
        client.query(details_encaissement, [req.params.numeroEncaissement], (err, result) => {
            if (err) console.log(err)
            else {
                res.header(headers);
                res.status(status);
                res.json({ message: { type: "info", label: "" }, ...result });
            }
        })
    })
    .post('/encaisser_assurance/facture/:numeroFacture', (req, res) => {
        try { body = JSON.parse(Object.keys(req.body)[0]) } catch (error) { body = req.body }
        const { modepaiement, montantrecu, encaissement } = body
        client.query(encaisser_assurance_facture, [modepaiement, montantrecu, req.params.numeroFacture], (err, result) => {
            if (err) console.log(err)
            else {
                client.query(update_assurance_facture, [req.params.numeroFacture], (err, result) => {
                    if (err) console.log(err)
                    else {
                        client.query(update_reste_encaissement, [encaissement, montantrecu], (err, result) => {
                            if (err) console.log(err)
                            else {
                                res.header(headers);
                                res.status(status);
                                res.json({ message: { type: "info", label: " " }, ...result });
                            }
                        });
                    }
                })
            }
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
    .get('/search/compte/:info', (req, res) => {
        client.query(search_compte, [req.params.info], (err, result) => {
            if (err) console.log(err)
            else {
                res.header(headers)
                res.status(status)
                res.json({ message: { type: "info", label: "Liste des comptes actualisée" }, ...result })
            }
        })
    })
    .post("/add/compte", (req, res) => {
        try { body = JSON.parse(Object.keys(req.body)[0]) } catch (error) { body = req.body }
        const { ipp } = body
        client.query(add_compte, [0, moment().format('DD-MM-YYYY'), moment().format('hh:ss'), ipp], (err, result) => {
            err && console.log(err)
            res.header(headers);
            res.status(status);
            res.json({ message: { type: "info", label: " " }, ...result });
        });
    })
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
    .get('/list/factures_avoir', (req, res) => {
        client.query(list_factures_avoir, (err, result) => {
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
    .get('/imprimer/facture/:ipppatient', (req, res) => {
        client.query(imprimer_facture, [req.params.ipppatient], (err, result) => {
            err && console.log(err)
            res.header(headers);
            res.status(status);
            res.json({ message: { type: "info", label: " " }, ...result });
        });
    })
    .post('/encaisser_patient/facture/:numeroFacture', (req, res) => {
        try { body = JSON.parse(Object.keys(req.body)[0]) } catch (error) { body = req.body }
        const { numeroTransaction } = body
        const { modepaiement, montantrecu, compte, patient: patientRecu } = body
        client.query(
            numeroTransaction.trim() === '' ? encaisser_patient_facture : encaisser_patient_facture_with_notransaction,
            numeroTransaction.trim() === '' ? [modepaiement, montantrecu, req.params.numeroFacture] : [modepaiement, montantrecu, req.params.numeroFacture, numeroTransaction],
            (err, result) => {
                if (err) console.log(err)
                else {
                    console.log(result);
                    const paiementRecu = result.rows[0].numeropaiement
                    client.query(update_patient_facture, [req.params.numeroFacture], (err, result) => {
                        const sejourRecu = result.rows[0].sejourfacture
                        if (err) console.log(err)
                        client.query(add_recu, [
                            montantrecu,
                            moment().format('YYYY-MM-DD'),
                            patientRecu,
                            req.params.numeroFacture,
                            paiementRecu,
                            sejourRecu], (err, result) => {
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
                    })
                }
            });
    })
    .post('/add/facture_avoir/:numeroFacture', (req, res) => {
        try { body = JSON.parse(Object.keys(req.body)[0]) } catch (error) { body = req.body }
        const { montant, commentaire } = body
        client.query(`SELECT * FROM gap.Factures WHERE numeroFacture=$1`, [req.params.numeroFacture], (err, result) => {
            if (err) console.log(err)
            else {
                const {
                    datefacture,
                    heurefacture,
                    auteurfacture,
                    partassurancefacture,
                    resteassurancefacture,
                    partpatientfacture,
                    restepatientfacture,
                    sejourfacture,
                } = result.rows[0]
                client.query(`
                    INSERT INTO gap.Factures (
                        dateFacture,
                        heureFacture,
                        auteurFacture,
                        montantTotalFacture,
                        partAssuranceFacture,
                        resteAssuranceFacture,
                        partPatientFacture,
                        restePatientFacture,
                        sejourFacture,
                        typeFacture,
                        commentaireFacture,
                        parentFacture
                ) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,'avoir',$10,$11) RETURNING numeroFacture, parentFacture
         `, [
                    datefacture,
                    heurefacture,
                    auteurfacture,
                    -montant,
                    partassurancefacture,
                    resteassurancefacture,
                    partpatientfacture,
                    restepatientfacture,
                    sejourfacture,
                    commentaire,
                    req.params.numeroFacture
                ], (err, result) => {
                    if (err) console.log(err)
                    else {
                        client.query(`UPDATE gap.Factures SET parentFacture=$1 WHERE numeroFacture=$2`, [result.rows[0].numerofacture, result.rows[0].parentfacture], (err, result) => {
                            if (err) console.log(err);
                            else {
                                res.header(headers);
                                res.status(status);
                                res.json({ message: { type: "info", label: "Facture encaissée" }, ...result });
                            }
                        }
                        )
                    }
                });
            }
        })
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

//bordereaux
router
    .get('/list/factures_assurances', (req, res) => {
        client.query(list_factures_assurances, (err, result) => {
            err && console.log(err)
            res.header(headers);
            res.status(status);
            res.json({ message: { type: "info", label: " " }, ...result });
        });
    })
    .get('/list/factures/:assurance/:garant/:dateDebut/:dateFin/:typesejour', (req, res) => {
        const { assurance, garant, dateDebut, dateFin, typesejour } = req.params
        if (assurance === "Tous" && garant === "Tous" && typesejour === "Tous") {
            client.query(list_factures_for_all_assurance_garant_typesejour, [dateDebut, dateFin,], (err, result) => {
                if (err) console.log(err)
                else {
                    res.header(headers);
                    res.status(status);
                    res.json({ message: { type: "info", label: "" }, ...result });
                }
            });
        }

        if (assurance === "Tous" && garant === "Tous" && typesejour !== "Tous") {
            client.query(list_factures_for_all_assurance_garant, [dateDebut, dateFin, typesejour], (err, result) => {
                if (err) console.log(err)
                else {
                    res.header(headers);
                    res.status(status);
                    res.json({ message: { type: "info", label: "" }, ...result });
                }
            });
        }

        if (assurance === "Tous" && garant !== "Tous" && typesejour === "Tous") {
            client.query(list_factures_for_all_assurance_typesejour, [dateDebut, dateFin, garant], (err, result) => {
                if (err) console.log(err)
                else {
                    res.header(headers);
                    res.status(status);
                    res.json({ message: { type: "info", label: "" }, ...result });
                }
            });
        }

        if (assurance === "Tous" && garant !== "Tous" && typesejour !== "Tous") {
            client.query(list_factures_for_all_assurance, [dateDebut, dateFin, garant, typesejour], (err, result) => {
                if (err) console.log(err)
                else {
                    res.header(headers);
                    res.status(status);
                    res.json({ message: { type: "info", label: "" }, ...result });
                }
            });
        }

        if (assurance !== "Tous" && garant === "Tous" && typesejour === "Tous") {
            client.query(list_factures_for_all_garant_typesejour, [dateDebut, dateFin, assurance], (err, result) => {
                if (err) console.log(err)
                else {
                    res.header(headers);
                    res.status(status);
                    res.json({ message: { type: "info", label: "" }, ...result });
                }
            });
        }

        if (assurance !== "Tous" && garant === "Tous" && typesejour !== "Tous") {
            client.query(list_factures_for_all_garant, [dateDebut, dateFin, assurance, typesejour], (err, result) => {
                if (err) console.log(err)
                else {
                    res.header(headers);
                    res.status(status);
                    res.json({ message: { type: "info", label: "" }, ...result });
                }
            });
        }

        if (assurance !== "Tous" && garant !== "Tous" && typesejour === "Tous") {
            client.query(list_factures_for_all_typesejour, [dateDebut, dateFin, assurance, garant], (err, result) => {
                if (err) console.log(err)
                else {
                    res.header(headers);
                    res.status(status);
                    res.json({ message: { type: "info", label: "" }, ...result });
                }
            });
        }

        if (assurance !== "Tous" && garant !== "Tous" && typesejour !== "Tous") {
            client.query(list_factures_by_assurance_garant_typesejour, [dateDebut, dateFin, assurance, garant, typesejour], (err, result) => {
                if (err) console.log(err)
                else {
                    res.header(headers);
                    res.status(status);
                    res.json({ message: { type: "info", label: "" }, ...result });
                }
            });
        }

    })
    .get('/list/bordereaux/:assurance/:garant/:dateDebut/:dateFin/:typesejour', (req, res) => {
        const { assurance, garant, dateDebut, dateFin, typesejour } = req.params
        if (assurance === "Tous" && garant === "Tous" && typesejour === "Tous") {
            client.query(search_bordereaux_for_all_assurance_garant_typesejour, [dateDebut, dateFin,], (err, result) => {
                if (err) console.log(err)
                else {
                    res.header(headers);
                    res.status(status);
                    res.json({ message: { type: "info", label: "" }, ...result });
                }
            });
        }

        if (assurance === "Tous" && garant === "Tous" && typesejour !== "Tous") {
            client.query(search_bordereaux_for_all_assurance_garant, [dateDebut, dateFin, typesejour], (err, result) => {
                if (err) console.log(err)
                else {
                    res.header(headers);
                    res.status(status);
                    res.json({ message: { type: "info", label: "" }, ...result });
                }
            });
        }

        if (assurance === "Tous" && garant !== "Tous" && typesejour === "Tous") {
            client.query(search_bordereaux_for_all_assurance_typesejour, [dateDebut, dateFin, garant], (err, result) => {
                if (err) console.log(err)
                else {
                    res.header(headers);
                    res.status(status);
                    res.json({ message: { type: "info", label: "" }, ...result });
                }
            });
        }

        if (assurance === "Tous" && garant !== "Tous" && typesejour !== "Tous") {
            client.query(search_bordereaux_for_all_assurance, [dateDebut, dateFin, garant, typesejour], (err, result) => {
                if (err) console.log(err)
                else {
                    res.header(headers);
                    res.status(status);
                    res.json({ message: { type: "info", label: "" }, ...result });
                }
            });
        }

        if (assurance !== "Tous" && garant === "Tous" && typesejour === "Tous") {
            client.query(search_bordereaux_for_all_garant_typesejour, [dateDebut, dateFin, assurance], (err, result) => {
                if (err) console.log(err)
                else {
                    res.header(headers);
                    res.status(status);
                    res.json({ message: { type: "info", label: "" }, ...result });
                }
            });
        }

        if (assurance !== "Tous" && garant === "Tous" && typesejour !== "Tous") {
            client.query(search_bordereaux_for_all_garant, [dateDebut, dateFin, assurance, typesejour], (err, result) => {
                if (err) console.log(err)
                else {
                    res.header(headers);
                    res.status(status);
                    res.json({ message: { type: "info", label: "" }, ...result });
                }
            });
        }

        if (assurance !== "Tous" && garant !== "Tous" && typesejour === "Tous") {
            client.query(search_bordereaux_for_all_typesejour, [dateDebut, dateFin, assurance, garant], (err, result) => {
                if (err) console.log(err)
                else {
                    res.header(headers);
                    res.status(status);
                    res.json({ message: { type: "info", label: "" }, ...result });
                }
            });
        }

        if (assurance !== "Tous" && garant !== "Tous" && typesejour !== "Tous") {
            client.query(search_bordereaux_by_assurance_garant_typesejour, [dateDebut, dateFin, assurance, garant, typesejour], (err, result) => {
                if (err) console.log(err)
                else {
                    res.header(headers);
                    res.status(status);
                    res.json({ message: { type: "info", label: "" }, ...result });
                }
            });
        }

    })
    .get('/retrait/facture_recue/:numeroFacture', (req, res) => {
        client.query(retrait_facture_recue, [req.params.numeroFacture], (err, result) => {
            if (err) console.log(err)
            else {
                res.header(headers);
                res.status(status);
                res.json({ message: { type: "info", label: "" }, ...result });
            }
        });
    })
    .get('/retrait/facture_valide/:numeroFacture', (req, res) => {
        client.query(retrait_facture_valide, [req.params.numeroFacture], (err, result) => {
            if (err) console.log(err)
            else {
                res.header(headers);
                res.status(status);
                res.json({ message: { type: "info", label: "" }, ...result });
            }
        });
    })
    .get('/list/bordereaux', (req, res) => {
        client.query(list_bordereaux, (err, result) => {
            if (err) console.log(err)
            else {
                res.header(headers);
                res.status(status);
                res.json({ message: { type: "info", label: "" }, ...result });
            }
        });
    })
    .get('/details/bordereau/:numeroBordereau', (req, res) => {
        client.query(details_bordereau, [req.params.numeroBordereau], (err, result) => {
            if (err) console.log(err)
            else {
                res.header(headers);
                res.status(status);
                res.json({ message: { type: "info", label: "" }, ...result });
            }
        });
    })
    .post('/add/factures_recues', (req, res) => {
        let body = []
        try { body = JSON.parse(Object.keys(req.body)[0]) } catch (error) { body = req.body }
        client.query(format('UPDATE gap.Factures SET statutfacture=%L WHERE numeroFacture IN (%L)', 'recu', body), (err, result) => {
            if (err) {
                console.log(err);
            } else {
                res.header(headers);
                res.status(status);
                res.json({ message: { type: "info", label: "" }, ...result });
            }
        });

    })
    .post('/add/factures_valides', (req, res) => {
        let body = []
        try { body = JSON.parse(Object.keys(req.body)[0]) } catch (error) { body = req.body }
        client.query(format('UPDATE gap.Factures SET statutfacture=%L WHERE numeroFacture IN (%L)', 'valide', body), (err, result) => {
            if (err) { console.log(err); } else {
                res.header(headers);
                res.status(status);
                res.json({ message: { type: "info", label: "" }, ...result });
            }
        });

    })
    .post('/update/sejour/:numeroSejour/:numeroFacture', (req, res) => {
        try { body = JSON.parse(Object.keys(req.body)[0]) } catch (error) { body = req.body }
        const { gestionnaire, organisme, beneficiaire, matriculeAssure, assurePrinc, numeroPEC, taux, numeroBordereau } = body
        console.log(body);
        client.query(update_sejour_assurance, [gestionnaire, organisme, beneficiaire, matriculeAssure, assurePrinc, numeroPEC, taux, req.params.numeroSejour], (err, result) => {
            if (err) console.log(err);
            else {
                client.query(update_facture, [req.params.numeroSejour, req.params.numeroFacture], (err, result) => {
                    if (err) console.log(err);
                    else {
                        client.query(update_montant_bordereau, [numeroBordereau], (err, result) => {
                            if (err) console.log(err);
                            else {
                                res.header(headers);
                                res.status(status);
                                res.json({ message: { type: "info", label: "" }, ...result });
                            }
                        })
                    }
                })
            }
        })
    })
    .post('/add/bordereau', (req, res) => {
        let body = []
        try { body = JSON.parse(Object.keys(req.body)[0]) } catch (error) { body = req.body }
        const { nomassurance, nomgarant, typeSejour, limiteDateString, montanttotal, partAssurance, partPatient, factures } = body
        client.query(add_bordereau, [moment().format("YYYY-MM-DD"), moment().format("HH:MM"),
            limiteDateString, nomassurance, nomgarant, typeSejour, montanttotal, partAssurance, partPatient, "Envoie"],
            (err, result) => {
                listFactures = factures.map(facture => [result.rows[0].numerobordereau, facture])
                if (err) console.log(err);
                else {
                    client.query(format("INSERT INTO gap.Bordereau_factures(numeroBordereau, numeroFacture) VALUES %L", listFactures), (err, result) => {
                        if (err) console.log(err);
                        else {
                            client.query(format('UPDATE gap.Factures SET statutfacture=%L WHERE numeroFacture IN (%L)', 'bordereau', factures), (err, result) => {
                                if (err) {
                                    console.log(err);
                                } else {
                                    res.header(headers);
                                    res.status(status);
                                    res.json({ message: { type: "info", label: "" }, ...result });
                                }
                            });
                        }
                    })
                }

            })
    })
    .post('/delete/bordereau', (req, res) => {
        try { body = JSON.parse(Object.keys(req.body)[0]) } catch (error) { body = req.body }
        const { numerobordereau, factures } = body
        client.query("DELETE FROM gap.Bordereaux WHERE numeroBordereau=$1", [numerobordereau], (err, result) => {
            if (err) console.log(err);
            else {
                client.query(format('UPDATE gap.Factures SET statutfacture=%L WHERE numeroFacture IN (%L)', 'valide', factures), (err, result) => {
                    if (err) console.log(err);
                    else {
                        res.header(headers);
                        res.status(status);
                        res.json({ message: { type: "info", label: "" }, ...result });
                    }
                });
            }
        })
    })
    .post('/update/statut_bordereau/:numeroBordereau', (req, res) => {
        try { body = JSON.parse(Object.keys(req.body)[0]) } catch (error) { body = req.body }
        const { statut, commentaire } = body
        client.query(update_statut_bordereau, [statut, commentaire, req.params.numeroBordereau], (err, result) => {
            if (err) console.log(err)
            else {
                res.header(headers);
                res.status(status);
                res.json({ message: { type: "info", label: "" }, ...result });
            }
        })
    })
    .post('/report/facture/:numeroFacture', (req, res) => {
        try { body = JSON.parse(Object.keys(req.body)[0]) } catch (error) { body = req.body }
        const { erreur, comment, numeroBordereau } = body
        client.query(report_facture, [erreur, comment, req.params.numeroFacture], (err, result) => {
            if (err) console.log(err)
            else {
                if (erreur === "refuse") {
                    client.query(delete_facture_bordereau, [req.params.numeroFacture], (err, result) => {
                        if (err) console.log(err)
                        else {
                            client.query(retrait_facture_bordereau, [req.params.numeroFacture], (err, result) => {
                                if (err) console.log(err)
                                else {
                                    client.query(update_montant_bordereau, [numeroBordereau], (err, result) => {
                                        if (err) console.log(err);
                                        else {
                                            res.header(headers);
                                            res.status(status);
                                            res.json({ message: { type: "info", label: "" }, ...result });
                                        }
                                    })
                                }
                            })
                        }
                    })
                } else {
                    res.header(headers);
                    res.status(status);
                    res.json({ message: { type: "info", label: "" }, ...result });
                }
            }
        })
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

//LOGS
router
    .get('/list/logs', (req, res) => {
        client.query(list_gap_logs, (err, result) => {
            if (err) console.log(err);
            else {
                res.header(headers);
                res.status(status);
                res.json({ message: { type: "info", label: "" }, ...result });
            }
        })
    })
    .get('/list/logs_users', (req, res) => {
        client.query(list_gap_logs_users, (err, result) => {
            if (err) console.log(err);
            else {
                res.header(headers);
                res.status(status);
                res.json({ message: { type: "info", label: "" }, ...result });
            }
        })
    })

router
    .get('/*', (req, res) => {
        console.log('NOT FOUND : ' + req.url);
        res.json({ message: "route not foound" })
    })
    .post('/*', (req, res) => {
        console.log('NOT FOUND : ' + req.url);
        res.json({ message: "route not foound" })
    })

module.exports = router