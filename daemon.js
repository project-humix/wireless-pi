require('shelljs/global');

if (startWPA() === 'failed') {
  exec(__dirname + '/scripts/wpa_util.sh stop', {silent:true});
  setTimeout(startAPMode, 0);
}

function startWPA() {
  console.error('starting wpa_supplicant...');
  var wpaOut = exec(__dirname + '/scripts/wpa_util.sh start', {silent:true}).stdout;
  console.error('wpa:', wpaOut.toString().trim());
  return wpaOut.toString().trim();
}

function startAPMode() {
  //need to enable AP mode
  console.error('enable AP mode');
  var hostapOut = exec(__dirname + '/scripts/hostap_util.sh start', {silent:true}).stdout;
  if (hostapOut.toString().trim() === 'connected') {
    //start web server for setting ssid/passwd
    console.error('starting webserver...');
    exec('node ' + __dirname + '/server.js',  function(code, stdout, stderr) {
      console.error('webserver stopped');
      //web server stopped, lets try to start wpa 
      exec(__dirname + '/scripts/hostap_util.sh stop', {silent:true});
      if (startWPA() === 'failed') {
        exec(__dirname + '/scripts/wpa_util.sh stop', {silent:true});
        setTimeout(startAPMode,0);
      }
    });
  }
}
