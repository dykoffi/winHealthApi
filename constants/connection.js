const { Client } = require('pg')

if (process.env.DATABASE_URL) {
    client = new Client({
        connectionString: process.env.DATABASE_URL,
        ssl: true,
    });
} else {
    client = new Client({
        user: 'psante',
        host: 'localhost',
        database: 'winhealth',
        password: '1234'
    })
}

client.connect((err)=>{err && console.log(err)})

module.exports = client