;
(function(win, doc, $) {

  $(doc)
    .ready(function() {
      setTimeout(function() {
        win.scrollTo(0, 1);
      }, 250);
    });

}(this, document, $));