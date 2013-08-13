# Request

_This documentation is not in sync with the Apple documentation_

## Reference

    var request = Social.createRequest({
      type: Social.TWITTER
    });

### Special note for Facebook requests

When you make requests to the Facebook API, you have to create an AccountStore with the
option to include the `Social.FACEBOOK_AUDIENCE` key. Example:

    var options = {};
    options[Social.FACEBOOK_APP_ID] = 'api_id';
    options[Social.FACEBOOK_PERMISSIONS]= ['email', 'publish_stream'];
    options[Social.FACEBOOK_AUDIENCE] = Social.FACEBOOK_AUDIENCE_EVERYONE;

    var store = Social.createAccountStore({
      type: Social.ACCOUNT_FACEBOOK,
      options: options
    });

    // continue granting permissions


## Properties

### url

The URL to make the request. Ex: `http://api.twitter.com/1/statuses/public_timeline.json`.

### method

On of the 3 request methods:

- Social.REQUEST_METHOD_GET
- Social.REQUEST_METHOD_POST
- Social.REQUEST_METHOD_DELETE

### account (optional)

If you want to authenticate/sign the request, you must provide a valid 
[Account](account.html) object to this property, before you make the request.

## Tasks

### perform()

Performs the request. Set the success/failure handlers before calling this method. The
result will be delivered async.

### addMultiPartData({...})

Adds a binary object to the request, like an image. It accepts the following 3 required keys:

- *name*: the name of the argument

- *data*: a TiBlob with the data to add to the request

- *filename*: the name of the file you're adding. If the Blob on the previous param
  is not a file Blob, you need to pass this param to set the correct filename.

- *type*: a mime type string

      var request = Social.createRequest({...})
      var image = Ti.Filesystem.getFile(...);

      request.addMultiPartData({
        name: 'media[]',
        data: image.read(), // always a TiBlob
        type: 'image/png'
      });

      request.perform();

## Events

### success

Fired when the Request succeeds. The returned JSON response is
deserialized on the `data` key on the event object.

    var request = Social.createRequest({
      type: Social.TWITTER,
      url: 'http://api.twitter.com/1/statuses/public_timeline.jso',
      method: Social.REQUEST_METHOD_GET
    });

    request.addEventListener('success', function(e) {
      Ti.API.log(e.data);
    });

    request.perform();

### failure

Fired when the Request fails. An error explanation should be present on the
`error` key.

    var request = Social.createRequest({
      url: 'http://api.twitter.com/1/statuses/public_timeline.jso',
      method: Social.REQUEST_METHOD_GET,
      type: Social.TWITTER
    });

    request.addEventListener('failure', function(e) {
      Ti.API.log("STATUS CODE IS " + e.status);
      Ti.API.log("ERROR: " + e.error);
    });

    request.perform();

