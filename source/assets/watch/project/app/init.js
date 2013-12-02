;
(function(win) {

  var site_namespace = win.__site_namespace__;

  var namespace = site_namespace + '.App';

  var logger = Logger.get(namespace);

  var App = Namespace(namespace);

  App.start = function() {

    logger.info('Application Start');

  };

}(window));