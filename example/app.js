// This is a test harness for your module
// You should do something interesting in this harness 
// to test out the module and to provide instructions 
// to users on how to use it by example.

var Social = require('com.0x82.social');
Ti.API.info("module is => " + Social);

var navigationWindow = Ti.UI.createWindow();
var window = Ti.UI.createWindow({
  backgroundColor: 'white',
  title: 'Social.framework'
});

var nav = Ti.UI.iPhone.createNavigationGroup({
  window: window
});
navigationWindow.add(nav);
navigationWindow.open();

var data = [
  { title:'Send Simple Message', hasChild:true, url:'send_simple_message.js', header:'Composer' },
  { title:'Get Twitter Accounts', hasChild:true, url:'get_twitter_accounts.js', header:'Accounts'},
  { title:'Create Twitter Account', hasChild:true, url:'create_twitter_account.js'},
  { title:'Get Facebook Accounts', hasChild:true, url:'get_facebook_accounts.js' },
  { title:'Create Facebook Account', hasChild:true, url:'create_facebook_account.js'},
  { title:'Get Sina Weibo Accounts', hasChild:true, url:'get_sinaweibo_accounts.js' },
  {title:"Get Twitter Public Timeline", hasChild:true, url:'get_twitter_public_timeline.js', header:'Twitter Requests'},
  {title:"Get Home Timeline (auth)", hasChild:true, url:'get_twitter_user_timeline.js'},
  {title:"Send Custom Tweet (auth)", hasChild:true, url:'send_custom_tweet.js'},
  {title:"Get Facebook Wall (auth)", hasChild:true, url:'get_facebook_wall.js', header: 'Facebook Requests'},
  {title:"Send Custom Facebook (auth)", hasChild:true, url:'send_custom_facebook.js'},
  {title:"Show Share Activity View", hasChild:true, url:'share_activity_view.js', header: 'Share View'}	
];

var tableViewOptions = {
  data: data,
  style: Ti.UI.iPhone.TableViewStyle.GROUPED
};

var tableView = Ti.UI.createTableView(tableViewOptions);
window.add(tableView);

tableView.addEventListener('click', function(e) {
  if(e.rowData.url) {
    var win = Ti.UI.createWindow({
      url: e.rowData.url,
      title: e.rowData.title,
      backgroundColor: 'white',
      Social: Social,
      nav: nav
    });

    nav.open(win, {animated:true});
  }
});
