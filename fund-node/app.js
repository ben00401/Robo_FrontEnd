var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');

var routes = require('./routes/index');
var users = require('./routes/users');
var vis = require('./routes/vis');
var testRfile = require('./routes/testRfile');

var get4433 = require('./routes/get4433');
var API_get4433 = require('./routes/API/get4433');
var tsp = require('./routes/tsp');
var profit = require('./routes/profit');
var API_profit = require('./routes/API/profit');
var risk = require('./routes/risk');
var saveportfolio = require('./routes/saveportfolio');
var API_saveportfolio =require('./routes/API/saveportfolio');
var portfolio = require('./routes/portfolio');
var API_portfolio = require('./routes/API/portfolio');
var fund_filter = require('./routes/fund_filter');
var app = express();


// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

// uncomment after placing your favicon in /public
//app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));


app.use('/', routes);
app.use('/users', users);
app.use('/vis', vis.rio);
app.use('/testRfile', testRfile.rio);
app.use('/get4433', get4433);
app.use('/API/get4433', API_get4433);
app.use('/portfolio', portfolio);
app.use('/API/portfolio', API_portfolio);
app.use('/profit', profit);
app.use('/API/profit', API_profit);
app.use('/risk', risk);
app.use('/tsp', tsp);
app.use('/fund_filter',fund_filter);
//app.use('/fund', fund);
app.use('/saveportfolio', saveportfolio);
app.use('/API/saveportfolio', API_saveportfolio);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
  app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.render('error', {
      message: err.message,
      error: err
    });
  });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
  res.status(err.status || 500);
  res.render('error', {
    message: err.message,
    error: {}
  });
});


module.exports = app;
