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
  clientId: 'profit.js',
};
var mqttClient = mqtt.connect('mqtts://140.119.19.243:8883', options);

mqttClient.on('connect', function () {
  mqttClient.subscribe('/fund/profit/req');
  mqttClient.subscribe('/fund/profit/res');
});
//args2 = {fundname: ["F0000002BK","F000000F87","F000000S5C","F000001ATI","F000001AU4","F000003ZCP"//,"F0GBR04AMH","F0GBR04CHU","F0GBR04EBS","F0GBR04J0A","F0GBR04J0C","F0GBR04MAD","F0GBR04SG3","F0GBR04SJR"//,"F0GBR04V6U","F0HKG062UD"],"sharperatioweight": [0,0,0,0, 0.54613,0,0, 0.17151,0, 0.28236,0,0,0,0,0,0 ]//,"eqweight": [ 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0.0625, 0//.0625, 0.0625, 0.0625, 0.0625, 0.0625 ],"mvweight": [0,0,0, 0.16478, 0.70117,0,0,0,0,0,0,0,0,0,0, 0.13405 //]};


rio.enableDebug(true);//开启调试模式
/* GET users listing. */
router.get('/', function(req, res, next) {
 
 console.log("in get");
 var finalCommand = {
    
    requestId: uuid.v4(),
    user: 'admin',
  };
  console.log(finalCommand);
  mqttClient.publish('/fund/profit/req', JSON.stringify(finalCommand));
  mqttClient.on('message', handleMqttMsg);

  function handleMqttMsg(topic, message) {
    try {
      var val = JSON.parse(message);
      console.log(val.requestId);
     
      switch (topic) {
        case '/fund/profit/res':
          
          if (val.requestId === finalCommand.requestId) {
            console.log(JSON.parse(val.data));
            data = JSON.parse(val.data);
            //console.log(data.filename);
            
            
           return res.render('profit', { 
             title: '效益監控',
             profit:data
           }); 
            
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