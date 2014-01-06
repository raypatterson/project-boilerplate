module.exports = {
  options: {
    key: '<%= grunt.option("s3_access") %>',
    secret: '<%= grunt.option("s3_secret") %>',
    bucket: '<%= grunt.option("s3_bucket") %>',
    region: '<%= grunt.option("s3_region") %>',
    access: 'public-read'
  },
  phantomas: {
    sync: [
      {
        // only upload this document if it does not exist already
        src: '<%= phantomas.test.options.indexPath %>**/*',
        dest: '<%= grunt.option("environment") + "/" + phantomas.test.options.indexPath %>',
        rel: '<%= phantomas.test.options.indexPath %>',
        options: {
          gzip: true,
          verify: true
        }
      }
    ]
  }
};