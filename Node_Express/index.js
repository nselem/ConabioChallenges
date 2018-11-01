'use strict';
const express = require('express');

// App
const app = express();
var routes = require("./routes.js");

// Variables  
var BASE_URL=(process.env.BASE_URL||"");
var PORT = (process.env.PORT || 3333);

console.log(`Running on localhost:${PORT}`);
console.log(`BASE URL:${BASE_URL}`);

// Passing variables to app
app.use(BASE_URL+"/", routes);
app.listen(PORT);
