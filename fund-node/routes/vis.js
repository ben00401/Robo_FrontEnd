var rio = require("rio");
exports.rio = function(req, res){
	rio.e({
		host : "127.0.0.1",
		port : 6311,
		command: "pi / 2 * 2 * 2",
        callback: function (err, val) {
            if (!err) {
            	console.log("RETURN:"+val);
            	return res.send({'success':true,'res':val});
            } else {
            	console.log("ERROR:Rserve call failed");
            	return res.send({'success':false});
            }
        },
    });
    rio.enableDebug(true);//开启调试模式
    
};

