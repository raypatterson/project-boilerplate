//= require_tree ./
;
(function(win) {

  var site_namespace = win.__site_namespace__;

  var namespace = site_namespace + '.Media.YouTube';

  var logger = Logger.get(namespace);

  var YouTube = Namespace(namespace);

  var hasFlash = function() {

    if (navigator.plugins !== null && navigator.plugins.length > 0) {
      return navigator.plugins["Shockwave Flash"] && true;
    }
    if (~navigator.userAgent.toLowerCase()
      .indexOf("webtv")) {
      return true;
    }
    if (~navigator.appVersion.indexOf("MSIE") && !~navigator.userAgent.indexOf("Opera")) {
      try {
        return new ActiveXObject("ShockwaveFlash.ShockwaveFlash") && true;
      } catch (e) {}
    }
    return false;
  }();

  var that = this;
  var $win = $(win);
  var $playerContainer;
  var $playerTarget;

  var getElementDimensions = function($el) {
    var width = $el
      .width();
    var height = Math.floor(width * (9 / 16));
    return {
      width: width,
      height: height
    };
  };

  var resizeElement = function($el) {
    var dimensions = getElementDimensions($playerTarget);
    $el.width(dimensions.width + 'px');
    $el.height(dimensions.height + 'px');
  };

  var resizePlayer = function() {
    resizeElement($playerContainer);
  };

  var createPlayer = function($el, videoId) {

    $playerTarget = $el;

    var attributes = '';
    attributes += ' controls';
    attributes += ' autoplay';
    attributes += ' preload="auto"';

    var options = {
      plugins: ['youtube'],
      success: function(mediaElement, domObject) {

        logger.info('Initilization Success');

        resizePlayer();

        $win.on('resize', function() {
          resizePlayer();
        });

        $win.on('orientationchange', function() {
          resizePlayer();
        });
      },
      error: function(msg) {

        logger.error('Initilization Error', msg);

      }
    };

    if (hasFlash === true) {
      var dimensions = getElementDimensions($playerTarget);
      attributes += ' width=' + dimensions.width;
      attributes += ' height=' + dimensions.height;
      attributes += ' style="width:100%; height:100%;"';
    } else {
      options.defaultVideoWidth = '100%';
      options.defaultVideoHeight = '100%';
    }

    var template = JST['watch/library/media/youtube/templates/player'];

    var html = template({
      id: videoId,
      attributes: attributes
    });

    $playerTarget.html(html)
      .ready(function() {

        $playerContainer = $playerTarget.find('.video-player-container');

        $('video')
          .mediaelementplayer(options);
      });
  };

  // Expose API

  YouTube.createPlayer = createPlayer;

}(window));