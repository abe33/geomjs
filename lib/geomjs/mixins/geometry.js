// Generated by CoffeeScript 1.4.0
(function() {
  var Geometry, Mixin, Point,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Mixin = require('./mixin');

  Point = require('../point');

  Geometry = (function(_super) {
    var pointsBounds;

    __extends(Geometry, _super);

    function Geometry() {
      return Geometry.__super__.constructor.apply(this, arguments);
    }

    Geometry.prototype.points = function() {};

    Geometry.prototype.closedGeometry = function() {
      return false;
    };

    pointsBounds = function(points, mode, axis, start) {
      return points.reduce((function(a, b) {
        return Math[mode](a, b[axis]);
      }), start);
    };

    Geometry.prototype.top = function() {
      return pointsBounds(this.points(), 'min', 'y', Infinity);
    };

    Geometry.prototype.bottom = function() {
      return pointsBounds(this.points(), 'max', 'y', -Infinity);
    };

    Geometry.prototype.left = function() {
      return pointsBounds(this.points(), 'min', 'x', Infinity);
    };

    Geometry.prototype.right = function() {
      return pointsBounds(this.points(), 'max', 'x', -Infinity);
    };

    Geometry.prototype.bounds = function() {
      return {
        top: this.top(),
        left: this.left(),
        right: this.right(),
        bottom: this.bottom()
      };
    };

    Geometry.prototype.boundingBox = function() {
      var Rectangle;
      Rectangle = require('../rectangle');
      return new Rectangle(this.left(), this.top(), this.right() - this.left(), this.bottom() - this.top());
    };

    Geometry.prototype.stroke = function(context, color) {
      if (color == null) {
        color = '#ff0000';
      }
      if (context == null) {
        return;
      }
      context.strokeStyle = color;
      this.drawPath(context);
      return context.stroke();
    };

    Geometry.prototype.fill = function(context, color) {
      if (color == null) {
        color = '#ff0000';
      }
      if (context == null) {
        return;
      }
      context.fillStyle = color;
      this.drawPath(context);
      return context.fill();
    };

    Geometry.prototype.drawPath = function(context) {
      var p, points, start, _i, _len;
      points = this.points();
      start = points.shift();
      context.beginPath();
      context.moveTo(start.x, start.y);
      for (_i = 0, _len = points.length; _i < _len; _i++) {
        p = points[_i];
        context.lineTo(p.x, p.y);
      }
      return context.closePath();
    };

    return Geometry;

  })(Mixin);

  module.exports = Geometry;

}).call(this);