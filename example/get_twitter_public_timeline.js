var Social = Ti.UI.currentWindow.Social;

var tableview = Ti.UI.createTableView();
Ti.UI.currentWindow.add(tableview);

var request = Social.createRequest({
  url: 'http://api.twitter.com/1/statuses/public_timeline.json',
  type: Social.TWITTER,
  method: Social.REQUEST_METHOD_GET
});

request.addEventListener('success', function(e) {
  var data = [];
  for(var i=0; i < e.data.length; i++) {
    var tweet = e.data[i];
    data.push({
      title: tweet.text
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
