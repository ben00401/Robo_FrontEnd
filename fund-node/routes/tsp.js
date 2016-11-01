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
  clientId: 'tsp.js',
};
var mqttClient = mqtt.connect('mqtts://140.119.19.99:8883', options);

mqttClient.on('connect', function () {
  mqttClient.subscribe('/fund/tsp/req');
  mqttClient.subscribe('/fund/tsp/res');
});

/* GET users listing. */
router.post('/', function (req, res) {
  var parseCommand = JSON.parse(req.body.portfolioSelection);
  var finalCommand = Object.assign(parseCommand, {
    requestId: uuid.v4(),
    startDate: '2010/01/01',
    endDate: '2014/12/31',
  });
  mqttClient.publish('/fund/tsp/req', JSON.stringify(finalCommand));
  mqttClient.on('message', handleMqttMsg);

  function handleMqttMsg(topic, message) {
    try {
      var val = JSON.parse(message.toString());
      switch (topic) {
        case '/fund/tsp/res':
          if (val.requestId === finalCommand.requestId) {
            
            console.log(val.data);
            //data = JSON.parse(val.data);
            console.log(val.data.id);
            
          // 請將接到的值render至ejs
            // res.render('tsp', {
            //   title: '選擇投資組合',
            //   filename: val.filename,
            //   weight1: val.mvweight,
            //   weight2: val.sharperatioweight,
            //   weight3: val.eqweight,
            //   "name": val.name,
            //   "id": val.id,
            //   tangencypoint: val.tangencypoint,
            //   eqpoint: val.eqpoint,
            //   min_varpoint: val.min_varpoint
            // });
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