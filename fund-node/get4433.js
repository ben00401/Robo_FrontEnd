var express = require('express');
var router = express.Router();
var rio = require("rio");
var path = require("path");
var r_path = "./Rfile";//服务器端R文件路径
//var r_file_command =  "source(\'" + r_path + "/testRfile.R" +"\')";//R路径及名称var 
rio.enableDebug(true);//开启调试模式

/* GET users listing. */
router.get('/', function(req, res, next) {
  
  var url = require('url');
  var url_parts = url.parse(req.url, true);
  var query = url_parts.query;
  
  if (query.ref=="4433_100"){
    args_4433_100 = {type:"4433_100"};
    rio.evaluate({
  filename: path.join("./Rfile","get4433.R"),//加载R源
  entrypoint: "get_result4433",//R中的函数
  data: args_4433_100,
  callback: function (err, val) {
    if (!err) {
      val = JSON.parse(val);
      //console.log("RETURN:"+val);
      return res.render('get4433', { title: '基金篩選',"rank_3m":val.rank_3m               ,"rank_6m":val.rank_6m,"rank_1y":val.rank_1y,"rank_2y":val                   .rank_2y,"rank_3y":val.rank_3y,"rank_5y":val.rank_5y,"name":val               .name,"id":val.id});
    } else {
      //console.log("ERROR:Rserve call failed");
      return res.send({'success':false});
    }
  },
  host : "127.0.0.1",
  port : 6311
});
  }else if (query.ref=="4433"){
    args_4433 = {type:"4433"};
    rio.evaluate({
  filename: path.join("./Rfile","get4433.R"),//加载R源
  entrypoint: "get_result4433",//R中的函数
  data: args_4433,
  callback: function (err, val) {
    if (!err) {
      val = JSON.parse(val);
      //console.log("RETURN:"+val);
      return res.render('get4433', { title: '基金篩選',"rank_3m":val.rank_3m             ,"rank_6m":val.rank_6m,"rank_1y":val.rank_1y,"rank_2y":val                   .rank_2y,"rank_3y":val.rank_3y,"rank_5y":val.rank_5y,"name":val              .name,"id":val.id});
    } else {
      //console.log("ERROR:Rserve call failed");
      return res.send({'success':false});
    }
  },
  host : "127.0.0.1",
  port : 6311
});
  }else if (query.ref=="4433_50"){
    args_4433_50= {type:"4433_50"};
    rio.evaluate({
  filename: path.join("./Rfile","get4433.R"),//加载R源
  entrypoint: "get_result4433",//R中的函数
  data: args_4433_50,
  callback: function (err, val) {
    if (!err) {
      val = JSON.parse(val);
      //console.log("RETURN:"+val);
      return res.render('get4433', { title: '基金篩選',"rank_3m":val.rank_3m,"rank_6m":val.rank_6m,"rank_1y":val.rank_1y,"rank_2y":val.rank_2y,"rank_3y":val.rank_3y,"rank_5y":val.rank_5y,"name":val.name,"id":val.id});
    }else {
      //console.log("ERROR:Rserve call failed");
      return res.send({'success':false});
    }
  },
  host : "127.0.0.1",
  port : 6311
});
  }else{
     return res.render('get4433', { title: '基金篩選',"rank_3m":"","rank_6m":"","rank_1y":"","rank_2y":"","rank_3y":"","rank_5y":"","name":"","id":""});
  
  }
 
});



module.exports = router;
