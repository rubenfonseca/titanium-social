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
    url: 'http://api.twitter.com/1/statuses/home_timeline.json',
    type: Social.TWITTER,
    method: Social.REQUEST_METHOD_GET, 
    account: account
  });

  request.addEventListener('success', function(e) {
    var data = [];

    for(var i=0; i<e.data.length; i++) {
      var tweet = e.data[i];
      data.push({
        title: tweet.text
      });
    }

    tableview.data = data;
  });
  request.addEventListener('failure', function(e) {
    alert('no');
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
  failure: function(e) {
    alert('Permission denied');
  }
});

