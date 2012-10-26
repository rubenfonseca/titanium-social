var Social = Ti.UI.currentWindow.Social;
var account = null;

var button = Ti.UI.createButton({
  systemButton: Ti.UI.iPhone.SystemButton.REFRESH,
  enabled: false
});
Ti.UI.currentWindow.rightNavButton = button;

var tableview = Ti.UI.createTableView();
Ti.UI.currentWindow.add(tableview);

button.addEventListener('click', function(e) {
  var request = Social.createRequest({
    url: 'https://graph.facebook.com/me/feed',
    type: Social.FACEBOOK,
    method: Social.REQUEST_METHOD_GET,
    account: account
  });

  request.addEventListener('success', function(e) {
    var jsonData = e.data.data;
    var data = [];
    for(var i=0; i < jsonData.length; i++) {
      var tweet = jsonData[i];
      data.push({
        title: tweet.message
      });
    }

    tableview.data = data;
  });

  request.addEventListener('failure', function(e) {
    Ti.API.error("Error: " + e.error);
    Ti.API.error("Status: " + e.status);
    alert('no');
  });

  request.perform();
});

var options = {};
options[Social.FACEBOOK_APP_ID]     = '141244755912983';
options[Social.FACEBOOK_PERMISSIONS] = ['email', 'read_friendlists', 'read_stream'];

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
    alert('Permission denied');
  }
});

