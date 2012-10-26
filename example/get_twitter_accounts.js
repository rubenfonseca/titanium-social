var Social = Ti.UI.currentWindow.Social;

var tableview = Ti.UI.createTableView();
var store = Social.createAccountStore({
  type: Social.ACCOUNT_TWITTER
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

    tableview.data = data;
  }
}

store.grantPermission({
  granted: function(e) {
    load_accounts();
  }, 
  denied: function(e) {
    alert('Permission denied: ' + e.error);
  }
});

tableview.addEventListener('click', function(e) {
  alert(e.rowData.account.identifier);
});

Ti.UI.currentWindow.add(tableview);
