//= require_tree ./
;
(function(win) {

  var site_namespace = win.__site_namespace__;

  var namespace = site_namespace + '.Modules.VideoPlayer';

  var logger = Logger.get(namespace);

  var App = Namespace(site_namespace + '.App');
  var Models = Namespace(site_namespace + '.Models');
  var YouTube = Namespace(site_namespace + '.Media.YouTube');

  var $videoPlayerTarget = $(".video-player-target");

  Models.videoCollection.on('selected', function(model) {

    YouTube.createPlayer($videoPlayerTarget, model.get('video_id'));

  });

}(window));