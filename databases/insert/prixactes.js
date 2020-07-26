var readCSV = require('nodecsv').readCSV;
const format = require('pg-format')
const client = require("../../constants/connection");
readCSV('./data/prixactes.csv', function (error, data) {
    client.query(format("INSERT INTO general.Prix_Actes (lettreCleActe,prixActe) VALUES %L", data), (err, result) => {
        err ? console.log(err) : console.log(result);
    })
});