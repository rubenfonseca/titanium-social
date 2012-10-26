var Social = Ti.UI.currentWindow.Social;

var oauthTokenField = Ti.UI.createTextField({
  hintText: "Oauth token",
  borderStyle: Ti.UI.INPUT_BORDERSTYLE_ROUNDED,
  height: 40,
  width: 300,
  left: 10,
  top: 10
});

var tokenSecretField = Ti.UI.createTextField({
  hintText: "Token Secret",
  borderStyle: Ti.UI.INPUT_BORDERSTYLE_ROUNDED,
  height: 40,
  width: 300,
  left: 10,
  top: 60
});

var button = Ti.UI.createButton({
  title: 'Create Twitter account',
  left: 10,
  right: 10,
  width: 300,
  height: 40,
  top: 120
});

Ti.UI.currentWindow.add(oauthTokenField);
Ti.UI.currentWindow.add(tokenSecretField);
Ti.UI.currentWindow.add(button);

button.addEventListener('click', function(e) {
  var credential = Social.createAccountCredential({
    oauth_token: oauthTokenField.value,
    token_secret: tokenSecretField.value
  });

  var account = Social.createAccount({
    username: "test",
    credential: credential,
    type: Social.ACCOUNT_TWITTER
  });

  var accountStore = Social.createAccountStore({
    type: Social.ACCOUNT_TWITTER
  });

  accountStore.grantPermission({
    granted: function(e) {
      accountStore.saveAccount(account, {
        success: function(e) {
          alert('Saved :D');
        },
        failure: function(e) {
          alert('Saving fail');
        }
      });
    },
    denied: function(e) {
      alert('Denied');
    }
  });
});

