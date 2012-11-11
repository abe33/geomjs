(function() {
  var Circle, Ellipsis, Equatable, Formattable, Geometry, Matrix, Mixin, Path, Point, Rectangle, Surface, Triangle,
    __slice = [].slice,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.geomjs || (this.geomjs = {});

  /* src/geomjs/math.coffee */;


  Math.degToRad = function(n) {
    return n * Math.PI / 180;
  };

  Math.radToDeg = function(n) {
    return n * 180 / Math.PI;
  };

  Math.normalize = function(value, minimum, maximum) {
    return (value - minimum) / (maximum - minimum);
  };

  Math.interpolate = function(normValue, minimum, maximum) {
    return minimum + (maximum - minimum) * normValue;
  };

  Math.deltaBelowRatio = function(a, b, ratio) {
    if (ratio == null) {
      ratio = 10000000000;
    }
    return Math.abs(a - b) < 1 / ratio;
  };

  Math.map = function(value, min1, max1, min2, max2) {
    return Math.interpolate(Math.normalize(value, min1, max1), min2, max2);
  };

  /* src/geomjs/mixin.coffee */;


  Mixin = (function() {

    function Mixin() {}

    Mixin.attachTo = function(klass) {
      var k, v, _ref, _results;
      _ref = this.prototype;
      _results = [];
      for (k in _ref) {
        v = _ref[k];
        _results.push(klass.prototype[k] = v);
      }
      return _results;
    };

    return Mixin;

  })();

  /* src/geomjs/equatable.coffee */;


  Equatable = function() {
    var properties;
    properties = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    return (function(_super) {

      __extends(_Class, _super);

      function _Class() {
        return _Class.__super__.constructor.apply(this, arguments);
      }

      _Class.prototype.equals = function(o) {
        var _this = this;
        return (o != null) && properties.every(function(p) {
          if (_this[p].equals != null) {
            return _this[p].equals(o[p]);
          } else {
            return o[p] === _this[p];
          }
        });
      };

      return _Class;

    })(Mixin);
  };

  /* src/geomjs/formattable.coffee */;


  Formattable = function() {
    var classname, properties;
    classname = arguments[0], properties = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    return (function(_super) {

      __extends(_Class, _super);

      function _Class() {
        return _Class.__super__.constructor.apply(this, arguments);
      }

      _Class.prototype.toString = function() {
        var formattedProperties, p;
        formattedProperties = (function() {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = properties.length; _i < _len; _i++) {
            p = properties[_i];
            _results.push("" + p + "=" + this[p]);
          }
          return _results;
        }).call(this);
        return "[" + classname + "(" + (formattedProperties.join(', ')) + ")]";
      };

      return _Class;

    })(Mixin);
  };

  /* src/geomjs/geometry.coffee */;


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
      return new Rectangle(this.left(), this.top(), this.right() - this.left(), this.bottom() - this.top());
    };

    Geometry.prototype.intersects = function(geometry) {
      var output;
      if ((geometry.bounds != null) && !this.boundsCollide(geometry)) {
        return false;
      }
      output = false;
      this.eachIntersections(geometry, function() {
        return output = true;
      });
      return output;
    };

    Geometry.prototype.intersections = function(geometry) {
      var output;
      if ((geometry.bounds != null) && !this.boundsCollide(geometry)) {
        return null;
      }
      output = [];
      this.eachIntersections(geometry, function(intersection) {
        output.push(intersection);
        return false;
      });
      if (output.length > 0) {
        return output;
      } else {
        return null;
      }
    };

    Geometry.prototype.boundsCollide = function(geometry) {
      var bounds1, bounds2;
      bounds1 = this.bounds();
      bounds2 = geometry.bounds();
      return !(bounds1.top > bounds2.bottom || bounds1.left > bounds2.right || bounds1.bottom < bounds2.top || bounds1.right < bounds2.left);
    };

    Geometry.prototype.eachIntersections = function(geometry, block, providesDataInCallback) {
      var context, cross, d1, d2, d3, d4, dif1, dif2, ev1, ev2, i, j, length1, length2, output, points1, points2, sv1, sv2, _i, _j, _ref, _ref1;
      if (providesDataInCallback == null) {
        providesDataInCallback = false;
      }
      points1 = this.points();
      points2 = geometry.points();
      length1 = points1.length;
      length2 = points2.length;
      output = [];
      for (i = _i = 0, _ref = length1 - 2; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
        sv1 = points1[i];
        ev1 = points1[i + 1];
        dif1 = ev1.subtract(sv1);
        for (j = _j = 0, _ref1 = length2 - 2; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; j = 0 <= _ref1 ? ++_j : --_j) {
          sv2 = points2[j];
          ev2 = points2[j + 1];
          dif2 = ev2.subtract(sv2);
          cross = this.perCrossing(sv1, dif1, sv2, dif2);
          d1 = cross.subtract(ev1);
          d2 = cross.subtract(sv1);
          d3 = cross.subtract(ev2);
          d4 = cross.subtract(sv2);
          if (d1.length() <= dif1.length() && d2.length() <= dif1.length() && d3.length() <= dif2.length() && d4.length() <= dif2.length()) {
            if (providesDataInCallback) {
              context = {
                segment1: dif1,
                segmentIndex1: i,
                segmentStart1: sv1,
                segmentEnd1: ev1,
                segment2: dif2,
                segmentIndex2: j,
                segmentStart2: sv2,
                segmentEnd2: ev2
              };
            }
            if (block.call(this, cross, context)) {
              return;
            }
          }
        }
      }
    };

    Geometry.prototype.perCrossing = function(start1, dir1, start2, dir2) {
      var cx, cy, perP1, perP2, t, v3bx, v3by;
      v3bx = start2.x - start1.x;
      v3by = start2.y - start1.y;
      perP1 = v3bx * dir2.y - v3by * dir2.x;
      perP2 = dir1.x * dir2.y - dir1.y * dir2.x;
      t = perP1 / perP2;
      cx = start1.x + dir1.x * t;
      cy = start1.y + dir1.y * t;
      return new Point(cx, cy);
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

    Geometry.prototype.drawPath = function(context) {};

    return Geometry;

  })(Mixin);

  /* src/geomjs/surface.coffee */;


  Surface = (function(_super) {

    __extends(Surface, _super);

    function Surface() {
      return Surface.__super__.constructor.apply(this, arguments);
    }

    Surface.prototype.acreage = function() {
      return null;
    };

    Surface.prototype.randomPointInSurface = function() {
      return null;
    };

    Surface.prototype.contains = function(xOrPt, y) {
      return null;
    };

    Surface.prototype.containsGeometry = function(geometry) {
      var _this = this;
      return geometry.points().every(function(point) {
        return _this.contains(point);
      });
    };

    return Surface;

  })(Mixin);

  /* src/geomjs/path.coffee */;


  Path = (function(_super) {

    __extends(Path, _super);

    function Path() {
      return Path.__super__.constructor.apply(this, arguments);
    }

    Path.prototype.length = function() {
      return null;
    };

    Path.prototype.pathPointAt = function(n, pathBasedOnLength) {
      if (pathBasedOnLength == null) {
        pathBasedOnLength = true;
      }
      return null;
    };

    Path.prototype.pathOrientationAt = function(n, pathBasedOnLength) {
      var d, p1, p2;
      if (pathBasedOnLength == null) {
        pathBasedOnLength = true;
      }
      p1 = this.pathPointAt(n - 0.01);
      p2 = this.pathPointAt(n + 0.01);
      d = p2.subtract(p1);
      return d.angle();
    };

    Path.prototype.pathTangentAt = function(n, accuracy, pathBasedOnLength) {
      if (accuracy == null) {
        accuracy = 1 / 100;
      }
      if (pathBasedOnLength == null) {
        pathBasedOnLength = true;
      }
      return this.pathPointAt((n + accuracy) % 1).subtract(this.pathPointAt((1 + n - accuracy) % 1)).normalize(1);
    };

    return Path;

  })(Mixin);

  /* src/geomjs/point.coffee */;


  Point = (function() {

    Equatable('x', 'y').attachTo(Point);

    Formattable('Point', 'x', 'y').attachTo(Point);

    Point.isPoint = function(pt) {
      return (pt != null) && (pt.x != null) && (pt.y != null);
    };

    Point.isFloat = function(n) {
      return !isNaN(parseFloat(n));
    };

    Point.coordsFrom = function(xOrPt, y, strict) {
      var x;
      if (strict == null) {
        strict = false;
      }
      x = xOrPt;
      if ((xOrPt != null) && typeof xOrPt === 'object') {
        x = xOrPt.x, y = xOrPt.y;
      }
      x = parseFloat(x);
      y = parseFloat(y);
      if (strict && (isNaN(x) || isNaN(y))) {
        this.notAPoint([x, y]);
      }
      return [x, y];
    };

    Point.polar = function(angle, length) {
      if (length == null) {
        length = 1;
      }
      return new Point(Math.sin(angle) * length, Math.cos(angle) * length);
    };

    Point.interpolate = function(pt1, pt2, pos) {
      var args, dif, extract, i, v, _i, _len,
        _this = this;
      args = [];
      for (i = _i = 0, _len = arguments.length; _i < _len; i = ++_i) {
        v = arguments[i];
        args[i] = v;
      }
      extract = function(args, name) {
        var pt;
        pt = null;
        if (_this.isPoint(args[0])) {
          pt = args.shift();
        } else if (_this.isFloat(args[0]) && _this.isFloat(args[1])) {
          pt = new Point(args[0], args[1]);
          args.splice(0, 2);
        } else {
          _this.missingPoint(args, name);
        }
        return pt;
      };
      pt1 = extract(args, 'first');
      pt2 = extract(args, 'second');
      pos = parseFloat(args.shift());
      if (isNaN(pos)) {
        this.missingPosition(pos);
      }
      dif = pt2.subtract(pt1);
      return new Point(pt1.x + dif.x * pos, pt1.y + dif.y * pos);
    };

    Point.missingPosition = function(pos) {
      throw new Error("Point.interpolate require a position but " + pos + " was given");
    };

    Point.missingPoint = function(args, pos) {
      throw new Error("Can't find the " + pos + " point in Point.interpolate arguments " + args);
    };

    Point.notAPoint = function(pt) {
      throw new Error("" + pt + " isn't a point-like object");
    };

    function Point(xOrPt, y) {
      var x, _ref, _ref1;
      _ref = this.coordsFrom(xOrPt, y), x = _ref[0], y = _ref[1];
      _ref1 = this.defaultToZero(x, y), this.x = _ref1[0], this.y = _ref1[1];
    }

    Point.prototype.length = function() {
      return Math.sqrt((this.x * this.x) + (this.y * this.y));
    };

    Point.prototype.angle = function() {
      return Math.radToDeg(Math.atan2(this.y, this.x));
    };

    Point.prototype.angleWith = function(xOrPt, y) {
      var d, x, _ref;
      if (!(xOrPt != null) && !(y != null)) {
        this.noPoint('dot');
      }
      _ref = this.coordsFrom(xOrPt, y, true), x = _ref[0], y = _ref[1];
      d = this.normalize().dot(new Point(x, y).normalize());
      return Math.radToDeg(Math.acos(Math.abs(d)) * (d < 0 ? -1 : 1));
    };

    Point.prototype.normalize = function(length) {
      var l;
      if (length == null) {
        length = 1;
      }
      if (!this.isFloat(length)) {
        this.invalidLength(length);
      }
      l = this.length();
      return new Point(this.x / l * length, this.y / l * length);
    };

    Point.prototype.add = function(xOrPt, y) {
      var x, _ref, _ref1;
      _ref = this.coordsFrom(xOrPt, y), x = _ref[0], y = _ref[1];
      _ref1 = this.defaultToZero(x, y), x = _ref1[0], y = _ref1[1];
      return new Point(this.x + x, this.y + y);
    };

    Point.prototype.subtract = function(xOrPt, y) {
      var x, _ref, _ref1;
      _ref = this.coordsFrom(xOrPt, y), x = _ref[0], y = _ref[1];
      _ref1 = this.defaultToZero(x, y), x = _ref1[0], y = _ref1[1];
      return new Point(this.x - x, this.y - y);
    };

    Point.prototype.dot = function(xOrPt, y) {
      var x, _ref;
      if (!(xOrPt != null) && !(y != null)) {
        this.noPoint('dot');
      }
      _ref = this.coordsFrom(xOrPt, y, true), x = _ref[0], y = _ref[1];
      return this.x * x + this.y * y;
    };

    Point.prototype.distance = function(xOrPt, y) {
      var x, _ref;
      if (!(xOrPt != null) && !(y != null)) {
        this.noPoint('dot');
      }
      _ref = this.coordsFrom(xOrPt, y, true), x = _ref[0], y = _ref[1];
      return this.subtract(x, y).length();
    };

    Point.prototype.scale = function(n) {
      if (!this.isFloat(n)) {
        this.invalidScale(n);
      }
      return new Point(this.x * n, this.y * n);
    };

    Point.prototype.rotate = function(n) {
      var a, l, x, y;
      if (!this.isFloat(n)) {
        this.invalidRotation(n);
      }
      l = this.length();
      a = Math.atan2(this.y, this.x) + Math.degToRad(n);
      x = Math.cos(a) * l;
      y = Math.sin(a) * l;
      return new Point(x, y);
    };

    Point.prototype.rotateAround = function(xOrPt, y, a) {
      var x, _ref;
      if (this.isPoint(xOrPt)) {
        a = y;
      }
      _ref = this.coordsFrom(xOrPt, y, true), x = _ref[0], y = _ref[1];
      return this.subtract(x, y).rotate(a).add(x, y);
    };

    Point.prototype.isPoint = function(pt) {
      return Point.isPoint(pt);
    };

    Point.prototype.isFloat = function(n) {
      return Point.isFloat(n);
    };

    Point.prototype.coordsFrom = function(xOrPt, y, strict) {
      return Point.coordsFrom(xOrPt, y, strict);
    };

    Point.prototype.defaultToZero = function(x, y) {
      x = isNaN(x) ? 0 : x;
      y = isNaN(y) ? 0 : y;
      return [x, y];
    };

    Point.prototype.paste = function(xOrPt, y) {
      var x, _ref;
      _ref = this.coordsFrom(xOrPt, y), x = _ref[0], y = _ref[1];
      if (!isNaN(x)) {
        this.x = x;
      }
      if (!isNaN(y)) {
        this.y = y;
      }
      return this;
    };

    Point.prototype.clone = function() {
      return new Point(this);
    };

    Point.prototype.noPoint = function(method) {
      throw new Error("" + method + " was called without arguments");
    };

    Point.prototype.invalidLength = function(l) {
      throw new Error("Invalid length " + l + " provided");
    };

    Point.prototype.invalidScale = function(s) {
      throw new Error("Invalid scale " + s + " provided");
    };

    Point.prototype.invalidRotation = function(a) {
      throw new Error("Invalid rotation " + a + " provided");
    };

    return Point;

  })();

  /* src/geomjs/matrix.coffee */;


  Matrix = (function() {
    var PROPERTIES;

    PROPERTIES = ['a', 'b', 'c', 'd', 'tx', 'ty'];

    Equatable.apply(null, PROPERTIES).attachTo(Matrix);

    Formattable.apply(null, ['Matrix'].concat(PROPERTIES)).attachTo(Matrix);

    Matrix.isMatrix = function(m) {
      var k, _i, _len;
      if (m == null) {
        return false;
      }
      for (_i = 0, _len = PROPERTIES.length; _i < _len; _i++) {
        k = PROPERTIES[_i];
        if (!this.isFloat(m[k])) {
          return false;
        }
      }
      return true;
    };

    Matrix.isFloat = function() {
      var float, floats, _i, _len;
      floats = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      for (_i = 0, _len = floats.length; _i < _len; _i++) {
        float = floats[_i];
        if (isNaN(parseFloat(float))) {
          return false;
        }
      }
      return true;
    };

    function Matrix(a, b, c, d, tx, ty) {
      var _ref;
      if (a == null) {
        a = 1;
      }
      if (b == null) {
        b = 0;
      }
      if (c == null) {
        c = 0;
      }
      if (d == null) {
        d = 1;
      }
      if (tx == null) {
        tx = 0;
      }
      if (ty == null) {
        ty = 0;
      }
      _ref = this.matrixFrom(a, b, c, d, tx, ty), this.a = _ref[0], this.b = _ref[1], this.c = _ref[2], this.d = _ref[3], this.tx = _ref[4], this.ty = _ref[5];
    }

    Matrix.prototype.transformPoint = function(xOrPt, y) {
      var x, x2, y2, _ref;
      if (!(xOrPt != null) && !(y != null)) {
        throw new Error("transformPoint was called without arguments");
      }
      _ref = Point.coordsFrom(xOrPt, y, true), x = _ref[0], y = _ref[1];
      x2 = x * this.a + y * this.c + this.tx;
      y2 = x * this.b + y * this.d + this.ty;
      return new Point(x2, y2);
    };

    Matrix.prototype.translate = function(xOrPt, y) {
      var x, _ref;
      _ref = this.coordsFrom(xOrPt, y, 0), x = _ref[0], y = _ref[1];
      this.tx += x;
      this.ty += y;
      return this;
    };

    Matrix.prototype.scale = function(xOrPt, y) {
      var x, _ref;
      _ref = this.coordsFrom(xOrPt, y, 1), x = _ref[0], y = _ref[1];
      this.a *= x;
      this.d *= y;
      this.tx *= x;
      this.ty *= y;
      return this;
    };

    Matrix.prototype.rotate = function(angle) {
      var cos, sin, _ref;
      if (angle == null) {
        angle = 0;
      }
      cos = Math.cos(Math.degToRad(angle));
      sin = Math.sin(Math.degToRad(angle));
      _ref = [this.a * cos - this.b * sin, this.a * sin + this.b * cos, this.c * cos - this.d * sin, this.c * sin + this.d * cos, this.tx * cos - this.ty * sin, this.tx * sin + this.ty * cos], this.a = _ref[0], this.b = _ref[1], this.c = _ref[2], this.d = _ref[3], this.tx = _ref[4], this.ty = _ref[5];
      return this;
    };

    Matrix.prototype.skew = function(xOrPt, y) {
      var x, _ref, _ref1;
      _ref = this.coordsFrom(xOrPt, y, 0), x = _ref[0], y = _ref[1];
      _ref1 = [Math.degToRad(x), Math.degToRad(y)], x = _ref1[0], y = _ref1[1];
      return this.append(Math.cos(y), Math.sin(y), -Math.sin(x), Math.cos(x));
    };

    Matrix.prototype.append = function(a, b, c, d, tx, ty) {
      var _ref, _ref1;
      if (a == null) {
        a = 1;
      }
      if (b == null) {
        b = 0;
      }
      if (c == null) {
        c = 0;
      }
      if (d == null) {
        d = 1;
      }
      if (tx == null) {
        tx = 0;
      }
      if (ty == null) {
        ty = 0;
      }
      _ref = this.matrixFrom(a, b, c, d, tx, ty), a = _ref[0], b = _ref[1], c = _ref[2], d = _ref[3], tx = _ref[4], ty = _ref[5];
      _ref1 = [a * this.a + b * this.c, a * this.b + b * this.d, c * this.a + d * this.c, c * this.b + d * this.d, tx * this.a + ty * this.c + this.tx, tx * this.b + ty * this.d + this.ty], this.a = _ref1[0], this.b = _ref1[1], this.c = _ref1[2], this.d = _ref1[3], this.tx = _ref1[4], this.ty = _ref1[5];
      return this;
    };

    Matrix.prototype.prepend = function(a, b, c, d, tx, ty) {
      var _ref, _ref1, _ref2;
      if (a == null) {
        a = 1;
      }
      if (b == null) {
        b = 0;
      }
      if (c == null) {
        c = 0;
      }
      if (d == null) {
        d = 1;
      }
      if (tx == null) {
        tx = 0;
      }
      if (ty == null) {
        ty = 0;
      }
      _ref = this.matrixFrom(a, b, c, d, tx, ty), a = _ref[0], b = _ref[1], c = _ref[2], d = _ref[3], tx = _ref[4], ty = _ref[5];
      if (a !== 1 || b !== 0 || c !== 0 || d !== 1) {
        _ref1 = [this.a * a + this.b * c, this.a * b + this.b * d, this.c * a + this.d * c, this.c * b + this.d * d], this.a = _ref1[0], this.b = _ref1[1], this.c = _ref1[2], this.d = _ref1[3];
      }
      _ref2 = [this.tx * a + this.ty * c + tx, this.tx * b + this.ty * d + ty], this.tx = _ref2[0], this.ty = _ref2[1];
      return this;
    };

    Matrix.prototype.identity = function() {
      var _ref;
      _ref = [1, 0, 0, 1, 0, 0], this.a = _ref[0], this.b = _ref[1], this.c = _ref[2], this.d = _ref[3], this.tx = _ref[4], this.ty = _ref[5];
      return this;
    };

    Matrix.prototype.inverse = function() {
      var n, _ref;
      n = this.a * this.d - this.b * this.c;
      _ref = [this.d / n, -this.b / n, -this.c / n, this.a / n, (this.c * this.ty - this.d * this.tx) / n, -(this.a * this.ty - this.b * this.tx) / n], this.a = _ref[0], this.b = _ref[1], this.c = _ref[2], this.d = _ref[3], this.tx = _ref[4], this.ty = _ref[5];
      return this;
    };

    Matrix.prototype.asFloat = function() {
      var floats, i, n, _i, _len;
      floats = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      for (i = _i = 0, _len = floats.length; _i < _len; i = ++_i) {
        n = floats[i];
        floats[i] = parseFloat(n);
      }
      return floats;
    };

    Matrix.prototype.matrixFrom = function(a, b, c, d, tx, ty) {
      var _ref;
      if (this.isMatrix(a)) {
        _ref = a, a = _ref.a, b = _ref.b, c = _ref.c, d = _ref.d, tx = _ref.tx, ty = _ref.ty;
      } else if (!this.isFloat(a, b, c, d, tx, ty)) {
        this.invalidMatrixArguments([a, b, c, d, tx, ty]);
      }
      return this.asFloat(a, b, c, d, tx, ty);
    };

    Matrix.prototype.coordsFrom = function(xOrPt, y, def) {
      var x, _ref;
      _ref = Point.coordsFrom(xOrPt, y), x = _ref[0], y = _ref[1];
      if (isNaN(x)) {
        x = def;
      }
      if (isNaN(y)) {
        y = def;
      }
      return [x, y];
    };

    Matrix.prototype.isMatrix = function(m) {
      return Matrix.isMatrix(m);
    };

    Matrix.prototype.isFloat = function() {
      var floats;
      floats = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return Matrix.isFloat.apply(Matrix, floats);
    };

    Matrix.prototype.clone = function() {
      return new Matrix(this);
    };

    Matrix.prototype.invalidMatrixArguments = function(args) {
      throw new Error("Invalid arguments " + args + " for a Matrix");
    };

    return Matrix;

  })();

  /* src/geomjs/rectangle.coffee */;


  Rectangle = (function() {
    var PROPERTIES;

    PROPERTIES = ['x', 'y', 'width', 'height', 'rotation'];

    Equatable.apply(null, PROPERTIES).attachTo(Rectangle);

    Formattable.apply(null, ['Rectangle'].concat(PROPERTIES)).attachTo(Rectangle);

    Geometry.attachTo(Rectangle);

    Surface.attachTo(Rectangle);

    Path.attachTo(Rectangle);

    function Rectangle(x, y, width, height, rotation) {
      var args;
      args = this.defaultToZero.apply(this, this.rectangleFrom.apply(this, arguments));
      this.x = args[0], this.y = args[1], this.width = args[2], this.height = args[3], this.rotation = args[4];
    }

    Rectangle.prototype.topLeft = function() {
      return new Point(this.x, this.y);
    };

    Rectangle.prototype.topRight = function() {
      return this.topLeft().add(this.topEdge());
    };

    Rectangle.prototype.bottomLeft = function() {
      return this.topLeft().add(this.leftEdge());
    };

    Rectangle.prototype.bottomRight = function() {
      return this.topLeft().add(this.topEdge()).add(this.leftEdge());
    };

    Rectangle.prototype.center = function() {
      return this.topLeft().add(this.topEdge().scale(0.5)).add(this.leftEdge().scale(0.5));
    };

    Rectangle.prototype.topEdgeCenter = function() {
      return this.topLeft().add(this.topEdge().scale(0.5));
    };

    Rectangle.prototype.bottomEdgeCenter = function() {
      return this.bottomLeft().add(this.topEdge().scale(0.5));
    };

    Rectangle.prototype.leftEdgeCenter = function() {
      return this.topLeft().add(this.leftEdge().scale(0.5));
    };

    Rectangle.prototype.rightEdgeCenter = function() {
      return this.topRight().add(this.leftEdge().scale(0.5));
    };

    Rectangle.prototype.topEdge = function() {
      return new Point(this.width * Math.cos(Math.degToRad(this.rotation)), this.width * Math.sin(Math.degToRad(this.rotation)));
    };

    Rectangle.prototype.leftEdge = function() {
      return new Point(this.height * Math.cos(Math.degToRad(this.rotation) + Math.PI / 2), this.height * Math.sin(Math.degToRad(this.rotation) + Math.PI / 2));
    };

    Rectangle.prototype.bottomEdge = function() {
      return this.topEdge();
    };

    Rectangle.prototype.rightEdge = function() {
      return this.leftEdge();
    };

    Rectangle.prototype.top = function() {
      return Math.min(this.y, this.topRight().y, this.bottomRight().y, this.bottomLeft().y);
    };

    Rectangle.prototype.bottom = function() {
      return Math.max(this.y, this.topRight().y, this.bottomRight().y, this.bottomLeft().y);
    };

    Rectangle.prototype.left = function() {
      return Math.min(this.x, this.topRight().x, this.bottomRight().x, this.bottomLeft().x);
    };

    Rectangle.prototype.right = function() {
      return Math.max(this.x, this.topRight().x, this.bottomRight().x, this.bottomLeft().x);
    };

    Rectangle.prototype.setCenter = function(xOrPt, y) {
      var c, x, _ref;
      _ref = Point.coordsFrom(xOrPt, y), x = _ref[0], y = _ref[1];
      c = this.center();
      this.x += x - c.x;
      this.y += y - c.y;
      return this;
    };

    Rectangle.prototype.rotateAroundCenter = function(rotation) {
      var _ref;
      _ref = this.topLeft().rotateAround(this.center(), rotation), this.x = _ref.x, this.y = _ref.y;
      this.rotation += rotation;
      return this;
    };

    Rectangle.prototype.scaleAroundCenter = function(scale) {
      var dif, topLeft, _ref;
      topLeft = this.topLeft();
      dif = topLeft.subtract(this.center()).scale(scale);
      _ref = topLeft.add(dif.scale(1 / 2)), this.x = _ref.x, this.y = _ref.y;
      this.width *= scale;
      this.height *= scale;
      return this;
    };

    Rectangle.prototype.inflateAroundCenter = function(xOrPt, y) {
      var center;
      center = this.center();
      this.inflate(xOrPt, y);
      this.setCenter(center);
      return this;
    };

    Rectangle.prototype.inflate = function(xOrPt, y) {
      var x, _ref;
      _ref = Point.coordsFrom(xOrPt, y), x = _ref[0], y = _ref[1];
      this.width += x;
      this.height += y;
      return this;
    };

    Rectangle.prototype.inflateLeft = function(inflate) {
      var offset, _ref;
      this.width += inflate;
      offset = this.topEdge().normalize(-inflate);
      _ref = this.topLeft().add(offset), this.x = _ref.x, this.y = _ref.y;
      return this;
    };

    Rectangle.prototype.inflateRight = function(inflate) {
      this.width += inflate;
      return this;
    };

    Rectangle.prototype.inflateTop = function(inflate) {
      var offset, _ref;
      this.height += inflate;
      offset = this.leftEdge().normalize(-inflate);
      _ref = this.topLeft().add(offset), this.x = _ref.x, this.y = _ref.y;
      return this;
    };

    Rectangle.prototype.inflateBottom = function(inflate) {
      this.height += inflate;
      return this;
    };

    Rectangle.prototype.inflateTopLeft = function(xOrPt, y) {
      var x, _ref;
      _ref = Point.coordsFrom(xOrPt, y), x = _ref[0], y = _ref[1];
      this.inflateLeft(x);
      this.inflateTop(y);
      return this;
    };

    Rectangle.prototype.inflateTopRight = function(xOrPt, y) {
      var x, _ref;
      _ref = Point.coordsFrom(xOrPt, y), x = _ref[0], y = _ref[1];
      this.inflateRight(x);
      this.inflateTop(y);
      return this;
    };

    Rectangle.prototype.inflateBottomLeft = function(xOrPt, y) {
      var x, _ref;
      _ref = Point.coordsFrom(xOrPt, y), x = _ref[0], y = _ref[1];
      this.inflateLeft(x);
      this.inflateBottom(y);
      return this;
    };

    Rectangle.prototype.inflateBottomRight = function(xOrPt, y) {
      return this.inflate(xOrPt, y);
    };

    Rectangle.prototype.closedGeometry = function() {
      return true;
    };

    Rectangle.prototype.points = function() {
      return [this.topLeft(), this.topRight(), this.bottomRight(), this.bottomLeft(), this.topLeft()];
    };

    Rectangle.prototype.pointAtAngle = function(angle) {
      var center, vec, _ref;
      center = this.center();
      vec = center.add(Math.cos(Math.degToRad(angle)) * 10000, Math.sin(Math.degToRad(angle)) * 10000);
      return (_ref = this.intersections({
        points: function() {
          return [center, vec];
        }
      })) != null ? _ref[0] : void 0;
    };

    Rectangle.prototype.acreage = function() {
      return this.width * this.height;
    };

    Rectangle.prototype.contains = function(xOrPt, y) {
      var x, _ref, _ref1;
      _ref = Point.coordsFrom(xOrPt, y), x = _ref[0], y = _ref[1];
      _ref1 = new Point(x, y).rotateAround(this.topLeft(), -this.rotation), x = _ref1.x, y = _ref1.y;
      return ((this.x <= x && x <= this.x + this.width)) && ((this.y <= y && y <= this.y + this.height));
    };

    Rectangle.prototype.randomPointInSurface = function(random) {
      if (random == null) {
        random = new chancejs.Random(new chancejs.MathRandom);
      }
      return this.topLeft().add(this.topEdge().scale(random.get())).add(this.leftEdge().scale(random.get()));
    };

    Rectangle.prototype.length = function() {
      return this.width * 2 + this.height * 2;
    };

    Rectangle.prototype.pathPointAt = function(n, pathBasedOnLength) {
      var p1, p2, p3, _ref;
      if (pathBasedOnLength == null) {
        pathBasedOnLength = true;
      }
      _ref = this.pathSteps(pathBasedOnLength), p1 = _ref[0], p2 = _ref[1], p3 = _ref[2];
      if (n < p1) {
        return this.topLeft().add(this.topEdge().scale(Math.map(n, 0, p1, 0, 1)));
      } else if (n < p2) {
        return this.topRight().add(this.rightEdge().scale(Math.map(n, p1, p2, 0, 1)));
      } else if (n < p3) {
        return this.bottomRight().add(this.bottomEdge().scale(Math.map(n, p2, p3, 0, 1) * -1));
      } else {
        return this.bottomLeft().add(this.leftEdge().scale(Math.map(n, p3, 1, 0, 1) * -1));
      }
    };

    Rectangle.prototype.pathOrientationAt = function(n, pathBasedOnLength) {
      var p, p1, p2, p3, _ref;
      if (pathBasedOnLength == null) {
        pathBasedOnLength = true;
      }
      _ref = this.pathSteps(pathBasedOnLength), p1 = _ref[0], p2 = _ref[1], p3 = _ref[2];
      if (n < p1) {
        p = this.topEdge();
      } else if (n < p2) {
        p = this.rightEdge();
      } else if (n < p3) {
        p = this.bottomEdge().scale(-1);
      } else {
        p = this.leftEdge().scale(-1);
      }
      return p.angle();
    };

    Rectangle.prototype.pathSteps = function(pathBasedOnLength) {
      var l, p1, p2, p3;
      if (pathBasedOnLength == null) {
        pathBasedOnLength = true;
      }
      if (pathBasedOnLength) {
        l = this.length();
        p1 = this.width / l;
        p2 = (this.width + this.height) / l;
        p3 = p1 + p2;
      } else {
        p1 = 1 / 4;
        p2 = 1 / 2;
        p3 = 3 / 4;
      }
      return [p1, p2, p3];
    };

    Rectangle.prototype.drawPath = function(context) {
      context.beginPath();
      context.moveTo(this.x, this.y);
      context.lineTo(this.topRight().x, this.topRight().y);
      context.lineTo(this.bottomRight().x, this.bottomRight().y);
      context.lineTo(this.bottomLeft().x, this.bottomLeft().y);
      context.lineTo(this.x, this.y);
      return context.closePath();
    };

    Rectangle.prototype.clone = function() {
      return new Rectangle(this);
    };

    Rectangle.prototype.paste = function(x, y, width, height, rotation) {
      var values,
        _this = this;
      values = this.rectangleFrom(x, y, width, height, rotation);
      return PROPERTIES.forEach(function(k, i) {
        if (Point.isFloat(values[i])) {
          return _this[k] = parseFloat(values[i]);
        }
      });
    };

    Rectangle.prototype.rectangleFrom = function(xOrRect, y, width, height, rotation) {
      var x;
      x = xOrRect;
      if (typeof xOrRect === 'object') {
        x = xOrRect.x, y = xOrRect.y, width = xOrRect.width, height = xOrRect.height, rotation = xOrRect.rotation;
      }
      return [x, y, width, height, rotation];
    };

    Rectangle.prototype.defaultToZero = function() {
      var i, n, values, _i, _len;
      values = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      for (i = _i = 0, _len = values.length; _i < _len; i = ++_i) {
        n = values[i];
        if (!Point.isFloat(n)) {
          values[i] = 0;
        }
      }
      return values;
    };

    return Rectangle;

  })();

  /* src/geomjs/triangle.coffee */;


  Triangle = (function() {

    Equatable('a', 'b', 'c').attachTo(Triangle);

    Formattable('Triangle', 'a', 'b', 'c').attachTo(Triangle);

    Geometry.attachTo(Triangle);

    Surface.attachTo(Triangle);

    Path.attachTo(Triangle);

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

    Triangle.prototype.center = function() {
      return new Point((this.a.x + this.b.x + this.c.x) / 3, (this.a.y + this.b.y + this.c.y) / 3);
    };

    ['abCenter', 'acCenter', 'bcCenter'].forEach(function(k) {
      var p1, p2, _ref;
      _ref = k.split(''), p1 = _ref[0], p2 = _ref[1];
      return Triangle.prototype[k] = function() {
        return this[p1].add(this["" + p1 + p2]().scale(0.5));
      };
    });

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

    Triangle.prototype.equilateral = function() {
      return Math.deltaBelowRatio(this.ab().length(), this.bc().length()) && Math.deltaBelowRatio(this.ab().length(), this.ac().length());
    };

    Triangle.prototype.isosceles = function() {
      return Math.deltaBelowRatio(this.ab().length(), this.bc().length()) || Math.deltaBelowRatio(this.ab().length(), this.ac().length()) || Math.deltaBelowRatio(this.bc().length(), this.ac().length());
    };

    Triangle.prototype.rectangle = function() {
      var sqr;
      sqr = 90;
      return Math.deltaBelowRatio(Math.abs(this.abc()), sqr) || Math.deltaBelowRatio(Math.abs(this.bac()), sqr) || Math.deltaBelowRatio(Math.abs(this.acb()), sqr);
    };

    Triangle.prototype.rotateAroundCenter = function(rotation) {
      var center;
      center = this.center();
      this.a = this.a.rotateAround(center, rotation);
      this.b = this.b.rotateAround(center, rotation);
      this.c = this.c.rotateAround(center, rotation);
      return this;
    };

    Triangle.prototype.scaleAroundCenter = function(scale) {
      var center;
      center = this.center();
      this.a = center.add(this.a.subtract(center).scale(scale));
      this.b = center.add(this.b.subtract(center).scale(scale));
      this.c = center.add(this.c.subtract(center).scale(scale));
      return this;
    };

    Triangle.prototype.closedGeometry = function() {
      return true;
    };

    Triangle.prototype.points = function() {
      return [this.a.clone(), this.b.clone(), this.c.clone(), this.a.clone()];
    };

    Triangle.prototype.pointAtAngle = function(angle) {
      var center, vec, _ref;
      center = this.center();
      vec = center.add(Math.cos(Math.degToRad(angle)) * 10000, Math.sin(Math.degToRad(angle)) * 10000);
      return (_ref = this.intersections({
        points: function() {
          return [center, vec];
        }
      })) != null ? _ref[0] : void 0;
    };

    Triangle.prototype.acreage = function() {
      return this.ab().length() * this.bc().length() * Math.abs(Math.sin(this.abc())) / 2;
    };

    Triangle.prototype.contains = function(xOrPt, y) {
      var dot00, dot01, dot02, dot11, dot12, invDenom, p, u, v, v0, v1, v2, x, _ref;
      _ref = Point.coordsFrom(xOrPt, y), x = _ref[0], y = _ref[1];
      p = new Point(x, y);
      v0 = this.ac();
      v1 = this.ab();
      v2 = p.subtract(this.a);
      dot00 = v0.dot(v0);
      dot01 = v0.dot(v1);
      dot02 = v0.dot(v2);
      dot11 = v1.dot(v1);
      dot12 = v1.dot(v2);
      invDenom = 1 / (dot00 * dot11 - dot01 * dot01);
      u = (dot11 * dot02 - dot01 * dot12) * invDenom;
      v = (dot00 * dot12 - dot01 * dot02) * invDenom;
      return v > 0 && v > 0 && u + v < 1;
    };

    Triangle.prototype.randomPointInSurface = function(random) {
      var a1, a2, p;
      if (random == null) {
        random = new chancejs.Random(new chancejs.MathRandom);
      }
      a1 = random.get();
      a2 = random.get();
      p = this.a.add(this.ab().scale(a1)).add(this.ca().scale(a2 * -1));
      if (this.contains(p)) {
        return p;
      } else {
        return p.add(this.bcCenter().subtract(p).scale(2));
      }
    };

    Triangle.prototype.length = function() {
      return this.ab().length() + this.bc().length() + this.ca().length();
    };

    Triangle.prototype.pathPointAt = function(n, pathBasedOnLength) {
      var l1, l2, _ref;
      if (pathBasedOnLength == null) {
        pathBasedOnLength = true;
      }
      _ref = this.pathSteps(pathBasedOnLength), l1 = _ref[0], l2 = _ref[1];
      if (n < l1) {
        return this.a.add(this.ab().scale(Math.map(n, 0, l1, 0, 1)));
      } else if (n < l2) {
        return this.b.add(this.bc().scale(Math.map(n, l1, l2, 0, 1)));
      } else {
        return this.c.add(this.ca().scale(Math.map(n, l2, 1, 0, 1)));
      }
    };

    Triangle.prototype.pathOrientationAt = function(n, pathBasedOnLength) {
      var l1, l2, _ref;
      if (pathBasedOnLength == null) {
        pathBasedOnLength = true;
      }
      _ref = this.pathSteps(pathBasedOnLength), l1 = _ref[0], l2 = _ref[1];
      if (n < l1) {
        return this.ab().angle();
      } else if (n < l2) {
        return this.bc().angle();
      } else {
        return this.ca().angle();
      }
    };

    Triangle.prototype.pathSteps = function(pathBasedOnLength) {
      var l, l1, l2;
      if (pathBasedOnLength) {
        l = this.length();
        l1 = this.ab().length() / l;
        l2 = l1 + this.bc().length() / l;
      } else {
        l1 = 1 / 3;
        l2 = 2 / 3;
      }
      return [l1, l2];
    };

    Triangle.prototype.drawPath = function(context) {
      context.beginPath();
      context.moveTo(this.a.x, this.a.y);
      context.lineTo(this.b.x, this.b.y);
      context.lineTo(this.c.x, this.c.y);
      context.lineTo(this.a.x, this.a.y);
      return context.closePath();
    };

    Triangle.prototype.clone = function() {
      return new Triangle(this.a, this.b, this.c);
    };

    Triangle.prototype.invalidPoint = function(k, v) {
      throw new Error("Invalid point " + v + " for vertex " + k);
    };

    return Triangle;

  })();

  /* src/geomjs/circle.coffee */;


  Circle = (function() {

    Equatable('x', 'y', 'radius').attachTo(Circle);

    Formattable('Circle', 'x', 'y', 'radius').attachTo(Circle);

    Geometry.attachTo(Circle);

    Surface.attachTo(Circle);

    Path.attachTo(Circle);

    function Circle(radiusOrCircle, x, y, segments) {
      var _ref;
      _ref = this.circleFrom(radiusOrCircle, x, y, segments), this.radius = _ref[0], this.x = _ref[1], this.y = _ref[2], this.segments = _ref[3];
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

    Circle.prototype.points = function() {
      var n, step, _i, _ref, _results;
      step = 360 / this.segments;
      _results = [];
      for (n = _i = 0, _ref = this.segments; 0 <= _ref ? _i <= _ref : _i >= _ref; n = 0 <= _ref ? ++_i : --_i) {
        _results.push(this.pointAtAngle(n * step));
      }
      return _results;
    };

    Circle.prototype.closedGeometry = function() {
      return true;
    };

    Circle.prototype.pointAtAngle = function(angle) {
      return new Point(this.x + Math.cos(Math.degToRad(angle)) * this.radius, this.y + Math.sin(Math.degToRad(angle)) * this.radius);
    };

    Circle.prototype.acreage = function() {
      return this.radius * this.radius * Math.PI;
    };

    Circle.prototype.randomPointInSurface = function(random) {
      var center, dif, pt;
      if (random == null) {
        random = new chancejs.Random(new chancejs.MathRandom);
      }
      pt = this.pointAtAngle(random.random(360));
      center = this.center();
      dif = pt.subtract(center);
      return center.add(dif.scale(Math.sqrt(random.random())));
    };

    Circle.prototype.contains = function(xOrPt, y) {
      var x, _ref;
      _ref = Point.coordsFrom(xOrPt, y, true), x = _ref[0], y = _ref[1];
      return this.center().subtract(x, y).length() <= this.radius;
    };

    Circle.prototype.length = function() {
      return this.radius * Math.PI * 2;
    };

    Circle.prototype.pathPointAt = function(n) {
      return this.pointAtAngle(n * 360);
    };

    Circle.prototype.drawPath = function(context) {
      context.beginPath();
      return context.arc(this.x, this.y, this.radius, 0, Math.PI * 2);
    };

    Circle.prototype.clone = function() {
      return new Circle(this);
    };

    Circle.prototype.circleFrom = function(radiusOrCircle, x, y, segments) {
      var radius;
      radius = radiusOrCircle;
      if (typeof radiusOrCircle === 'object') {
        radius = radiusOrCircle.radius, x = radiusOrCircle.x, y = radiusOrCircle.y, segments = radiusOrCircle.segments;
      }
      if (!Point.isFloat(radius)) {
        radius = 1;
      }
      if (!Point.isFloat(x)) {
        x = 0;
      }
      if (!Point.isFloat(y)) {
        y = 0;
      }
      if (!Point.isFloat(segments)) {
        segments = 36;
      }
      return [radius, x, y, segments];
    };

    return Circle;

  })();

  /* src/geomjs/ellipsis.coffee */;


  Ellipsis = (function() {

    Equatable('radius1', 'radius2', 'x', 'y', 'rotation').attachTo(Ellipsis);

    Formattable('Ellipsis', 'radius1', 'radius2', 'x', 'y', 'rotation').attachTo(Ellipsis);

    Geometry.attachTo(Ellipsis);

    Surface.attachTo(Ellipsis);

    Path.attachTo(Ellipsis);

    function Ellipsis(r1, r2, x, y, rot, segments) {
      var _ref;
      _ref = this.ellipsisFrom(r1, r2, x, y, rot, segments), this.radius1 = _ref[0], this.radius2 = _ref[1], this.x = _ref[2], this.y = _ref[3], this.rotation = _ref[4], this.segments = _ref[5];
    }

    Ellipsis.prototype.center = function() {
      return new Point(this.x, this.y);
    };

    Ellipsis.prototype.left = function() {
      return Math.min.apply(Math, this.xBounds());
    };

    Ellipsis.prototype.right = function() {
      return Math.max.apply(Math, this.xBounds());
    };

    Ellipsis.prototype.bottom = function() {
      return Math.max.apply(Math, this.yBounds());
    };

    Ellipsis.prototype.top = function() {
      return Math.min.apply(Math, this.yBounds());
    };

    Ellipsis.prototype.xBounds = function() {
      var phi, t,
        _this = this;
      phi = Math.degToRad(this.rotation);
      t = Math.atan(-this.radius2 * Math.tan(phi) / this.radius1);
      return [t, t + Math.PI].map(function(t) {
        return _this.x + _this.radius1 * Math.cos(t) * Math.cos(phi) - _this.radius2 * Math.sin(t) * Math.sin(phi);
      });
    };

    Ellipsis.prototype.yBounds = function() {
      var phi, t,
        _this = this;
      phi = Math.degToRad(this.rotation);
      t = Math.atan(this.radius2 * (Math.cos(phi) / Math.sin(phi)) / this.radius1);
      return [t, t + Math.PI].map(function(t) {
        return _this.y + _this.radius1 * Math.cos(t) * Math.sin(phi) + _this.radius2 * Math.sin(t) * Math.cos(phi);
      });
    };

    Ellipsis.prototype.points = function() {
      var n, _i, _ref, _results;
      _results = [];
      for (n = _i = 0, _ref = this.segments; 0 <= _ref ? _i <= _ref : _i >= _ref; n = 0 <= _ref ? ++_i : --_i) {
        _results.push(this.pathPointAt(n / this.segments));
      }
      return _results;
    };

    Ellipsis.prototype.closedGeometry = function() {
      return true;
    };

    Ellipsis.prototype.pointAtAngle = function(angle) {
      var center, vec, _ref;
      center = this.center();
      vec = center.add(Math.cos(Math.degToRad(angle)) * 10000, Math.sin(Math.degToRad(angle)) * 10000);
      return (_ref = this.intersections({
        points: function() {
          return [center, vec];
        }
      })) != null ? _ref[0] : void 0;
    };

    Ellipsis.prototype.acreage = function() {
      return Math.PI * this.radius1 * this.radius2;
    };

    Ellipsis.prototype.randomPointInSurface = function(random) {
      var center, dif, pt;
      if (random == null) {
        random = new chancejs.Random(new chancejs.MathRandom);
      }
      pt = this.pathPointAt(random.get());
      center = this.center();
      dif = pt.subtract(center);
      return center.add(dif.scale(Math.sqrt(random.random())));
    };

    Ellipsis.prototype.contains = function(xOrPt, y) {
      var a, c, d, p, p2, x, _ref;
      _ref = Point.coordsFrom(xOrPt, y), x = _ref[0], y = _ref[1];
      p = new Point(x, y);
      c = this.center();
      d = p.subtract(c);
      a = d.angle();
      p2 = this.pointAtAngle(a);
      return c.distance(p2) >= c.distance(p);
    };

    Ellipsis.prototype.length = function() {
      return Math.PI * (3 * (this.radius1 + this.radius2) - Math.sqrt((3 * this.radius1 + this.radius2) * (this.radius1 + this.radius2 * 3)));
    };

    Ellipsis.prototype.pathPointAt = function(n) {
      var a, p;
      a = n * Math.PI * 2;
      p = new Point(Math.cos(a) * this.radius1, Math.sin(a) * this.radius2);
      return this.center().add(p.rotate(this.rotation));
    };

    Ellipsis.prototype.drawPath = function(context) {
      context.save();
      context.translate(this.x, this.y);
      context.rotate(Math.degToRad(this.rotation));
      context.scale(this.radius1, this.radius2);
      context.beginPath();
      context.arc(0, 0, 1, 0, Math.PI * 2);
      context.closePath();
      return context.restore();
    };

    Ellipsis.prototype.clone = function() {
      return new Ellipsis(this);
    };

    Ellipsis.prototype.ellipsisFrom = function(radius1, radius2, x, y, rotation, segments) {
      var _ref;
      if (typeof radius1 === 'object') {
        _ref = radius1, radius1 = _ref.radius1, radius2 = _ref.radius2, x = _ref.x, y = _ref.y, rotation = _ref.rotation, segments = _ref.segments;
      }
      if (!Point.isFloat(radius1)) {
        radius1 = 1;
      }
      if (!Point.isFloat(radius2)) {
        radius2 = 1;
      }
      if (!Point.isFloat(x)) {
        x = 0;
      }
      if (!Point.isFloat(y)) {
        y = 0;
      }
      if (!Point.isFloat(rotation)) {
        rotation = 0;
      }
      if (!Point.isFloat(segments)) {
        segments = 36;
      }
      return [radius1, radius2, x, y, rotation, segments];
    };

    return Ellipsis;

  })();

  this.geomjs.Mixin = Mixin;

  this.geomjs.Equatable = Equatable;

  this.geomjs.Formattable = Formattable;

  this.geomjs.Geometry = Geometry;

  this.geomjs.Surface = Surface;

  this.geomjs.Path = Path;

  this.geomjs.Point = Point;

  this.geomjs.Matrix = Matrix;

  this.geomjs.Rectangle = Rectangle;

  this.geomjs.Triangle = Triangle;

  this.geomjs.Circle = Circle;

  this.geomjs.Ellipsis = Ellipsis;

}).call(this);
