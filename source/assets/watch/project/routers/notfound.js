;
(function(win) {

  var site_namespace = win.__site_namespace__;

  var namespace = site_namespace + '.Routers';

  var logger = Logger.get(namespace);

  var Routers = Namespace(namespace);

  var Controller = Marionette.Controller.extend({

    notfound: function() {
      logger.info('Not Found');
      Routers.notfound.navigate('', {
        trigger: true
      });
    }
  });

  var Router = Backbone.Marionette.AppRouter.extend({
    controller: new Controller(),
    appRoutes: {
      '*notfound': 'notfound'
    }
  });

  Routers.notfound = new Router();

}(window));