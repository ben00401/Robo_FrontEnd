var express = require('express');
var router = express.Router();
var path = require("path");
var uuid = require('node-uuid');
var mqtt = require('mqtt');
var SECURE_CERT = path.join(__dirname, '../key', 'oring-cert.pem');
var options = {
  certPath: SECURE_CERT,
  rejectUnauthorized: false,
  username: 'test',
  password: 'test',
  clientId: 'gateway1',
};
var mqttClient = mqtt.connect('mqtts://140.119.19.243:8883', options);

mqttClient.on('connect', function () {
  mqttClient.subscribe('/fund/4433/req');
  mqttClient.subscribe('/fund/4433/res');
});

/* GET users listing. */
router.post('/', function (req, res, next) {
  
  
  var selected_fund = req.body.portfolioSelection;
      selected_fund = JSON.parse(selected_fund);
  
  var constraint_3m = selected_fund.constraint_3m;
  var constraint_6m = selected_fund.constraint_6m;
  var constraint_1y = selected_fund.constraint_1y;
  var constraint_2y = selected_fund.constraint_2y;
  var constraint_3y = selected_fund.constraint_3y;
  var constraint_5y = selected_fund.constraint_5y;
  
  
  var finalCommand = {
    constraint_3m: constraint_3m,
    constraint_6m: constraint_6m,
    constraint_1y: constraint_1y,
    constraint_2y: constraint_2y,
    constraint_3y: constraint_3y,
    constraint_5y: constraint_5y,
    requestId: uuid.v4(),
    user: 'admin',
  };
  
  

  mqttClient.publish('/fund/4433/req', JSON.stringify(finalCommand));
  mqttClient.on('message', handleMqttMsg);

  function handleMqttMsg(topic, message) {
    try {
      var val = JSON.parse(message);
      console.log(val.requestId);
     
      switch (topic) {
        case "/fund/4433/res":
          console.log("got message from fund/4433/res ");
          if (val.requestId === finalCommand.requestId) {
            console.log(JSON.parse(val.data));
            data = JSON.parse(val.data);
            
            
            res.send(data);
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
