var express = require('express');
var router = express.Router();
var high_return = "/images/high_return.png";
var high_risk = "/images/high_risk.png";
var midhigh_return = "/images/midhigh_return.png";
var midhigh_risk = "/images/midhigh_risk.png";
var middle_return = "/images/middle_return.png";
var middle_risk = "/images/middle_risk.png";
var midlow_return = "/images/midlow_return.png";
var midlow_risk = "/images/midlow_risk.png";
var low_return = "/images/low_return.png";
var low_risk = "/images/low_risk.png";
/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('risk', { title: '選擇風險',high_return:high_return,high_risk:high_risk,midhigh_return:midhigh_return,midhigh_risk:midhigh_risk,middle_return:middle_return,middle_risk:middle_risk,midlow_return:midlow_return, midlow_risk:midlow_risk,low_return:low_return, low_risk:low_risk});
});

module.exports = router;
