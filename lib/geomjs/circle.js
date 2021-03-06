// Generated by CoffeeScript 1.4.0
(function() {
  var Circle, Cloneable, Equatable, Formattable, Geometry, Intersections, Memoizable, Parameterizable, Path, Point, Sourcable, Surface, Triangle, include;

  include = require('./include').include;

  Point = require('./point');

  Triangle = require('./triangle');

  Equatable = require('./mixins/equatable');

  Cloneable = require('./mixins/cloneable');

  Sourcable = require('./mixins/sourcable');

  Formattable = require('./mixins/formattable');

  Memoizable = require('./mixins/memoizable');

  Parameterizable = require('./mixins/parameterizable');

  Geometry = require('./mixins/geometry');

  Surface = require('./mixins/surface');

  Path = require('./mixins/path');

  Intersections = require('./mixins/intersections');

  Circle = (function() {
    var iterators;

    include([
      Equatable('x', 'y', 'radius'), Formattable('Circle', 'x', 'y', 'radius'), Parameterizable('circleFrom', {
        radius: 1,
        x: 0,
        y: 0,
        segments: 36
      }), Sourcable('geomjs.Circle', 'radius', 'x', 'y'), Memoizable, Cloneable, Geometry, Surface, Path, Intersections
    ])["in"](Circle);

    Circle.eachIntersections = function(geom1, geom2, block, data) {
      var ev, i, length, output, points, sv, _i, _ref, _ref1;
      if (data == null) {
        data = false;
      }
      if ((typeof geom2.classname === "function" ? geom2.classname() : void 0) === 'Circle') {
        _ref = [geom2, geom1], geom1 = _ref[0], geom2 = _ref[1];
      }
      points = geom2.points();
      length = points.length;
      output = [];
      for (i = _i = 0, _ref1 = length - 2; 0 <= _ref1 ? _i <= _ref1 : _i >= _ref1; i = 0 <= _ref1 ? ++_i : --_i) {
        sv = points[i];
        ev = points[i + 1];
        if (geom1.eachLineIntersections(sv, ev, block)) {
          return;
        }
      }
    };

    Circle.eachCircleCircleIntersections = function(geom1, geom2, block, data) {
      var a, d, dv, h, hv, p, p1, p2, r1, r2, radii, _i, _len, _ref;
      if (data == null) {
        data = false;
      }
      if (geom1.equals(geom2)) {
        _ref = geom1.points();
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          p = _ref[_i];
          if (block.call(this, p)) {
            return;
          }
        }
      } else {
        r1 = geom1.radius;
        r2 = geom2.radius;
        p1 = geom1.center();
        p2 = geom2.center();
        d = p1.distance(p2);
        dv = p2.subtract(p1);
        radii = r1 + r2;
        if (d > radii) {
          return;
        }
        if (d === radii) {
          return block.call(this, p1.add(dv.normalize(r1)));
        }
        a = (r1 * r1 - r2 * r2 + d * d) / (2 * d);
        h = Math.sqrt(r1 * r1 - a * a);
        hv = new Point(h * (p2.y - p1.y) / d, -h * (p2.x - p1.x) / d);
        p = p1.add(dv.normalize(a)).add(hv);
        block.call(this, p);
        p = p1.add(dv.normalize(a)).add(hv.scale(-1));
        return block.call(this, p);
      }
    };

    iterators = Intersections.iterators;

    iterators['Circle'] = Circle.eachIntersections;

    iterators['CircleCircle'] = Circle.eachCircleCircleIntersections;

    function Circle(radiusOrCircle, x, y, segments) {
      var _ref;
      _ref = this.circleFrom(radiusOrCircle, x, y, segments), this.radius = _ref.radius, this.x = _ref.x, this.y = _ref.y, this.segments = _ref.segments;
    }

    Circle.prototype.center = function() {
      return new Point(this.x, this.y);
    };

    Circle.prototype.top = function() {
      return this.y - this.radius;
    };

    Circle.prototype.bottom = function() {
      return this.y + this.radius;
    };

    Circle.prototype.left = function() {
      return this.x - this.radius;
    };

    Circle.prototype.right = function() {
      return this.x + this.radius;
    };

    Circle.prototype.translate = function(xOrPt, y) {
      var x, _ref;
      _ref = Point.pointFrom(xOrPt, y), x = _ref.x, y = _ref.y;
      this.x += x;
      this.y += y;
      return this;
    };

    Circle.prototype.rotate = function() {
      return this;
    };

    Circle.prototype.scale = function(scale) {
      this.radius *= scale;
      return this;
    };

    Circle.prototype.points = function() {
      var n, step, _i, _ref, _results;
      step = Math.PI * 2 / this.segments;
      _results = [];
      for (n = _i = 0, _ref = this.segments; 0 <= _ref ? _i <= _ref : _i >= _ref; n = 0 <= _ref ? ++_i : --_i) {
        _results.push(this.pointAtAngle(n * step));
      }
      return _results;
    };

    Circle.prototype.triangles = function() {
      var center, i, points, triangles, _i, _ref;
      if (this.memoized('triangles')) {
        return this.memoFor('triangles');
      }
      triangles = [];
      points = this.points();
      center = this.center();
      for (i = _i = 1, _ref = points.length - 1; 1 <= _ref ? _i <= _ref : _i >= _ref; i = 1 <= _ref ? ++_i : --_i) {
        triangles.push(new Triangle(center, points[i - 1], points[i]));
      }
      return this.memoize('triangles', triangles);
    };

    Circle.prototype.closedGeometry = function() {
      return true;
    };

    Circle.prototype.eachLineIntersections = function(a, b, block) {
      var c, cc, deter, e, u1, u2, _a, _b;
      c = this.center();
      _a = (b.x - a.x) * (b.x - a.x) + (b.y - a.y) * (b.y - a.y);
      _b = 2 * ((b.x - a.x) * (a.x - c.x) + (b.y - a.y) * (a.y - c.y));
      cc = c.x * c.x + c.y * c.y + a.x * a.x + a.y * a.y - 2 * (c.x * a.x + c.y * a.y) - this.radius * this.radius;
      deter = _b * _b - 4 * _a * cc;
      if (deter > 0) {
        e = Math.sqrt(deter);
        u1 = (-_b + e) / (2 * _a);
        u2 = (-_b - e) / (2 * _a);
        if (!((u1 < 0 || u1 > 1) && (u2 < 0 || u2 > 1))) {
          if (0 <= u2 && u2 <= 1) {
            if (block.call(this, Point.interpolate(a, b, u2))) {
              return;
            }
          }
          if (0 <= u1 && u1 <= 1) {
            if (block.call(this, Point.interpolate(a, b, u1))) {

            }
          }
        }
      }
    };

    Circle.prototype.pointAtAngle = function(angle) {
      return new Point(this.x + Math.cos(angle) * this.radius, this.y + Math.sin(angle) * this.radius);
    };

    Circle.prototype.acreage = function() {
      return this.radius * this.radius * Math.PI;
    };

    Circle.prototype.contains = function(xOrPt, y) {
      var pt;
      pt = Point.pointFrom(xOrPt, y, true);
      return this.center().subtract(pt).length() <= this.radius;
    };

    Circle.prototype.randomPointInSurface = function(random) {
      var center, dif, pt;
      if (random == null) {
        random = new chancejs.Random(new chancejs.MathRandom);
      }
      pt = this.pointAtAngle(random.random(Math.PI * 2));
      center = this.center();
      dif = pt.subtract(center);
      return center.add(dif.scale(Math.sqrt(random.random())));
    };

    Circle.prototype.length = function() {
      return this.radius * Math.PI * 2;
    };

    Circle.prototype.pathPointAt = function(n) {
      return this.pointAtAngle(n * Math.PI * 2);
    };

    Circle.prototype.drawPath = function(context) {
      context.beginPath();
      return context.arc(this.x, this.y, this.radius, 0, Math.PI * 2);
    };

    Circle.prototype.memoizationKey = function() {
      return "" + this.radius + ";" + this.x + ";" + this.y + ";" + this.segments;
    };

    return Circle;

  })();

  module.exports = Circle;

}).call(this);
