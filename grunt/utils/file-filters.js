module.exports = function(grunt) {

  console.log('Loaded : file-filters.js');

  /**
   * A utility function to get all app JavaScript sources.
   */
  function filterForJS(files) {
    return files.filter(function(file) {
      return file.match(/\.js$/);
    });
  }

  /**
   * A utility function to get all app CSS sources.
   */
  function filterForCSS(files) {
    return files.filter(function(file) {
      return file.match(/\.css$/);
    });
  }

  grunt.filterForJS = filterForJS;
  grunt.filterForCSS = filterForCSS;

};