// Generated by CoffeeScript 1.4.0
(function() {
  var Geometry, Point, Rectangle, Surface, Triangle;

  Point = require('./point');

  Surface = require('./surface');

  Geometry = require('./geometry');

  Rectangle = require('./rectangle');

  Triangle = (function() {

    Geometry.attachTo(Triangle);

    Surface.attachTo(Triangle);

    function Triangle(a, b, c) {
      if (!Point.isPoint(a)) {
        this.invalidPoint('a', a);
      }
      if (!Point.isPoint(b)) {
        this.invalidPoint('b', b);
      }
      if (!Point.isPoint(c)) {
        this.invalidPoint('c', c);
      }
      this.a = new Point(a);
      this.b = new Point(b);
      this.c = new Point(c);
    }

    ['ab', 'ac', 'ba', 'bc', 'ca', 'cb'].forEach(function(k) {
      var p1, p2, _ref;
      _ref = k.split(''), p1 = _ref[0], p2 = _ref[1];
      return Triangle.prototype[k] = function() {
        return this[p2].subtract(this[p1]);
      };
    });

    ['abc', 'bac', 'acb'].forEach(function(k) {
      var p1, p2, p3, _ref;
      _ref = k.split(''), p1 = _ref[0], p2 = _ref[1], p3 = _ref[2];
      return Triangle.prototype[k] = function() {
        return this["" + p2 + p1]().angleWith(this["" + p2 + p3]());
      };
    });

    Triangle.prototype.top = function() {
      return Math.min(this.a.y, this.b.y, this.c.y);
    };

    Triangle.prototype.bottom = function() {
      return Math.max(this.a.y, this.b.y, this.c.y);
    };

    Triangle.prototype.left = function() {
      return Math.min(this.a.x, this.b.x, this.c.x);
    };

    Triangle.prototype.right = function() {
      return Math.max(this.a.x, this.b.x, this.c.x);
    };

    Triangle.prototype.bounds = function() {
      return {
        top: this.top(),
        left: this.left(),
        right: this.right(),
        bottom: this.bottom()
      };
    };

    Triangle.prototype.boundingBox = function() {
      return new Rectangle(this.left(), this.top(), this.right() - this.left(), this.bottom() - this.top());
    };

    Triangle.prototype.closedGeometry = function() {
      return true;
    };

    Triangle.prototype.points = function() {
      return [this.a.clone(), this.b.clone(), this.c.clone(), this.a.clone()];
    };

    Triangle.prototype.acreage = function() {
      return this.ab().length() * this.bc().length() * Math.abs(Math.sin(this.abc())) / 2;
    };

    Triangle.prototype.length = function() {
      return this.ab().length() + this.bc().length() + this.ca().length();
    };

    Triangle.prototype.drawPath = function(context) {
      context.beginPath();
      context.moveTo(this.a.x, this.a.y);
      context.lineTo(this.b.x, this.b.y);
      context.lineTo(this.c.x, this.c.y);
      context.lineTo(this.a.x, this.a.y);
      return context.closePath();
    };

    Triangle.prototype.invalidPoint = function(k, v) {
      throw new Error("Invalid point " + v + " for vertex " + k);
    };

    return Triangle;

  })();

  module.exports = Triangle;

}).call(this);