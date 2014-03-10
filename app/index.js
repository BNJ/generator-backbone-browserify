'use strict';
var util = require('util');
var path = require('path');
var yeoman = require('yeoman-generator');
var chalk = require('chalk');


var BackboneBrowserifyGenerator = yeoman.generators.Base.extend({
  init: function () {
    this.pkg = require('../package.json');

    this.on('end', function () {
      if (!this.options['skip-install']) {
        this.installDependencies();
        //this.runInstall('rvm', ['rvmrc', 'load']);
        /*this.spawnCommand('rvm', ['rvmrc', 'load']).on('exit', function(err) {
          if (!err)
            this.runInstall('bundle');
        }.bind(this));*/
      }
    });
  },

  askFor: function () {
    //var done = this.async();

    // have Yeoman greet the user
    this.log(this.yeoman);

    // replace it with a short and sweet description of your generator
    this.log(chalk.magenta('You\'re using the fantastic BackboneBrowserify generator.'));
  },

  app: function () {
    this.mkdir('app');
    this.mkdir('app/fonts');
    this.mkdir('app/images');
    this.mkdir('app/lib');
    this.mkdir('app/models');
    this.mkdir('app/stylesheets');
    this.mkdir('app/templates');
    this.mkdir('app/views');

    this.copy('stylesheets/site.scss', 'app/stylesheets/site.scss');
    this.copy('templates/home.haml', 'app/templates/home.haml');
    this.copy('views/home.js', 'app/views/home.js');
    this.copy('main.js', 'app/main.js');
    this.copy('index.haml', 'app/index.haml');
  },

  projectfiles: function () {
    this.copy('_package.json', 'package.json');
    this.copy('_bower.json', 'bower.json');
    this.copy('_Gemfile', 'Gemfile');
    this.copy('Gruntfile.coffee', 'Gruntfile.coffee');
    this.copy('bowerrc', '.bowerrc');
    this.copy('config.rb', 'config.rb');
    this.copy('editorconfig', '.editorconfig');
    this.copy('gitignore', '.gitignore');
    this.copy('jshintrc', '.jshintrc');
    this.copy('rvmrc', '.rvmrc');
  }
});

module.exports = BackboneBrowserifyGenerator;
