# ComposerView

## Description

The ComposerView class presents a view to the user to compose a message on a social network.

You can set the initial text and other content before presenting the sheet to
the user but cannot change the message after the user views it. All of the
methods used to set the content of the message return a `true`/`false` value. The
methods return `false` if the content doesn’t fit in the message or the view was
already presented to the user and the message can no longer be changed.

## Reference

You can get a reference to the ComposerView by passing the social network to the `type` key:

    var composer = Social.createComposerView({
      type: Social.FACEBOOK
    });

### isServiceAvailable(socialNetwork)

Returns whether you can send a message to the specified social network.

    var composer = Social.createComposerView({ type: Social.FACEBOOK });
    if(composer.isServiceAvailable(Social.FACEBOOK)) {
      alert("Can send facebook message");
    } else {
      alert("Oops");
    }

### - setInitialText(text)

Sets the initial text for a message. Returns `true` if successful. `false` if
text does not fit in the currently available character space or the view was
presented to the user.

    var composer = Social.createTweetComposerView({ type: Social.TWITTER });
    composer.setInitialText("Hello Tweet");

### - addImage(blob)

Adds an image to the message. The argument bust be a `TiBlob` (check the
example). Returns `true` if successful. `false` if image does not fit in the
currently available character space or the view was presented to the user.


    var composer = Social.createTweetComposerView({ type: Social.TWITTER });
    var image = Ti.Filesystem.getFile('rails.png');
    composer.addImage(image.read()); // always use a TiBlob!

### - removeAllImages()

Removes all images from the message. Returns `true` if successful. `false` if
the images were not removed because the view was presented to the user.

    var composer = Social.createTweetComposerView({ type: Social.FACEBOOK });
    composer.removeAllImages();

### - addURL(url)

Adds a URL to the message. Returns `true` if successful. `false` if url does
not fit in the currently available character space or the view was presented to
the user.

    var composer = Social.createTweetComposerView({ type: Social.TWITTER });
    composer.addURL('http://google.com');

### - removeAllURLs()

Removes all URLs from the message. Returns `true` if successful. `false` if the
URLs were not removed because the view was presented to the user.

    var composer = Social.createTweetComposerView({ type: Social.FACEBOOK });
    composer.removeAllURLs();

### - open()

Opens the social message sheet to the user, so he/she can personalize the
message and finally send the message. The view will appear in front of all the
present views, and works as a modal window.

    var composer = Social.createTweetComposerView({ type: Social.FACEBOOK });
    composer.open();

## Events

### - complete

Sent after the user sends or cancels a message. The event object contains a key
`result` with the result of the operation.

    var composer = Social.createTweetComposerView({ type: Social.FACEBOOK });
    composer.addEventListener('complete', function(e) {
      if(e.result == Social.DONE)
        alert('Sent! :D');
      
      if(e.result == Social.CANCELLED)
        alert('Cancelled :(');
    });
    composer.open();

