;
(function(win, $) {

  var site_namespace = win.__site_namespace__;

  var namespace = site_namespace + '.Util.PromiseMaker';

  var logger = Logger.get(namespace);

  var PromiseMaker = Namespace(namespace);

  var promises = [];

  var getDeferred = function() {
    var deferred = $.Deferred();
    var promise = deferred.promise();
    promises.push(promise);
    return deferred;
  };

  var checkPromises = function(done, fail) {
    $.when.apply($, promises)
      .then(done, fail);
  };

  PromiseMaker.getDeferred = getDeferred;
  PromiseMaker.checkPromises = checkPromises;

}(window, jQuery));