module.exports = (function() {
  'use strict';

  var Backbone = require('backbone');
  Backbone.$ = require('jquery');

  var HomeView = require('./views/home');

  return new HomeView();
})();
