;
(function(win) {

  var site_namespace = win.__site_namespace__;

  var namespace = site_namespace + '.Modules.ModuleC';

  var logger = Logger.get(namespace);

  var ModuleC = Namespace(namespace);

  logger.info('Init');

}(window));