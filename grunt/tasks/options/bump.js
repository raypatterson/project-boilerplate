/**
 * Increments the version number, etc.
 */
module.exports = {
  options: {
    files: [
          "package.json",
          "bower.json"
        ],
    commit: false,
    commitMessage: 'chore(release): v%VERSION%',
    commitFiles: [
          "package.json",
          "client/bower.json"
        ],
    createTag: false,
    tagName: 'v%VERSION%',
    tagMessage: 'Version %VERSION%',
    push: false,
    pushTo: 'origin'
  }
};