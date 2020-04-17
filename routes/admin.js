const router = require("express").Router();
const client = require("../constants/connection");
const { headers, status } = require("../constants/query");

const {
    add_droit_profil,
    add_profil_in_app,
} = require("../apps/admin/api/add");

const {
    list_apps,
    list_profils_by_app,
    list_all_profils,
    list_droits_by_app,
    details_profil_by_app,
    search_profil_by_app,
    strict_search_profil_by_app
} = require("../apps/admin/api/list");

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
    .get("/details/profil/:id", function (req, res) {
        client.query(details_profil_by_app, [req.params.id], (err, result) => {
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
    .get("/strictsearch/:app/profil/:mot", function (req, res) {
        const { app } = req.params;
        client.query(strict_search_profil_by_app, [app, req.params.mot], (err, result) => {
            err && console.log(err);
            res.header(headers);
            res.status(status);
            res.json(result);
        });
    })

router
    //Ajouter un profil dans une application
    .post("/add/:app/profil", (req, res) => {
        //deserialisation de l'objet recu par la methode post
        const { app : codeApp } = req.params;
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
                    //si l'insertion se passe bien on a un tableau qui
                    if (result.rows[0].idprofil) {
                        droits.forEach((codedroit, i) => {
                            client.query(
                                add_droit_profil,
                                [result.rows[0].idprofil, codedroit],
                                (err, result) => {
                                    if (err) {
                                        console.log(err);
                                    } else {
                                        if (i === droits.length - 1) {
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
