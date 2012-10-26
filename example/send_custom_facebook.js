var Social = Ti.UI.currentWindow.Social;
var account = null;

var status = Ti.UI.createTextField({
  value: "Hello. This is a Facebook post",
  borderStyle: Ti.UI.INPUT_BORDERSTYLE_ROUNDED,
  height: 40,
  width: 300,
  left: 10,
  top: 10
});
Ti.UI.currentWindow.add(status);

var button = Ti.UI.createButton({
  title: 'Send custom facebook message',
  left: 10,
  right: 10,
  width: 300,
  height: 40,
  top: 120
});
Ti.UI.currentWindow.add(button);

var button2 = Ti.UI.createButton({
  title: 'Send image to facebook',
  left: 10,
  right: 10,
  width: 300,
  height: 40,
  top: 180
});
Ti.UI.currentWindow.add(button2);

button.addEventListener('click', function(e) {
  var request = Social.createRequest({
    url: 'https://graph.facebook.com/me/feed',
    type: Social.FACEBOOK,
    method: Social.REQUEST_METHOD_POST, 
    params: {
      message: status.value
    },
    account: account
  });

  request.addEventListener('success', function(e) {
    alert('facebook message sent :)');
  });
  request.addEventListener('failure', function(e) {
    Ti.API.error(JSON.stringify(e));
    alert(e.data);
  });
  request.perform();
});

button2.addEventListener('click', function(e) {
  var request = Social.createRequest({
    url: 'https://graph.facebook.com/me/photos',
    method: Social.REQUEST_METHOD_POST, 
    type: Social.FACEBOOK,
    params: {
      message: status.value
    },
    account: account
  });

  var image = Ti.Filesystem.getFile('rails.png');
  Ti.API.warn("image is " + image);
  request.addMultiPartData({
    data: image.read(), // must be a TiBlob
    name: "source",
    type: "image/png"
  });

  request.addEventListener('success', function(e) {
    alert('Facebook with image sent :)');
  });
  request.addEventListener('failure', function(e) {
    Ti.API.error(JSON.stringify(e));
    alert(e.data);
  });
  request.perform();
});

var options = {};
options[Social.FACEBOOK_APP_ID]     = '141244755912983';
options[Social.FACEBOOK_PERMISSIONS] = ['email', 'publish_stream'];
options[Social.FACEBOOK_AUDIENCE]    = Social.FACEBOOK_AUDIENCE_EVERYONE;

var store = Social.createAccountStore({
  type: Social.ACCOUNT_FACEBOOK,
  options: options
});
store.grantPermission({
  granted: function(e) {
    var accounts = store.accounts();

    if(accounts.length == 0) {
      alert('No facebook accounts configured');
    } else {
      account = accounts[0];
      button.enabled = true;
    }
  }, 
  denied: function(e) {
    alert('Permission denied: ' + JSON.stringify(e));
  }
});

