;
(function(win, doc, $) {

  $(doc)
    .ready(function() {
      setTimeout(win.scrollTo, 200, 0, 1);
    });

}(this, document, jQuery));