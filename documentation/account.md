# Account

An Account object encapsulates information about a user account stored in the
Accounts database. You create, add, and delete accounts using an AccountStore
object. The AccountStore object provides an interface to the persistent
Accounts database. Account objects belong to a single AccountStore object.

## Reference

    var accountStore = (see account_store.html to see how to get a reference)
    var accountCred = Social.createAccountCredential({ see account_credential.html })
    var account = Social.createAccount({
      username: "test",
      credential: accountCred,
      type: Social.ACCOUNT_TWITTER
    });

## Properties

### - description

Returns a human readable description of the account. This property is available
if the user grants the application access to this account; otherwise, it is
`null`. *read-only*

    var accountStore = ....
    var account = accountStore.accounts()[0];
    Ti.API.log(account.description);

### - identifier

Returns a unique identifier for this account. *read-only*

    var accountStore = ...
    var account = accountStore.accounts()[0];
    Ti.API.log(account.identifier);

### - username / setUsername(string)

Returns / sets the username for this account. This property needs to be set before the account
is saved. After the account is saved, this property is available if the user grants the 
application access to this account; otherwise, it is `null`.

    var accountStore = ...
    var account = accountStore.accounts()[0];
    account.username = 'rubenfonseca';
    Ti.API.log(account.username);

### - credential / setCredential(credential)

Returns / sets a `SocialAccountCredential` object with the credentials for this account.

    var accountStore = ...
    var account = accountStore.accounts()[0];
    var credential = account.credential;
    // ....

    ...
    var credential = Social.createAccountCredential({...});
    account.credential = credential;



