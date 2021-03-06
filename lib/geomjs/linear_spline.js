// Generated by CoffeeScript 1.4.0
(function() {
  var Formattable, Geometry, Intersections, LinearSpline, Path, Point, Sourcable, Spline, include;

  include = require('./include').include;

  Point = require('./point');

  Formattable = require('./mixins/formattable');

  Sourcable = require('./mixins/sourcable');

  Intersections = require('./mixins/intersections');

  Geometry = require('./mixins/geometry');

  Spline = require('./mixins/spline');

  Path = require('./mixins/path');

  LinearSpline = (function() {

    include([Formattable('LinearSpline'), Sourcable('geomjs.LinearSpline', 'vertices', 'bias'), Geometry, Path, Intersections, Spline(1)])["in"](LinearSpline);

    function LinearSpline(vertices, bias) {
      this.initSpline(vertices, bias);
    }

    LinearSpline.prototype.points = function() {
      var vertex, _i, _len, _ref, _results;
      _ref = this.vertices;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        vertex = _ref[_i];
        _results.push(vertex.clone());
      }
      return _results;
    };

    LinearSpline.prototype.segments = function() {
      return this.vertices.length - 1;
    };

    LinearSpline.prototype.validateVertices = function(vertices) {
      return vertices.length >= 2;
    };

    LinearSpline.prototype.drawVerticesConnections = function() {};

    return LinearSpline;

  })();

  module.exports = LinearSpline;

}).call(this);
