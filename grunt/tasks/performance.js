module.exports = function(grunt) {

  grunt.log.writeln('Loaded : performance.js');

  /**
   * The `performance` task.
   */

  grunt.registerTask('performancecomplete', function() {

    var url = '';
    url += 'http://';
    url += process.env.REPORTS_S3_BUCKET;
    url += '.s3-website-';
    url += process.env.REPORTS_S3_REGION;
    url += '.amazonaws.com/';
    url += process.env.ENVIRONMENT;
    url += '/phantomas';

    grunt.log.writeln('');
    grunt.log.writeln('Performance Report Ready');
    grunt.log.subhead(url);
  });

  grunt.registerTask('performance', function() {

    grunt.log.subhead('Testing performance of', process.env.SITE_URL);

    grunt.option('environment', process.env.ENVIRONMENT);
    grunt.option('site_url', process.env.SITE_URL);
    grunt.option('s3_access', process.env.AWS_ACCESS_ID);
    grunt.option('s3_secret', process.env.AWS_SECRET_ID);
    grunt.option('s3_bucket', process.env.REPORTS_S3_BUCKET);
    grunt.option('s3_region', process.env.REPORTS_S3_REGION);

    grunt.task.run(['phantomas', 's3:phantomas', 'performancecomplete']);

  });

};