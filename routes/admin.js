const router = require("express").Router();
const client = require("../constants/connection");
const moment = require('moment')
const crypto = require('crypto')

const { headers, status } = require("../constants/query");
const { addLog } = require('../apps/global/add')
const { CREATION, SUPPRESSION } = require('../apps/global/logTypes')
const { CREATION_PROFIL, SUPPRESSION_PROFIL, CREATION_USER, SUPPRESSION_USER } = require('../apps/admin/logs/actions')

const {
    add_droit_profil,
    add_profil_in_app,
    add_user_in_app
} = require("../apps/admin/api/add");

const {
    list_apps,
    list_profils_by_app,
    list_all_profils,
    list_droits_by_app,
    details_profil_by_app,
    search_profil_by_app,
    strict_search_profil_by_app,
    list_all_logs,
    list_logs_by_app_and_type,
    list_logs_by_app,
    list_logs_users,
    list_users_by_app,
    search_user_by_app,
    list_all_users,
    details_user_by_app,
} = require("../apps/admin/api/list");

const { delete_profil, delete_droit_profil, delete_user } = require("../apps/admin/api/delete");

moment.locale('fr')
function firstName(name) {
    return name.split(" ")[0];
}
function hash(mot) {
    const hash = crypto.createHmac('sha256', mot)
        .digest('hex');
    return hash
}
//TODO Les PROFILS
router
    //profil
    //afficher toutes les applications
    .get("/list/apps", function (req, res) {
        client.query(list_apps, (err, result) => {
            res.header(headers);
            res.status(status);
            res.json(result);
        });
    })
    //afficher tous les profils d'une application
    .get("/list/:app/profils", function (req, res) {
        const { app } = req.params;
        client.query(list_profils_by_app, [app], (err, result) => {
            res.header(headers);
            res.status(status);
            res.json(result);
        });
    })
    //tous les profils
    .get("/list/profils", function (req, res) {
        client.query(list_all_profils, (err, result) => {
            res.header(headers);
            res.status(status);
            res.json(result);
        });
    })
    //afficher tous les droits d'une application
    .get("/list/:app/droits", function (req, res) {
        const { app } = req.params;
        client.query(list_droits_by_app, [app], (err, result) => {
            res.header(headers);
            res.status(status);
            res.json(result);
        });
    })
    //Details d'un profil
    .get("/details/profil/:id", function (req, res) {
        client.query(details_profil_by_app, [req.params.id], (err, result) => {
            err && console.log(err);
            res.header(headers);
            res.status(status);
            res.json(result);
        });
    })
    //rechercher le profil d'une application
    .get("/search/:app/profil/:mot", function (req, res) {
        const { app } = req.params;
        client.query(search_profil_by_app, [app, req.params.mot], (err, result) => {
            err && console.log(err);
            res.header(headers);
            res.status(status);
            res.json(result);
        });
    })
    //recherche stricte sur un profil avant sa creation
    .get("/strictsearch/:app/profil/:mot", function (req, res) {
        const { app } = req.params;
        client.query(strict_search_profil_by_app, [app, req.params.mot], (err, result) => {
            err && console.log(err);
            res.header(headers);
            res.status(status);
            res.json(result);
        });
    })

//TODO Les LOGS
router
    //lister les logs
    .get("/listall/logs", function (req, res) {
        client.query(list_all_logs, (err, result) => {
            err && console.log(err);
            res.header(headers);
            res.status(status);
            res.json(result);
        });
    })
    //les users qui generent les logs
    .get("/list/logs/users", function (req, res) {
        client.query(list_logs_users, (err, result) => {
            err && console.log(err);
            res.header(headers);
            res.status(status);
            res.json(result);
        });
    })
    //log par type
    .get("/list/:app/logs/:type", function (req, res) {
        const { app, type } = req.params;
        console.log(req.params);
        client.query(list_logs_by_app_and_type, [app, type], (err, result) => {
            err && console.log(err);
            res.header(headers);
            res.status(status);
            res.json(result);
        });
    })

    .get("/list/:app/logs", function (req, res) {
        const { app } = req.params;
        console.log(req.params);
        client.query(list_logs_by_app, [app], (err, result) => {
            err && console.log(err);
            res.header(headers);
            res.status(status);
            res.json(result);
        });
    })

