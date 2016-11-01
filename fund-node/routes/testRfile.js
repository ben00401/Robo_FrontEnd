var rio = require("rio");
var path = require("path");
var r_path = "./Rfile";//服务器端R文件路径
//var r_file_command =  "source(\'" + r_path + "/testRfile.R" +"\')";//R路径及名称var 
args = {test: [1,4,4,1,1,0,0,1,1,1,1,0,1,0,2,0,1,1,2,0,0,3,2]};

function displayResponse(err, val) {if (!err) {
        val = JSON.parse(val);
        console.log("result is " + val.test);
        //结果为0,1,2,3,4 
        return res.send({'success':true,'res':val.test});
    } else {
        console.log("Optimization failed");
    }
}

rio.enableDebug(true);//开启调试模式
exports.rio = function(req, res){
rio.evaluate({
    filename: path.join("./Rfile","testRfile.R"),//加载R源
    entrypoint: "uniqueSort",//R中的函数
    data: args,//Nodejs传入R的参数
    callback: function (err, val) {
            if (!err) {
              val = JSON.parse(val);
            	console.log("RETURN:"+val.test);
            	return res.send({'success':true,'res':val.test});
            } else {
            	console.log("ERROR:Rserve call failed");
            	return res.send({'success':false});
            }
        },
    host : "127.0.0.1",
		port : 6311
    });
};
