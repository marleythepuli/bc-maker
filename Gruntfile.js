
module.exports = function(grunt) {

  grunt.initConfig({
    faker: {
      my_task: {
        options: {
          jsonFormat: "config/app.json",
          out: 'tmp/app.json'
        }
      }
    }
  });

    grunt.loadNpmTasks('grunt-faker');

};
