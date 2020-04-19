const { Client } = require('pg')

if (process.env.DATABASE_URL) {
    client = new Client({
        connectionString: process.env.DATABASE_URL,
        ssl: true,
    });
} else {
    client = new Client({
        user: 'edy',
        host: 'localhost',
        database: 'mytest',
        password: '7859'
    })
}
client.connect((err)=>{err && console.log(err)})

module.exports = client