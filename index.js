const app = require('./app');
const debug = require('debug')('api:server');
const http = require('http');

/**
 const fs = require('fs');
 * Get port from environment and store in Express.
 const options = {
   key: fs.readFileSync('key.pem'),
   cert: fs.readFileSync('cert.pem')
 };
 */

const port = normalizePort(process.env.PORT || '8000');
app.set('port', port);

const server = http.createServer(app);
server.listen(port);
server.on('error', onError);
server.on('listening', onListening);

/**
 * Normalize a port into a number, string, or false.
 */

function normalizePort(val) {
    const port = parseInt(val, 10);

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

    const bind = typeof port === 'string' ?
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
    const addr = server.address();
    const bind = typeof addr === 'string' ?
        'pipe ' + addr :
        'port ' + addr.port;
    debug('Listening on ' + bind);
}

const io = require("socket.io").listen(server)
io.sockets.on("connection", function (socket, pseudo) {
    console.log("un user c'est connecte")
    socket.on("facture_encaisser", ({ sejour, patient }) => {
        socket.broadcast.emit("facture_encaisser", { sejour, patient })
    })
    socket.on("facture_nouvelle", () => {
        socket.broadcast.emit("facture_nouvelle")
    })
    socket.on("constantes_add", ({ sejour, patient }) => {
        socket.broadcast.emit("nouveau_patient", { sejour, patient })
    })

})

console.log(`start on port : ${port}`);

module.exports = io