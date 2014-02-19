;
(function() {
  var re = /\/page\//gi;
  if (window.location.toString()
    .search(re) !== -1) {
    window.location.href = window.location.href.replace(re, '/#/');
  }
}());