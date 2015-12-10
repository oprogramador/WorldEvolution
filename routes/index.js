var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.sendfile('views/index.html');
});

router.get('/all_simulations/', function(req, res, next) {
  var fs = require('fs');
  var dirs = fs.readdirSync('public/evolution_output');
  res.send(JSON.stringify(dirs));
});

router.get('/all_slides/:simulation_name', function(req, res, next) {
  var fs = require('fs');
  console.log(req.query);
  var files = fs.readdirSync('public/evolution_output/'+req.param('simulation_name'));
  files = files.map(function(x){ return x.match(/^[0-9]+/)[0]; });
  files = files.sort(function(a, b){ return parseInt(a) - parseInt(b); });
  res.send(JSON.stringify(files));
});

router.post('/generate/', function(req, res, next) {
  console.log(req);
  var width = parseInt(req.body.width);
  var height = parseInt(req.body.height);
  var n = parseInt(req.body.n);
  var max_speed = parseFloat(req.body.max_speed);
  var iteration_count = parseInt(req.body.iteration_count);

  var exec = require('child_process').exec;

  exec('julia julia/World.jl '+width+' '+height+' '+n+' '+max_speed+' '+iteration_count, function (error, stdout, stderr) {
      if(stderr === '') {
          console.log(stdout);
          res.send('OK');
      } else {
          console.log(stderr);
          res.status(500).send('Fail');
      }
  });
});

module.exports = router;
