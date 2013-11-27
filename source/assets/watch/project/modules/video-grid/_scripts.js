;
(function(win) {

  var site_namespace = win.__site_namespace__;

  var namespace = site_namespace + '.Modules.VideoGrid';

  var logger = Logger.get(namespace);

  var VideoGrid = Namespace(namespace);

  var App = Namespace(site_namespace + '.App');
  var Models = Namespace(site_namespace + '.Models');
  var Routers = Namespace(site_namespace + '.Routers');

  App.addRegions({
    videoGrid: '.module-video-grid'
  });

  var hasSlider = false;

  var initFlexslider = function(model) {

    if (hasSlider === false) {

      hasSlider = true;

      var itemsPerPage = 5;
      var startPageIndex = Math.floor(model.get('index') / itemsPerPage);

      var $slider = App.videoGrid.$el.find('.bxslider');

      $slider.bxSlider({
        pager: false,
        minSlides: itemsPerPage,
        maxSlides: itemsPerPage,
        moveSlides: itemsPerPage,
        startSlide: startPageIndex,
        slideWidth: 300,
        adaptiveHeight: true,
        onSliderLoad: function() {

          var $selectors = App.videoGrid.$el.find('.selector');

          $selectors.on('click', function(event) {

            var episodeId = $(event.currentTarget)
              .data('episode-id');

            Routers.video.controller.navigateToEpisode(episodeId);
          });
        }
      });
    }
  };

  var SelectorItemView = Backbone.Marionette.ItemView.extend({
    template: '#video-grid-template',
    tagName: 'li',
    events: {},
    initialize: function() {
      this.listenTo(this.model, 'selected', function(model) {

        var index = model.get('index');

        App.videoGrid.$el.find('li [data-index=' + index + ']')
          .addClass('selected');

        initFlexslider(model);
      });

      this.listenTo(this.model, 'deselected', function(model) {

        var index = model.get('index');

        App.videoGrid.$el.find('li [data-index=' + index + ']')
          .removeClass('selected');
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
      className: 'bxslider'
    });

    collectionView.on('show', function(view) {
      // Transition here
    });

    // Show
    App.videoGrid.show(collectionView);
  });

}(window));