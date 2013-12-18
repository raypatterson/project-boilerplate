//= require_tree ./
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

  var collectionView;
  var $slider;

  // Slider
  new Backbone.Marionette.Controller()
    .listenTo(Models.videoCollection, 'selected', function(model) {
      createSlider(model, 4);
      this.close();

      new Backbone.Marionette.Controller()
        .listenTo(Models.videoCollection, 'selected', function(model) {
          updateSlider(model, 4);
        });
    });

  var updateSlider = function(model, itemsPerPage) {

    logger.info('Update Slider');

    var pageIndex = Math.floor(model.get('index') / itemsPerPage);

    $slider.goToSlide(pageIndex);
  };

  var createSlider = function(model, itemsPerPage) {

    logger.info('Create Slider');

    var pageIndex = Math.floor(model.get('index') / itemsPerPage);

    $slider = App.videoGrid.$el.find('.bxslider');

    $slider.bxSlider({
      pager: false,
      minSlides: itemsPerPage,
      maxSlides: itemsPerPage,
      moveSlides: itemsPerPage,
      startSlide: pageIndex,
      slideMargin: 10,
      slideWidth: 300,
      adaptiveHeight: true,
      onSliderLoad: function() {

        logger.info('Slider Ready');
      }
    });
  };

  var SelectorItemView = Backbone.Marionette.ItemView.extend({
    template: JST['watch/project/modules/video-grid/templates/item'],
    tagName: 'li',
    events: {},
    initialize: function() {

      this.listenTo(this.model, 'selected', function(model) {

        var index = model.get('index');

        App.videoGrid.$el.find('li [data-index=' + index + ']')
          .addClass('selected');
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
    collectionView = new Backbone.Marionette.CollectionView({
      itemView: SelectorItemView,
      collection: Models.videoCollection,
      tagName: 'ul',
      className: 'bxslider',
      events: {
        'click .selector': function(event) {

          var episodeId = $(event.currentTarget)
            .data('episode-id');

          Routers.video.controller.navigateToEpisode(episodeId);
        }
      }
    });

    // Show
    App.videoGrid.show(collectionView);
  });

}(window));