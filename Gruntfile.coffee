module.exports = (grunt) ->
  grunt.initConfig

    pkg: grunt.file.readJSON 'package.json'

    coffeelint:
      options:
        max_line_length:
          value: 200
        indentation:
          value: 2
        newlines_after_classes:
          level: 'error'
        no_empty_param_list:
          level: 'error'
        no_unnecessary_fat_arrows:
          level: 'ignore'
      dist:
        files: [
          { expand: yes, cwd: './', src: [ '*.coffee' ] }
        ]

    simplemocha:
      options:
        ui: 'bdd'
        reporter: 'spec'
        compilers: 'coffee:coffee-script'
        ignoreLeaks: no
      dist:
        src: [ 'test/**/*.coffee' ]

    coffee:
      options:
        sourceMap: yes
      compile:
        files: [{
          expand: yes
          cwd: 'src'
          src: [ '*.coffee' ]
          dest: 'dist'
          ext: '.js'
        }]

    watch:
      options:
        dateFormat: (time) ->
          grunt.log.writeln "The watch finished in #{time}ms"
      check:
        files: ['**/*.coffee']
        tasks: ['coffeelint']
      javascripts:
        files: ['src/**/*.coffee']
        tasks: ['coffee']

  # test, lint
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-simple-mocha'
  # compile
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-notify'
  # watch
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'build', ['coffee']
  grunt.registerTask 'test', ['coffeelint', 'simplemocha']
  grunt.registerTask 'default', ['build', 'watch']
