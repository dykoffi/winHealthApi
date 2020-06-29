const createError = require('http-errors');
const express = require('express');
const logger = require('morgan');
const cookieparser = require('cookie-parser')
const path = require('path')

//definition des routes des applications
const connexion_router = require('./routes/connexion')
const admin_router = require('./routes/admin')
const gap_router = require('./routes/gap')
const dpi_router = require('./routes/dpi')
// const views_router = require('./routes/views')

//definition de l'application
const app = express();

// app.set('views', path.join(__dirname, 'views'));
// app.set('view engine', 'ejs');


app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(express.static(path.join(__dirname, 'public')))
app.use(cookieparser())

//utilisation des routes des applications
app.use('/connexion', connexion_router)
app.use('/admin', admin_router)
app.use('/gap', gap_router)
app.use('/dpi', dpi_router)
// app.use('/views', views_router)

app.use(function (req, res, next) { next(createError(404)); }); // catch 404 and forward to error handler
app.use(function (err, req, res, next) { console.log(err.message) }); // error handler
module.exports = app;