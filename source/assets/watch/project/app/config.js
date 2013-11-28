;
(function(win) {

  var site_namespace = win.__site_namespace__;

  var namespace = site_namespace + '.Config';

  var logger = Logger.get(namespace);

  var Config = Namespace(namespace);

  Config.touch = Modernizr.touch;

  // Activate Handlebars
  // Backbone.Marionette.TemplateCache.prototype.compileTemplate = function(rawTemplate) {
  //   return Handlebars.compile(rawTemplate);
  // };

  Backbone.Marionette.Renderer.render = function(template, data) {
    var compiled = template(data);
    console.log('template : ', template);
    console.log('data : ', data);
    console.log('compiled : ', compiled);
    return compiled;
  };

  // Handlebars.logger.log = Logger.get('Handlebars')
  //   .info;

}(window));