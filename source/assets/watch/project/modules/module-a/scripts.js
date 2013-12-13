;
(function(win) {

  var site_namespace = win.__site_namespace__;

  var namespace = site_namespace + '.Modules.ModuleA';

  var logger = Logger.get(namespace);

  var ModuleA = Namespace(namespace);

  logger.info('Init');

}(window));