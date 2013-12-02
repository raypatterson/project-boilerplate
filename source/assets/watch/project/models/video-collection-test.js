(function(win) {

  var site_namespace = win.__site_namespace__;

  var Main = Namespace(site_namespace + '.Main');
  var App = Namespace(site_namespace + '.App');
  var Models = Namespace(site_namespace + '.Models');

  var Model = Backbone.Model.extend({
    initialize: function() {
      var selectable = new Backbone.Picky.Selectable(this);
      _.extend(this, selectable);
    }
  });

  var Collection = Backbone.Collection.extend({
    comparator: function(model) {
      var index = this.indexOf(model);
      model.set('index', index);
      model.set('episode_id', (index + 1)
        .toString());
      return model;
    },
    initialize: function() {
      var singleSelect = new Backbone.Picky.SingleSelect(this);
      _.extend(this, singleSelect);
    },
    model: Model
  });

  // Expose model
  Models.videoCollection = new Collection(Main.Data.video_collection);

}(window));