;
(function(win, doc, $) {

  $(doc)
    .ready(function() {
      var $contentWrapper = $('.content-wrapper');
      var delay = parseInt($contentWrapper.data('fouc-fade-in-delay'), 10) || 1000;
      var duration = parseInt($contentWrapper.data('fouc-fade-in-duration'), 10) || 500;
      $contentWrapper
        .css({
          'opacity': 0,
          'display': 'block'
        });
      var t = setTimeout(function() {
        clearTimeout(t);
        $contentWrapper.animate({
          opacity: 1
        }, {
          duration: duration,
          complete: function() {
            // console.log('FOUC Complete');
          }
        });
      }, delay);

    });

}(this, document, $));