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
  clientId: 'saveportfolio.js',
};
var mqttClient = mqtt.connect('mqtts://140.119.19.243:8883', options);

mqttClient.on('connect', function () {
  mqttClient.subscribe('/fund/saveportfolio/req');
  mqttClient.subscribe('/fund/saveportfolio/res');
});

args3 = {fundname: ["F0000002BK","F000000F87","F000000S5C","F000001ATI","F000001AU4","F000003ZCP","F0GBR04AMH","F0GBR04CHU","F0GBR04EBS","F0GBR04J0A","F0GBR04J0C","F0GBR04MAD","F0GBR04SG3","F0GBR04SJR","F0GBR04V6U","F0HKG062UD"],"sharperatioweight": [0,0,0,0, 0.54613,0,0, 0.17151,0, 0.28236,0,0,0,0,0,0 ],"date":"2015-01-01","user":"dk"};

rio.enableDebug(true);//开启调试模式
/* GET users listing. */
router.post('/', function(req, res, next) {
  
   savedata = req.body.portfolioSelection;
  savedata = JSON.parse(savedata);
  
  
  var finalCommand = {
    savedata: savedata,
    requestId: uuid.v4()
  };
  console.log("sent to mqtt:"+ finalCommand);
  mqttClient.publish('/fund/saveportfolio/req', JSON.stringify(finalCommand));
  mqttClient.on('message', handleMqttMsg);

  function handleMqttMsg(topic, message) {
    try {
      var val = JSON.parse(message);
      console.log(val.requestId);
     
      switch (topic) {
        case '/fund/saveportfolio/res':
          console.log("got message from fund/saveportfolio/res ");
          if (val.requestId === finalCommand.requestId) {
            console.log(val);
            return res.send("<script>alert('儲存成功');window.location.href='/'</script>");
            
            mqttClient.removeListener('message', handleMqttMsg);
            
          }
          break;
        default:
          console.log(message.toString());
          break;
          
          
      }
    } catch (err) {
      console.log('cannot parse message to json object : ', err);
      //return res.send("<script>alert('儲存失敗');window.location.href='/'</script>");
    }
  }
  


});

  



module.exports = router;
