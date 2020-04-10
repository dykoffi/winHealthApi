var app = require('./app');
var debug = require('debug')('api:server');
var http = require('http');

/**
 * Get port from environment and store in Express.
 */

var port = normalizePort(process.env.PORT || '8000');
app.set('port', port);

var server = http.createServer(app);
server.listen(port);
server.on('error', onError);
server.on('listening', onListening);

/**
 * Normalize a port into a number, string, or false.
 */

function normalizePort(val) {
    var port = parseInt(val, 10);

    if (isNaN(port)) {
        // named pipe
        return val;
    }

    if (port >= 0) {
        // port number
        return port;
    }
    return false;
}

/**
 * Event listener for HTTP server "error" event.
 */

function onError(error) {
    if (error.syscall !== 'listen') {
        throw error;
    }

    var bind = typeof port === 'string' ?
        'Pipe ' + port :
        'Port ' + port;

    // handle specific listen errors with friendly messages
    switch (error.code) {
        case 'EACCES':
            console.error(bind + ' requires elevated privileges');
            process.exit(1);
            break;
        case 'EADDRINUSE':
            console.error(bind + ' is already in use');
            process.exit(1);
            break;
        default:
            throw error;
    }
}

/**
 * Event listener for HTTP server "listening" event.
 */

function onListening() {
    var addr = server.address();
    var bind = typeof addr === 'string' ?
        'pipe ' + addr :
        'port ' + addr.port;
    debug('Listening on ' + bind);
}
var { Client } = require('pg')
const client = new Client({
    user: 'oscav',
    host: 'localhost',
    database: 'mytest',
    password: '1234',
    port: 5432,
})

client.connect()

const query = {
    name: 'fetch-user',
    text: `SELECT *FROM temps`
}

var io = require("socket.io").listen(server)
io.sockets.on("connection", function (socket, pseudo) {
    console.log("un user c'est connecte")
    socket.on("getData", ()=>{
        client.query(query, (err, res) => {
            socket.emit("dataOk",res.rows)
        })
    })
})

console.log(`start on port : ${port}`);

module.exports = io