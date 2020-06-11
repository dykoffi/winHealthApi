const { Client } = require('pg')
const client = new Client()
connect()
const resu = res
console.log(resu.rows[0].message) // Hello world!
client.end()

function connect(){
    return async function(){
        client.connect()
    }
}

function res(){
    return async function(){
       return client.query('SELECT $1::text as message', ['Hello world!'])
    }
}