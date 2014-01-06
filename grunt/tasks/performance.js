module.exports = function(grunt) {

  grunt.log.writeln('Loaded : performance.js');

  /**
   * The `performance` task.
   */
  grunt.registerTask('performance', function() {

    grunt.log.subhead('Testing performance of', process.env.SITE_URL);

    grunt.option('environment', process.env.ENVIRONMENT);
    grunt.option('site_url', process.env.SITE_URL);
    grunt.option('s3_access', process.env.S3_ACCESS_KEY_ID);
    grunt.option('s3_secret', process.env.S3_SECRET_KEY_ID);
    grunt.option('s3_bucket', process.env.S3_BUCKET);
    grunt.option('s3_region', process.env.S3_REGION);

    grunt.task.run(['phantomas', 's3:phantomas']);

    var report_url = '';
    report_url += 'http://';
    report_url += process.env.S3_BUCKET;
    report_url += '.s3-website-';
    report_url += process.env.S3_REGION;
    report_url += '.amazonaws.com/';
    report_url += process.env.ENVIRONMENT;
    report_url += '/phantomas';

    grunt.log.subhead('Report --> ', report_url);

  });

};