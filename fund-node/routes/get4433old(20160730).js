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
  clientId: 'get4433old.js',
};
var mqttClient = mqtt.connect('mqtts://140.119.19.99:8883', options);

mqttClient.on('connect', function () {
  mqttClient.subscribe('/fund/4433/req');
  mqttClient.subscribe('/fund/4433/res');
});

/* GET users listing. */
router.get('/', function (req, res, next) {
  var url = require('url');
  var url_parts = url.parse(req.url, true);
  var query = url_parts.query;
  var type = query.ref; // default type is 4433_50
  var finalCommand = {
    type:type,
    requestId: uuid.v4(),
    user: 'admin',
  };
  
  if(!type){
    return res.render('get4433', { title: '基金篩選',"rank_3m":"","rank_6m":"","rank_1y":"","rank_2y":"","rank_3y":"","rank_5y":"","name":"","id":""});
  }

  mqttClient.publish('/fund/4433/req', JSON.stringify(finalCommand));
  mqttClient.on('message', handleMqttMsg);

  function handleMqttMsg(topic, message) {
    try {
      var val = JSON.parse(message);
      console.log(val.requestId);
      switch (topic) {
        case '/fund/4433/res':
          if (val.requestId === finalCommand.requestId) {
            console.log(JSON.parse(val.data));
            data = JSON.parse(val.data);
            console.log(data.id);
            
            res.render('get4433', { 
              title: '基金篩選',
              "rank_3m":data.rank_3m,
              "rank_6m":data.rank_6m,
              "rank_1y":data.rank_1y,
              "rank_2y":data.rank_2y,
              "rank_3y":data.rank_3y,
              "rank_5y":data.rank_5y,
              "name":data.name,
              "id":data.id});
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
