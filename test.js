var readCSV = require('nodecsv').readCSV;
const format = require('pg-format')
const client = require("../../constants/connection");
 
readCSV('./actes.csv', function(error, data){
  // console.log(data);
  client.query("select * from general.actes")
});