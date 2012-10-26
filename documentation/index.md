# social Module

## Description

Tap into the new iOS6 Social.framework

## Installation

[http://wiki.appcelerator.org/display/tis/Using+Titanium+Modules]()

To use this module since version 1.0 you must be using at least Xcode 4.5
with iOS SDK 6.0 or later.

## Changelog

See [here](changelog.html)

## Accessing the social Module

To access this module from JavaScript, you would do the following:

	var Social = require("com.0x82.social");

The Social variable is a reference to the Module object.	

### iOS6 module only

This is an iOS6 module only! If you try to require it on an iOS < = 5 device,
it will throw an exception. So you should include some sort of code on
your application to check in which version of iOS are you running, and then
decide to use or not use this module

    function isiOS6Plus()
    {
      // add iphone specific tests
      if (Titanium.Platform.name == 'iPhone OS')
      {
        var version = Titanium.Platform.version.split(".");
        var major = parseInt(version[0],10);
    
        if (major >= 6)
        {
          return true;
        }
      }
      return false;
    }  

## Reference

Please visit the following links to see the different classes of the application:

- [ComposerView](composer_view.html)
- [Account](account.html)
- [AccountCredential](account_credential.html)
- [AccountStore](account_store.html)
- [Request](request.html)

## Methods

### - Social.showActivityItems({...})

This method allows you to access the iOS6+ `UIActivityViewController`.  The
`UIActivityViewController` class is a standard view controller that you can use
to offer various services from your application. The system provides several
standard services, such as copying items to the pasteboard, posting content to
social media sites, sending items via email or SMS, and more.

On the iPad you can optionaly show the controller in a popover. Otherwise, it is 
presented modally.

The method takes the following arguments:

  - **animated** [BOOL] defaults to true
  - **activityItems** [ARRAY] an array with one or more `String` or `TiBlob` objects
  - **excludedActivityTypes** [ARRAY, optional] an array with the types you want to exclude to the user. The possible list of options are:
    - Social.UIActivityTypePostToFacebook
    - Social.UIActivityTypePostToTwitter
    - Social.UIActivityTypePostToWeibo
    - Social.UIActivityTypeMessage
    - Social.UIActivityTypeMail
    - Social.UIActivityTypePrint
    - Social.UIActivityTypeCopyToPasteboard
    - Social.UIActivityTypeAssignToContact
    - Social.UIActivityTypeSaveToCameraRoll

The following options are only valid on the iPad:

  - **rect** [DICTIONARY {x,y,width,height}] The rect from which the popup should be displayed. This must be in world coordinates as the popover is added to the main screen. Defaults to `{x:0, y:0, width:0, height:0}`
  - **arrowDirection** defines the allowed arrow direction. Could be one of the following:
    - Social.UIPopoverArrowDirectionAny
    - Social.UIPopoverArrowDirectionUp
    - Social.UIPopoverArrowDirectionDown
    - Social.UIPopoverArrowDirectionLeft
    - Social.UIPopoverArrowDirectionRight

Example:

    Social.showActivityItems({
      activityItems: ["This is a text to share"],
      excludedActivityTypes: [Social.UIActivityTypePostToWeibo]
    });

This method fires the following two events:

  - **activityWindowOpened** that can notify your application when the user has opened the controller
  - **activityWindowClosed** that can notify your application when the user has finished interacting with the controller. The notification carries two properties:
    - **activityType** [STRING] The type of activity that was chosen by the user
    - **completed** [BOOL] Notifies you if the activity was succesfully completed or not

Example:

    Social.addEventListener('activityWindowClosed', function(e) {
      alert("activity was completed? " + e.completed);
    });

## Events

#### update

The 'update' event is fired on the Social module eveytime something changes about a social
network authentication. The event is sent with the following param:

- *availability*: an object with the following key / values. Each value is a boolean value `true`
  or `false` indicating if you are able to send messages to the specified social network.

  - **twitter**: for the Twitter social network
  - **facebook**: for the Facebook social network
  - **sinaweibo**: for the Sina Weibo social network

Example usage:

    Social.addEventListener('update', function(e) {
      if(e.twitter) { Ti.API.warn("Can post to Twitter"); }
      if(e.facebook) { Ti.API.warn("Can post to Facebook"); }
      if(e.sinaweibo) { Ti.API.warn("Can post to Sinaweibo"); }
    });

### Constants

#### Social.DONE

#### Social.CANCELLED

Used when the [ComposerView](composer_view.html) finished sending a tweet.

#### Social.REQUEST_METHOD_GET

#### Social.REQUEST_METHOD_POST

#### Social.REQUEST_METHOD_DELETE

Used on [Request](request.html) to specify the type of request to be made to the social network

#### Social.TWITTER

#### Social.FACEBOOK

#### Social.SINAWEIBO

Used everytime we need to specify which social networking we are working, **except** when we dealing
with account objects (account store, account credentials, account). For that, use the constants bellow.

#### Social.ACCOUNT_TWITTER

#### Social.ACCOUNT_FACEBOOK

#### Social.ACCOUNT_SINAWEIBO

Used everytime we need to speicify which social networking we are working when dealing with 
account objects (account store, account credentials, account).

#### Social.FACEBOOK_APP_ID

#### Social.FACEBOOK_PERMISSIONS

#### Social.FACEBOOK_AUDIENCE

Used to specify Facebook options when creating or accessing the Facebook account store. The last
key `FACEBOOK_AUDIENCE` accepts one of the following:

  - **Social.FACEBOOK_AUDIENCE_EVERYONE**
  - **Social.FACEBOOK_AUDIENCE_FRIENDS**
  - **Social.FACEBOOK_AUDIENCE_ONLY_ME**

#### Social.RENEW_RESULT_RENEWED

#### Social.RENEW_RESULT_REJECTED

#### Social.RENEW_RESULT_FAILED

Used when renewing account credentials on the [AccountStore](account_store.html)

## Usage

Please see the example directory, since it contains several examples of all the API.

## Author

Rúben Fonseca, (C) 2012

