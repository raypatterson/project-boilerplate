;
(function(win) {

  Backbone.Marionette.Renderer.render = function(template, data) {
    return template(data);
  };

}(window));