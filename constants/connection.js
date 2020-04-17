const { Client } = require('pg')

if (process.env.DATABASE_URL) {
    client = new Client({
        connectionString: process.env.DATABASE_URL,
        ssl: true,
    });
} else {
    client = new Client({
        user: 'oscav',
        host: 'localhost',
        database: 'mytest',
        password: '1234',
        port: 5432,
    })
}
client.connect()

module.exports = client