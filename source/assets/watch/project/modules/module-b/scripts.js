;
(function(win) {

  var site_namespace = win.__site_namespace__;

  var namespace = site_namespace + '.Modules.ModuleB';

  var logger = Logger.get(namespace);

  var ModuleB = Namespace(namespace);

  logger.info('Init');

}(window));