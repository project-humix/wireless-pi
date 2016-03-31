require('shelljs/global');

if (startWPA() === 'failed') {
  exec(__dirname + '/scripts/wpa_util.sh stop', {silent:true});
  setTimeout(startAPMode, 0);
} else {
    postInfo();
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
      } else {
          postInfo();
      }
    });
  }
}

function postInfo() {
  var info = getNICInfo().split(',');

  request.post('http://humix-wireless-board.mybluemix.net/add',
    {'form':
      {
        'hwaddr':info[0].trim(), 'ipaddr': info[1].trim()
      }
    }
  );
}

function getNICInfo() {
  var output = exec(__dirname + '/scripts/getNICInfo.sh wlan0', {silent:true}).stdout;
  return output.toString().trim();
} 
