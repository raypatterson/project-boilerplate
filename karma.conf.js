// Karma configuration
// Generated on Thu Dec 19 2013 10:52:32 GMT-0800 (PST)

var glob = require("glob");

module.exports = function(config) {

  console.log('Karma Test Runner');

  config.set({

    // base path, that will be used to resolve files and exclude
    basePath: '',

    // frameworks to use
    frameworks: ['jasmine'],

    files: [
      {
        pattern: 'http://localhost:8888/assets/main.js',
        watched: true,
        included: true,
        served: true
      },
      {
        pattern: 'tests/*.js',
        watched: true,
        included: true,
        served: true
      }
    ],


    // list of files to exclude
    exclude: [
      '**/*.coffee',
      '**/*.jpg',
      '**/*.png',
      '**/*.gif',
      '**/*.scss',
      '**/*.css'
    ],


    // test results reporter to use
    // possible values: 'dots', 'progress', 'junit', 'growl', 'coverage'
    reporters: ['progress'],


    // web server port
    port: 9876,


    // enable / disable colors in the output (reporters and logs)
    colors: true,


    // level of logging
    // possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
    logLevel: config.LOG_INFO,


    // enable / disable watching file and executing tests whenever any file changes
    autoWatch: true,


    // Start these browsers, currently available:
    // - Chrome
    // - ChromeCanary
    // - Firefox
    // - Opera (has to be installed with `npm install karma-opera-launcher`)
    // - Safari (only Mac; has to be installed with `npm install karma-safari-launcher`)
    // - PhantomJS
    // - IE (only Windows; has to be installed with `npm install karma-ie-launcher`)
    browsers: ['Chrome'],


    // If browser does not capture in given timeout [ms], kill it
    captureTimeout: 60000,


    // Continuous Integration mode
    // if true, it capture browsers, run tests and exit
    singleRun: false
  });
};