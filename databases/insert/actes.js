var readCSV = require('nodecsv').readCSV;
const format = require('pg-format')
const client = require("../../constants/connection");
var t

const addActes = {
    name: 'addActes',
    text: `
        INSERT INTO general.Actes 
        (   codeActe,
            typeActe,
            libelleActe,
            cotationActe,
            lettreCleActe,
            prixLettreCleActe,
            regroupementActe
        ) VALUES($1,$2,$3,$4,$5::text,get_prix_acte($5),$6)
    `
}

readCSV('./data/actes.csv', function (error, data) {
    const d = [data[12], data[15]]
    console.log(d)
    data.forEach(d => {
        client.query(addActes, [d[0], d[1], d[2], d[3], d[4], d[5]], (err, result) => { err && console.log(err); })
    })
});