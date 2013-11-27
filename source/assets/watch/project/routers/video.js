;
(function(win) {

  var site_namespace = win.__site_namespace__;

  var App = Namespace(site_namespace + '.App');
  var Models = Namespace(site_namespace + '.Models');

  var namespace = site_namespace + '.Routers';

  var logger = Logger.get(namespace);

  var Routers = Namespace(namespace);

  var Controller = Marionette.Controller.extend({

    default: function() {
      logger.info('Default');
      Models.videoCollection.at(0)
        .select();
    },

    video: function(id) {
      logger.info('Video');
      Models.videoCollection.where({
        video_id: id
      })[0].select();
    },

    episode: function(id) {
      logger.info('Episode');
      Models.videoCollection.where({
        episode_id: id
      })[0].select();
    },

    // Helper methods to keep all the route constants centralize.
    navigateToVideo: function(id) {
      Routers.video.navigate('video/' + id, {
        trigger: true
      });
    },

    navigateToEpisode: function(id) {
      Routers.video.navigate('episode/' + id, {
        trigger: true
      });
    }
  });

  var Router = Backbone.Marionette.AppRouter.extend({
    controller: new Controller(),
    appRoutes: {
      '': 'default',
      'video/:id': 'video',
      'episode/:id': 'episode'
    }
  });

  Routers.video = new Router();

}(window));