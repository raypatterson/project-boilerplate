;
(function(win) {

  var site_namespace = win.__site_namespace__;

  var namespace = site_namespace + '.App';

  var logger = Logger.get(namespace);

  var App = Namespace(namespace);

  var Util = Namespace(site_namespace + '.Util');

  App.on('start', function(options) {
    Backbone.history.start();
  });

  $(function() {

    Util.PromiseMaker.checkPromises(

      function() {

        logger.info('Start Success');

        App.start();
      },

      function() {
        logger.error('!!! Start Failure !!!');
      });
  });

}(window));