module.exports = (grunt) ->
  path = require 'path'
  require('time-grunt')(grunt)
  require('load-grunt-tasks')(grunt)

  # Browserify transforms
  debowerify = require 'debowerify'
  hamlify = require 'hamlify'

  lrSnippet  = require('grunt-contrib-livereload/lib/utils').livereloadSnippet
  mountFolder = (connect, dir) ->
    connect.static path.resolve dir

  config =
    src: 'app'
    dest: '.tmp'
    build: 'build'

  # Project configuration.
  grunt.initConfig
    config: config
    watch:
      options:
        livereload: true
      compass:
        files: ['<%%= config.src %>/stylesheets/**/*.scss']
        tasks: [
          "compass:dev"
        ]
      watchify:
        files: '<%%= config.dest %>/site.js'
        tasks: ['jshint']
      haml:
        files: ['<%%= config.src %>/*.haml']
        tasks: ['haml']
    watchify:
      options:
        debug: true
        callback: (b) ->
          b.transform debowerify
          b.transform hamlify
          b
      dev:
        src: './<%%= config.src %>/{lib,models,templates,views,}/*.js'
        dest: '<%%= config.dest %>/site.js'
    compass:
      options:
        relativeAssets: true
        boring: true
        sassDir: '<%%= config.src %>/stylesheets'
        cssDir: '<%%= config.dest %>/stylesheets'
      dev:
        options:
          outputStyle: 'expanded'
      build:
        options:
          outputStyle: 'compressed'
    haml:
      dev:
        options:
          language: 'coffee'
        files: [
          expand: true
          cwd: '<%%= config.src %>'
          src: '*.haml'
          dest: '<%%= config.dest %>'
          ext: '.html'
        ]
    jshint:
      options:
        jshintrc: '.jshintrc'
        reporter: require 'jshint-stylish'
      all: '<%%= config.src %>/{lib,models,templates,views,}/*.js'
    connect:
      options:
        port: 9000
        hostname: 'localhost'
      livereload:
        options:
          middleware: (connect) ->
            [
              lrSnippet
              mountFolder connect, config.dest
              mountFolder connect, config.src
            ]
      build:
        options:
          keepalive: true
          middleware: (connect) ->
            [
              mountFolder connect, config.build
            ]
    copy:
      build:
        files: [
          expand: true
          cwd: '<%%= config.src %>'
          src: 'fonts/**/*.*'
          dest: '<%%= config.dest %>'
        ]
    uglify:
      build:
        files:
          '<%%= config.dest %>/site.js': '<%%= config.dest %>/site.js'
    imagemin:
      options:
        cache: false
      build:
        files: [
          expand: true
          cwd: '<%%= config.src %>/images'
          src: '**/*.{gif,jpeg,jpg,png}'
          dest: '<%%= config.dest %>/images'
        ]
    svgmin:
      build:
        files: [
          expand: true
          cwd: '<%%= config.src %>/images'
          src: '**/*.svg'
          dest: '<%%= config.dest %>/images'
        ]
    modernizr:
      build:
        devFile: '<%%= config.src %>/components/modernizr/modernizr.js'
        outputFile: '<%%= config.dest %>/components/modernizr/modernizr.js'
        files:
          src: [
            '<%%= config.src %>/**/*'
            '!<%%= config.src %>/components/**'
          ]
        uglify: true
    clean:
      dest: '<%%= config.dest %>'

  #Register tasks
  grunt.registerTask 'dev', [
    'compass'
    'haml'
    'watchify'
    'modernizr'
    'connect:livereload'
  ]

  grunt.registerTask 'build', ->
    grunt.config 'config.dest', config.build
    grunt.task.run [
      'jshint'
      'clean'
      'compass:build'
      'haml'
      'watchify'
      'copy'
      'uglify'
      'imagemin'
      'svgmin'
      'modernizr'
    ]

  # Register the default tasks.
  grunt.registerTask 'default', [
    'dev'
    'watch'
  ]
