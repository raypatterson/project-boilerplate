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

  var hasSlider = false;

  var initFlexslider = function(model) {

    var index = model.get('index');
    var $el = App.videoSelector.$el;

    if (hasSlider === true) {

      $el.flexslider(index);

    } else {

      hasSlider = true;

      $el.flexslider({
        startAt: index,
        animation: 'slide',
        animationLoop: true,
        controlNav: false,
        smoothHeight: false
      });
    }
  };

  var SelectorItemView = Backbone.Marionette.ItemView.extend({
    template: '#video-selector-template',
    tagName: 'li',
    events: {
      'click .selector': function(event) {

        var episodeId = this.model.get('episode_id');

        Routers.video.controller.navigateToEpisode(episodeId);
      }
    },
    initialize: function() {
      this.listenTo(this.model, 'selected', function(model) {
        this.$el.addClass('selected');

        initFlexslider(model);
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
      className: 'slides'
    });

    collectionView.on('show', function(view) {
      // Transition here
    });

    // Show
    App.videoSelector.show(collectionView);
  });

}(window));