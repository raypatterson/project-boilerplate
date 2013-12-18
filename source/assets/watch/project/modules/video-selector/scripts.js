//= require_tree ./
;
(function(win) {

  var site_namespace = win.__site_namespace__;

  var namespace = site_namespace + '.Modules.VideoSelector';

  var logger = Logger.get(namespace);

  var VideoSelector = Namespace(namespace);

  var App = Namespace(site_namespace + '.App');
  var Models = Namespace(site_namespace + '.Models');
  var Routers = Namespace(site_namespace + '.Routers');

  App.addRegions({
    videoSelector: '.module-video-selector .flexslider'
  });

  // Slider
  new Backbone.Marionette.Controller()
    .listenTo(Models.videoCollection, 'selected', function(model) {
      createSlider(model);
      this.close();

      new Backbone.Marionette.Controller()
        .listenTo(Models.videoCollection, 'selected', function(model) {
          updateSlider(model);
        });
    });

  var hasSlider = false;

  var createSlider = function(model) {

    var index = model.get('index') + 1;
    var $el = App.videoSelector.$el;

    $el.flexslider({
      startAt: index,
      animation: 'slide',
      animationLoop: true,
      controlNav: false,
      smoothHeight: false,
      after: function(slider) {
        // console.log('After: ', slider);
      }
    });
  };

  var updateSlider = function(model) {

    var index = model.get('index') + 1;
    var $el = App.videoSelector.$el;

    $el.flexslider(index);
  };

  var SelectorItemView = Backbone.Marionette.ItemView.extend({
    template: JST['watch/project/modules/video-selector/templates/item'],
    tagName: 'li',
    events: {},
    initialize: function() {
      this.listenTo(this.model, 'selected', function(model) {
        this.$el.addClass('selected');
      });
      this.listenTo(this.model, 'deselected', function(model) {
        this.$el.removeClass('selected');
      });
    }
  });

  App.addInitializer(function(options) {

    logger.info('Init');

    // Init CollectionView
    var collectionView = new Backbone.Marionette.CollectionView({
      itemView: SelectorItemView,
      collection: Models.videoCollection,
      tagName: 'ul',
      className: 'slides',
      events: {
        'click .selector': function(event) {

          var episodeId = $(event.currentTarget)
            .data('episode-id');

          Routers.video.controller.navigateToEpisode(episodeId);
        }
      }
    });

    // Show
    App.videoSelector.show(collectionView);
  });

}(window));