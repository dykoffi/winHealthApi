var createError = require('http-errors');
var express = require('express');
var cookieParser = require('cookie-parser');
var logger = require('morgan');

//definition des routes des applications
const connexion_router = require('./routes/connexion')
const admin_router = require('./routes/admin')

var app = express();

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());

//utilisation des routes des applications
app.use('/connexion',connexion_router)
app.use('/admin', admin_router)


// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
   console.log(err.message)
});

module.exports = app;
