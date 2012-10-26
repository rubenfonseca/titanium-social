var Social = Ti.UI.currentWindow.Social;
var account = null;

var status = Ti.UI.createTextField({
  value: "Hello. This is a tweet",
  borderStyle: Ti.UI.INPUT_BORDERSTYLE_ROUNDED,
  height: 40,
  width: 300,
  left: 10,
  top: 10
});
Ti.UI.currentWindow.add(status);

var button = Ti.UI.createButton({
  title: 'Send custom tweet',
  left: 10,
  right: 10,
  width: 300,
  height: 40,
  top: 120
});
Ti.UI.currentWindow.add(button);

var button2 = Ti.UI.createButton({
  title: 'Send custom tweet with image',
  left: 10,
  right: 10,
  width: 300,
  height: 40,
  top: 180
});
Ti.UI.currentWindow.add(button2);

button.addEventListener('click', function(e) {
  var request = Social.createRequest({
    url: 'http://api.twitter.com/1/statuses/update.json',
    type: Social.TWITTER,
    method: Social.REQUEST_METHOD_POST, 
    params: {
      status: status.value
    },
    account: account
  });

  request.addEventListener('success', function(e) {
    alert('tweet sent :)');
  });
  request.addEventListener('failure', function(e) {
    alert(e.error);
  });
  request.perform();
});

button2.addEventListener('click', function(e) {
  var request = Social.createRequest({
    url: 'https://upload.twitter.com/1/statuses/update_with_media.json',
    method: Social.REQUEST_METHOD_POST, 
    type: Social.TWITTER,
    params: {
      possibly_sensitive: "true",
      status: status.value
    },
    account: account
  });

  var image = Ti.Filesystem.getFile('rails.png');
  Ti.API.warn("image is " + image);
  request.addMultiPartData({
    data: image.read(), // must be a TiBlob
    name: "media[]",
    type: "image/png"
  });

  request.addEventListener('success', function(e) {
    alert('tweet with image sent :)');
  });
  request.addEventListener('failure', function(e) {
    alert(e.status + " ---> " + e.error);
  });
  request.perform();
});

var store = Social.createAccountStore({
  type: Social.ACCOUNT_TWITTER
});
store.grantPermission({
  granted: function(e) {
    var accounts = store.accounts();

    if(accounts.length == 0) {
      alert('No twitter accounts configured');
    } else {
      account = accounts[0];
      button.enabled = true;
    }
  }, 
  denied: function(e) {
    alert('Permission denied');
  }
});

