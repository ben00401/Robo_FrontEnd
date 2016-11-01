var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render(
  	'fund_filter', {
  		title: '基金篩選條件'
  		
  	});
});

module.exports = router;