//TODO Les USERS
router
    //liste des users par application
    .get("/list/:app/users", function (req, res) {
        const { app } = req.params;
        client.query(list_users_by_app, [app], (err, result) => {
            res.header(headers);
            res.status(status);
            res.json(result);
        });
    })
    .get("/details/user/:id", function (req, res) {
        client.query(details_user_by_app, [req.params.id], (err, result) => {
            err && console.log(err);
            res.header(headers);
            res.status(status);
            res.json(result);
        });
    })
    .get("/search/:app/user/:mot", function (req, res) {
        const { app } = req.params;
        client.query(search_user_by_app, [app, req.params.mot], (err, result) => {
            err && console.log(err);
            res.header(headers);
            res.status(status);
            res.json(result);
        });
    })
    .get("/list/users", function (req, res) {
        client.query(list_all_users, (err, result) => {
            res.header(headers);
            res.status(status);
            res.json(result);
        });
    })

router
    .get("/delete/:app/user/:iduser", function (req, res) {
        const { iduser } = req.params
        client.query(delete_user, [iduser], (err, result) => {
            res.header(headers);
            res.status(status);
            res.json(result);
        });
    })
    //supprimer un profil
    .get("/delete/:app/profil/:idprofil", (req, res) => {
        const { userMail, app } = req.query
        const { idprofil } = req.params
        client.query(delete_profil, [idprofil], (err, result) => {
            const { labelprofil } = result.rows[0]
            if (err) {
                res.header(headers);
                res.status(status);
                console.log(err);
                res.json(err);
            } else {
                client.query(delete_droit_profil, [idprofil], (err, result) => {
                    if (err) {
                        res.header(headers);
                        res.status(status);
                        console.log(err);
                        res.json(err);
                    } else {
                        addLog(client, SUPPRESSION, userMail, SUPPRESSION_PROFIL + " " + labelprofil, moment().format("DD MMMM YYYY"), moment().format("HH:mm:ss"), app)
                        res.header(headers);
                        res.status(status);
                        res.json(result);
                    }
                })

            }
        })
    })

router
    .post("/add/:app/user", (req, res) => {
        //deserialisation de l'objet recu par la methode post
        const { userMail, app } = req.query
        const { app: codeApp } = req.params;
        console.log(req.body)
        const body = JSON.parse(Object.keys(req.body)[0]);
        const {
            nomUser,
            prenomsUser,
            contactUser,
            mailUser,
            posteUser,
            profilUser,
            passUser
        } = body
        const login = nomUser[0].toUpperCase() + "." + firstName(prenomsUser.toLowerCase())

        client.query(add_user_in_app,
            [
                nomUser,
                prenomsUser,
                contactUser,
                mailUser,
                posteUser,
                profilUser,
                codeApp,
                login,
                hash(passUser)
            ],
            (err, result) => {
                if (err) {
                    res.header(headers);
                    res.status(status);
                    console.log(err);
                    res.json(err);
                } else {
                    addLog(client, CREATION, userMail, CREATION_USER + " " + mailUser, moment().format("DD MMMM YYYY"), moment().format("HH:mm:ss"), app)
                    res.header(headers);
                    res.status(status);
                    res.json(result);
                }
            })
    })
    //Ajouter un profil dans une application
    .post("/add/:app/profil", (req, res) => {
        //deserialisation de l'objet recu par la methode post
        const { userMail, app } = req.query
        const { app: codeApp } = req.params;
        const body = JSON.parse(Object.keys(req.body)[0]);

        //destructuration et recuperation des varibles
        const { labelProfil, dateProfil, auteurProfil, droits } = body;
        client.query(
            add_profil_in_app,
            [labelProfil, auteurProfil, dateProfil, codeApp],
            (err, result) => {
                if (err) {
                    res.header(headers);
                    res.status(status);
                    console.log(err);
                    res.json(err);
                } else {
                    const { idprofil, labelprofil } = result.rows[0]
                    //si l'insertion se passe bien on a un tableau qui
                    if (idprofil) {
                        droits.forEach((codedroit, i) => {
                            client.query(
                                add_droit_profil,
                                [idprofil, codedroit],
                                (err, result) => {
                                    if (err) {
                                        console.log(err);
                                    } else {
                                        if (i === droits.length - 1) {
                                            addLog(client, CREATION, userMail, CREATION_PROFIL + " " + labelprofil, moment().format("DD MMMM YYYY"), moment().format("HH:mm:ss"), app)
                                            res.header(headers);
                                            res.status(status);
                                            res.json(result);
                                        }
                                    }
                                }
                            );
                        });
                    }
                }
            }
        );
    });

module.exports = router;
