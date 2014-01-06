module.exports = function(grunt) {

  console.log('Loaded : load-options.js');

  /**
   * Loads and formats options
   */
  function loadOptions(path) {
    var glob = require('glob');
    var object = {};
    var key;

    glob.sync('*', {
      cwd: path
    }).forEach(function(option) {
      key = option.replace(/\.js$/, '');
      object[key] = require(path + option);
    });

    return object;
  }

  grunt.loadOptions = loadOptions;

};