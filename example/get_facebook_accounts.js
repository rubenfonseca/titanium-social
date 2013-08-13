var Social = Ti.UI.currentWindow.Social;

var tableview = Ti.UI.createTableView();

var options = {};
options[Social.FACEBOOK_APP_ID]     = '141244755912983';
options[Social.FACEBOOK_PERMISSIONS] = ['read_friendlists', 'read_stream'];

var store = Social.createAccountStore({
  type: Social.ACCOUNT_FACEBOOK,
  options: options
});

function load_accounts() {
  var accounts = store.accounts();

  var data = [];
  for(var i=0; i<accounts.length; i++) {
    var account = accounts[i];
    data.push({
      title: account.username + " [" + account.description + "]",
      account: account
    });

    Ti.API.warn("---> " + account.credential.oauthToken);

    tableview.data = data;
  }
}

store.grantPermission({
  granted: function(e) {
    Ti.API.warn('Permission granted');
    load_accounts();
  }, 
  denied: function(e) {
    alert('Permission denied: ' + e.error);
  }
});

tableview.addEventListener('click', function(e) {
  var account = e.rowData.account;
  store.renewCredentialsForAccount(account, {
    success: function(event) {
      alert(event.result);
    },
    failure: function(event) {
      alert(event.error);
    }
  });

  // alert(e.rowData.account.identifier);
});

Ti.UI.currentWindow.add(tableview);
