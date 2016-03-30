var express    = require('express');
var bodyParser = require('body-parser')
var fs         = require('fs');
var path       = require('path');
var app = express();


app.set('views', __dirname + '/webpages/views');
app.set('view engine', 'jade');

app.get('/', function(req, resp, next) {
  resp.render('index');
  resp.end();
  next();
});

var urlencodedParser = bodyParser.urlencoded({ extended: false });
app.post('/setup', urlencodedParser, function(req, resp, next) {
  writeWPACfg(req.body.ssid, req.body.password);
  resp.end('trying to connect to SSID:' + req.body.ssid);
  next('route');
});

var server = app.listen(3000);


//functions
function writeWPACfg(ssid, passwd) {
  var content = 'ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev' + 
          "\n" + 'update_config=1' +
          "\n" + 'network={' + 
          "\n" + '    ssid="' + ssid + '"' +
          "\n" + '    psk="' + passwd + '"' +
          "\n" + '}'
    
  fs.writeFileSync(path.resolve(__dirname, 'config', 'wpa_supplicant.conf'), content);
  setTimeout(stop, 1000);
}

function stop() {
  server.close();
  process.exit();
}
