module.exports = function(grunt) {

  /**
   * Load required Grunt tasks. These are installed based on the versions listed
   * in `package.json` when you do `npm install` in this directory.
   */
  require('load-grunt-tasks')(grunt);
  require('time-grunt')(grunt);

  /**
   * Load task utils.
   */
  grunt.loadTasks(__dirname + '/grunt/utils');

  /**
   * We read in our `package.json` file so we can access the package name and
   * version. It's already there, so we don't repeat ourselves here.
   */
  var taskConfig = {
    pkg: grunt.file.readJSON(__dirname + '/package.json')
  };

  /**
   * This is the configuration object Grunt uses to
   * give each plugin its instructions.
   */
  grunt.util._.extend(taskConfig, grunt.loadOptions(__dirname + '/grunt/tasks/options/'));

  /**
   * Load in our build configuration file.
   */
  grunt.util._.extend(taskConfig, require(__dirname + '/Gruntfile.config.js'));

  /**
   * Initialize task config options.
   */
  grunt.initConfig(taskConfig);

  /**
   * Load tasks
   */
  grunt.loadTasks(__dirname + '/grunt/tasks');

  /**
   * The default task is to build and compile.
   */
  grunt.registerTask('default', 'default');

  /**
   * Load NPM tasks
   */
  grunt.loadNpmTasks('grunt-phantomas');
  grunt.loadNpmTasks('grunt-s3');

};