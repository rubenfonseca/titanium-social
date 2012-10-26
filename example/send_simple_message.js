var Social = Ti.UI.currentWindow.Social;
var socialNetwork = Social.TWITTER;

var picker = Ti.UI.createPicker({
  top: 0
});

var data = [
  Ti.UI.createPickerRow({title:Social.TWITTER}),
  Ti.UI.createPickerRow({title:Social.FACEBOOK}),
  Ti.UI.createPickerRow({title:Social.SINAWEIBO})
];
picker.add(data);
picker.selectionIndicator = true;
picker.setSelectedRow(0, 0, false);
picker.addEventListener('change', function(e) {
  Ti.API.warn("Changing social network to " + e.row.title);
  socialNetwork = e.row.title;
});
Ti.UI.currentWindow.add(picker);

var button = Ti.UI.createButton({
  title: 'Show message composer',
  left: 10,
  right: 10,
  height: 40,
  bottom: 10
});

button.addEventListener('click', function(e) {
  var composer = Social.createComposerView({
    type: socialNetwork
  });
  composer.addEventListener('complete', function(e) {
    // compare e.result with Social.CANCELLED or Social.DONE
    // to proceed with your logic
  });
  composer.setInitialText("Hello world :)");
  composer.open();
});

Ti.UI.currentWindow.add(button);

