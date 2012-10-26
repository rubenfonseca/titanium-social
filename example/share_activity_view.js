var Social = Ti.UI.currentWindow.Social;

var share_text = function() {
  Social.showActivityItems({
    activityItems: ["Text to share"]
  });
}

var share_image = function() {
  var image = Ti.Filesystem.getFile('rails.png').read();
  Social.showActivityItems({
    activityItems: [image],
    excludedActivityTypes: [Social.UIActivityTypePostToWeibo]
  });
}

var share_text_image = function() {
  var image = Ti.Filesystem.getFile('rails.png').read();
  Social.showActivityItems({
    activityItems: ["Text with image to share", image],
    rect: {
      x: 0,
      y: 0,
      width: 300,
      height: 300
    },
    arrowDirection: Social.UIPopoverArrowDirectionLeft
  });
}

var data = [
  { title:'Share text', callback:share_text },
  { title:'Share image', callback:share_image },
  { title:'Share text and image', callback:share_text_image },
];

var tableViewOptions = {
  data: data,
  style: Ti.UI.iPhone.TableViewStyle.GROUPED
};

var tableView = Ti.UI.createTableView(tableViewOptions);
Ti.UI.currentWindow.add(tableView);

tableView.addEventListener('click', function(e) {
  e.rowData.callback();
});

Social.addEventListener('activityWindowOpened', function(e) {
  Ti.API.warn("----------------- WINDOW OPENED");
});

Social.addEventListener('activityWindowClosed', function(e) {
  Ti.API.warn("----------------- WINDOW CLOSED completed:" + e.completed + " activityType:" + e.activityType);
});
