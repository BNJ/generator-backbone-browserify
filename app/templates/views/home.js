module.exports = (function() {
  'use strict';

  var Backbone = require('backbone'),
    template = require('../templates/home.haml');

  return Backbone.View.extend({
    el: '#main',

    initialize: function() {
      this.render();
    },

    render: function() {
      this.$el.html(template({platform: 'Backbone'}));
      return this.el;
    }

  });

})();
