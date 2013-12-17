;
(function(window, $) {

  var list = [
    'mobile-portrait',
    'mobile-landscape',
    'tablet-portrait',
    'tablet-landscape',
    'desktop-small',
    'desktop-medium',
    'desktop-large'
  ];

  var $el = $('body');
  var el = $el[0];

  $(list)
    .each(function(key, val) {
      Breakpoints.on({
        name: val,
        el: el,
        matched: function() {
          $el.addClass(val);
        },
        exit: function() {
          $el.removeClass(val);
        }
      });
    });
}(this, this.jQuery));