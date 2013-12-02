;
(function(win) {

  var site_namespace = win.__site_namespace__;

  var namespace = site_namespace + '.Config';

  var logger = Logger.get(namespace);

  var Config = Namespace(namespace);

  // Access objects though Namespace
  var Main = Namespace(site_namespace + '.Main');

  // Environment detection
  var isUsingMockData = (Main.enviriomentType === 'localhost') ? true : false;

  // Feature detection
  Config.touch = Modernizr.touch;

}(window));