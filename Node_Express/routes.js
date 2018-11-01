// Constants
var express = require("express");

var appRouter = express.Router();
	appRouter.get("/foo", function(req, res){
  	var oMyOBject = {foo:'Hello'};
   	res.json(oMyOBject);
	});

	appRouter.get('/bar', function(req, res) {
  	var oMyOBject = {bar:'World'};
   	res.json(oMyOBject);
	});

module.exports = appRouter;


