# AccountCredential

An AccountCredential object encapsulates the information needed to authenticate a user.

Use the `createAccountCredential` method to create an account credential
that uses the OAuth open authentication standard.

## Reference

### + createAccountCredential({...})

Initializes an account credential using OAuth or OAuth2.

#### OAuth parameters

- *oauth_token*: The client application’s token.
- *token_secret*: The client application’s secret token.

Returns a newly initialized account credential.

    var accountCredential = Social.createAccountCredential({
      oauth_token: 'lorenipsum',
      token_secret: 'ipsumlorem'
    });

#### OAuth2 parameters

- *oauth2_token*: The client oauth2 token
- *refresh_token*: The refresh token to renew the account.
- *expiricy_date*: A Date representing the token expiration date.

Accounts can optionally use the OAuth open authentication standard to
authenticate your client application so you can perform operations on behalf of
the user. Instead of the user giving their username and password to login, the
user authenticates directly with the server and your client application
receives a token that grants it access to specific resources for a defined
duration. The authentication mechanism uses a key and secret scheme similar to
the public and private keys used by ssh. A token is a random string of letters
and numbers that is unique and paired with a secret to protect the token from
being abused. You initialize account credentials using this token and secret
token.
