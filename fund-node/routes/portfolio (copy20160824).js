var express = require('express');
var router = express.Router();
var rio = require("rio");
var path = require("path");
var uuid = require('node-uuid');
var mqtt = require('mqtt');
var SECURE_CERT = path.join(__dirname, '../key', 'oring-cert.pem');
var options = {
  certPath: SECURE_CERT,
  rejectUnauthorized: false,
  username: 'test',
  password: 'test',
  clientId: 'portfolio copy.js',
};
var mqttClient = mqtt.connect('mqtts://140.119.19.243:8883', options);

mqttClient.on('connect', function () {
  mqttClient.subscribe('/fund/portfolio/req');
  mqttClient.subscribe('/fund/portfolio/res');
});

//args1 = {"portfolio_fundname":["F0000002BK","F000000F87","F000000S//5C","F000001ATI","F000001AU4","F000003ZCP","F0GBR04AMH","F0GBR04CH//U","F0GBR04EBS","F0GBR04J0A","F0GBR04J0C","F0GBR04MAD","F0GBR04SG3//","F0GBR04SJR","F0GBR04V6U","F0HKG062UD"],"user":"admin"};


/* GET users listing. */
router.post('/', function(req, res, next) {
  selected_fund = req.body.portfolioSelection;
  selected_fund = JSON.parse(selected_fund);
  id_array = selected_fund.id_array;
  
  var finalCommand = {
    id_array: id_array,
    requestId: uuid.v4(),
    user: 'admin',
  };
  console.log("sent:" +finalCommand);
  mqttClient.publish('/fund/portfolio/req', JSON.stringify(finalCommand));
  mqttClient.on('message', handleMqttMsg);

  function handleMqttMsg(topic, message) {
    try {
      var val = JSON.parse(message);
      console.log(val.requestId);
     
      switch (topic) {
        case '/fund/portfolio/res':
          console.log("got message from fund/portfolio/res ");
          if (val.requestId === finalCommand.requestId) {
            console.log(JSON.parse(val.data));
            data = JSON.parse(val.data);
            //console.log(data.filename);
            console.log(data.calculate_portfolio.mvweight);
            
           return res.render('portfolio', { 
              title: '選擇投資組合',
              "file":data.calculate_portfolio.file,
              "weight1":data.calculate_portfolio.mvweight,
              "weight2":data.calculate_portfolio.sharperatioweight,
              "weight3":data.calculate_portfolio.eqweight,
              "name":data.calculate_portfolio.name_array,
              "id":data.calculate_portfolio.id_array,
              "tangencypoint":data.calculate_portfolio.tangencypoint,
              "eqpoint":data.calculate_portfolio.eqpoint,
              "min_varpoint":data.calculate_portfolio.min_varpoint}); 
            
            
            mqttClient.removeListener('message', handleMqttMsg);
            
          }
          break;
        default:
          console.log(message.toString());
          break;
          
          
      }
    } catch (err) {
      console.log('cannot parse message to json object : ', err);
    }
  }
  


});
  



module.exports = router;