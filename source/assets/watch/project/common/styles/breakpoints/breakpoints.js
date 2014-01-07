;
(function(window, $) {

  var $el = $('body');
  var el = $el[0];

  breakpoints = $('head')
    .css('font-family')
    .replace(/"/g, '')
    .replace(/'/g, '')
    .split(' ');

  $.each(breakpoints, function(key, val) {

    Breakpoints.on({
      name: val,
      el: el,
      matched: function() {

        console.log("Breakpoint : matched :", val);

        $el.addClass(val);
      },
      exit: function() {

        console.log("Breakpoint : exit :", val);

        $el.removeClass(val);
      }
    });
  });

}(this, this.jQuery));