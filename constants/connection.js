const { Client } = require('pg')

client = new Client({
    user: 'oscav',
    host: 'localhost',
    database: 'mytest',
    password: '1234',
    port: 5432,
})

client.connect()

module.exports = client