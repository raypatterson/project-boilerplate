;
(function(win) {

  var site_namespace = win.__site_namespace__;

  var namespace = site_namespace + '.App';

  var logger = Logger.get(namespace);

  var App = Namespace(namespace);

  var Util = Namespace(site_namespace + '.Util');

  $(function() {

    var done = function() {
      logger.info('Start Success');
    };

    var fail = function() {
      logger.error('!!! Start Failure !!!');
    };

    Util.PromiseMaker.checkPromises(done, fail);
  });

}(window));