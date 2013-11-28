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

  var getElementDimensions = function($el) {
    var width = $el
      .width();
    var height = Math.floor(width * (9 / 16));
    return {
      width: width,
      height: height
    };
  };

  var resizeElement = function($el, $playerTarget) {
    var dimensions = getElementDimensions($playerTarget);
    $el.width(dimensions.width + 'px');
    $el.height(dimensions.height + 'px');
  };

  var createPlayer = function($playerTarget, videoId) {

    // var template = Handlebars.compile($("#video-player-template")
    // .html());
    var template = HandlebarsTemplates["watch/handlebars/youtube"];

    console.log('Template:', template);

    var attributes = '';
    attributes += ' controls';
    attributes += ' autoplay';
    attributes += ' preload="auto"';

    var options = {
      plugins: ['youtube']
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

    var html = template({
      id: videoId,
      attributes: attributes
    });

    $playerTarget.html(html)
      .ready(function() {

        var $playerContainer = $playerTarget.find('.video-player-container');

        resizeElement($playerContainer, $playerTarget);

        $('video')
          .mediaelementplayer(options);

        var $win = $(win);

        $win.on('resize', function() {
          resizeElement($playerContainer, $playerTarget);
        });

        $win.on('orientationchange', function() {
          resizeElement($playerContainer, $playerTarget);
        });
      });
  };

  // Expose API

  YouTube.createPlayer = createPlayer;

}(window));