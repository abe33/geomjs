(function() {
  var Circle, Cloneable, CubicBezier, Diamond, Ellipsis, Equatable, Formattable, Geometry, Intersections, LinearSpline, Matrix, Memoizable, Mixin, Parameterizable, Path, Point, Polygon, Proxyable, QuadBezier, QuintBezier, Rectangle, Sourcable, Spiral, Spline, Surface, TransformationProxy, Triangle, Triangulable, include,
    __slice = [].slice,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.geomjs || (this.geomjs = {});

  /* src/geomjs/math.coffee */;


  Math.PI2 = Math.PI * 2;

  Math.PI_2 = Math.PI / 2;

  Math.PI_4 = Math.PI / 4;

  Math.PI_8 = Math.PI / 8;

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

  Math.isFloat = function() {
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

  Math.isInt = function() {
    var int, ints, _i, _len;
    ints = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    for (_i = 0, _len = ints.length; _i < _len; _i++) {
      int = ints[_i];
      if (isNaN(parseInt(int))) {
        return false;
      }
    }
    return true;
  };

  Math.asFloat = function() {
    var floats, i, n, _i, _len;
    floats = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    for (i = _i = 0, _len = floats.length; _i < _len; i = ++_i) {
      n = floats[i];
      floats[i] = parseFloat(n);
    }
    return floats;
  };

  Math.asInt = function() {
    var i, ints, n, _i, _len;
    ints = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    for (i = _i = 0, _len = ints.length; _i < _len; i = ++_i) {
      n = ints[i];
      ints[i] = parseInt(n);
    }
    return ints;
  };

  /* src/geomjs/include.coffee */;


  include = function() {
    var mixins;
    mixins = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    if (Object.prototype.toString.call(mixins[0]).indexOf('Array') >= 0) {
      mixins = mixins[0];
    }
    return {
      "in": function(klass) {
        return mixins.forEach(function(mixin) {
          return mixin.attachTo(klass);
        });
      }
    };
  };

  /* src/geomjs/mixins/mixin.coffee */;


  Mixin = (function() {

    function Mixin() {}

    Mixin.attachTo = function(klass) {
      var k, v, _ref;
      _ref = this.prototype;
      for (k in _ref) {
        v = _ref[k];
        if (k !== 'constructor') {
          klass.prototype[k] = v;
        }
      }
      return typeof this.included === "function" ? this.included(klass) : void 0;
    };

    return Mixin;

  })();

  /* src/geomjs/mixins/equatable.coffee */;


  Equatable = function() {
    var ConcretEquatable, properties;
    properties = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    return ConcretEquatable = (function(_super) {

      __extends(ConcretEquatable, _super);

      function ConcretEquatable() {
        return ConcretEquatable.__super__.constructor.apply(this, arguments);
      }

      ConcretEquatable.prototype.equals = function(o) {
        var _this = this;
        return (o != null) && properties.every(function(p) {
          if (_this[p].equals != null) {
            return _this[p].equals(o[p]);
          } else {
            return o[p] === _this[p];
          }
        });
      };

      return ConcretEquatable;

    })(Mixin);
  };

  /* src/geomjs/mixins/formattable.coffee */;


  Formattable = function() {
    var ConcretFormattable, classname, properties;
    classname = arguments[0], properties = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    return ConcretFormattable = (function(_super) {

      __extends(ConcretFormattable, _super);

      function ConcretFormattable() {
        return ConcretFormattable.__super__.constructor.apply(this, arguments);
      }

      ConcretFormattable.prototype.toString = function() {
        var formattedProperties, p;
        if (properties.length === 0) {
          return "[" + classname + "]";
        } else {
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
        }
      };

      ConcretFormattable.prototype.classname = function() {
        return classname;
      };

      return ConcretFormattable;

    })(Mixin);
  };

  /* src/geomjs/mixins/cloneable.coffee */;


  Cloneable = (function(_super) {

    __extends(Cloneable, _super);

    function Cloneable() {
      return Cloneable.__super__.constructor.apply(this, arguments);
    }

    Cloneable.included = function(klass) {
      return klass.prototype.clone = function() {
        return new klass(this);
      };
    };

    return Cloneable;

  })(Mixin);

  /* src/geomjs/mixins/sourcable.coffee */;


  Sourcable = function() {
    var ConcretSourcable, name, signature;
    name = arguments[0], signature = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    return ConcretSourcable = (function(_super) {

      __extends(ConcretSourcable, _super);

      function ConcretSourcable() {
        return ConcretSourcable.__super__.constructor.apply(this, arguments);
      }

      ConcretSourcable.prototype.toSource = function() {
        var arg, args;
        args = ((function() {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = signature.length; _i < _len; _i++) {
            arg = signature[_i];
            _results.push(this[arg]);
          }
          return _results;
        }).call(this)).map(function(o) {
          var isArray;
          switch (typeof o) {
            case 'object':
              isArray = Object.prototype.toString.call(o).indexOf('Array') !== -1;
              if (o.toSource != null) {
                return o.toSource();
              } else {
                if (isArray) {
                  return "[" + (o.map(function(el) {
                    if (el.toSource != null) {
                      return el.toSource();
                    } else {
                      return el;
                    }
                  })) + "]";
                } else {
                  return o;
                }
              }
              break;
            case 'string':
              if (o.toSource != null) {
                return o.toSource();
              } else {
                return "'" + (o.replace("'", "\\'")) + "'";
              }
              break;
            default:
              return o;
          }
        });
        return "new " + name + "(" + (args.join(',')) + ")";
      };

      return ConcretSourcable;

    })(Mixin);
  };

  /* src/geomjs/mixins/memoizable.coffee */;


  Memoizable = (function(_super) {

    __extends(Memoizable, _super);

    function Memoizable() {
      return Memoizable.__super__.constructor.apply(this, arguments);
    }

    Memoizable.prototype.memoized = function(prop) {
      var _ref;
      if (this.memoizationKey() === this.__memoizationKey__) {
        return ((_ref = this.__memo__) != null ? _ref[prop] : void 0) != null;
      } else {
        this.__memo__ = {};
        return false;
      }
    };

    Memoizable.prototype.memoFor = function(prop) {
      return this.__memo__[prop];
    };

    Memoizable.prototype.memoize = function(prop, value) {
      this.__memo__ || (this.__memo__ = {});
      this.__memoizationKey__ = this.memoizationKey();
      return this.__memo__[prop] = value;
    };

    Memoizable.prototype.memoizationKey = function() {
      return this.toString();
    };

    return Memoizable;

  })(Mixin);

  /* src/geomjs/mixins/parameterizable.coffee */;


  Parameterizable = function(method, parameters, allowPartial) {
    var ConcretParameterizable;
    if (allowPartial == null) {
      allowPartial = false;
    }
    return ConcretParameterizable = (function(_super) {

      __extends(ConcretParameterizable, _super);

      function ConcretParameterizable() {
        return ConcretParameterizable.__super__.constructor.apply(this, arguments);
      }

      ConcretParameterizable.included = function(klass) {
        var f;
        f = function() {
          var args, firstArgumentIsObject, k, keys, n, o, output, strict, v, value, _i;
          args = 2 <= arguments.length ? __slice.call(arguments, 0, _i = arguments.length - 1) : (_i = 0, []), strict = arguments[_i++];
          if (typeof strict === 'number') {
            args.push(strict);
            strict = false;
          }
          output = {};
          o = arguments[0];
          n = 0;
          firstArgumentIsObject = (o != null) && typeof o === 'object';
          for (k in parameters) {
            v = parameters[k];
            value = firstArgumentIsObject ? o[k] : arguments[n++];
            output[k] = parseFloat(value);
            if (isNaN(output[k])) {
              if (strict) {
                keys = ((function() {
                  var _j, _len, _results;
                  _results = [];
                  for (_j = 0, _len = parameters.length; _j < _len; _j++) {
                    k = parameters[_j];
                    _results.push(k);
                  }
                  return _results;
                })()).join(', ');
                throw new Error("" + output + " doesn't match pattern {" + keys + "}");
              }
              if (allowPartial) {
                delete output[k];
              } else {
                output[k] = v;
              }
            }
          }
          return output;
        };
        klass[method] = f;
        return klass.prototype[method] = f;
      };

      return ConcretParameterizable;

    })(Mixin);
  };

  /* src/geomjs/mixins/geometry.coffee */;


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

    pointsBounds = function(points, mode, axis) {
      return Math[mode].apply(Math, points.map(function(pt) {
        return pt[axis];
      }));
    };

    Geometry.prototype.top = function() {
      return pointsBounds(this.points(), 'min', 'y');
    };

    Geometry.prototype.bottom = function() {
      return pointsBounds(this.points(), 'max', 'y');
    };

    Geometry.prototype.left = function() {
      return pointsBounds(this.points(), 'min', 'x');
    };

    Geometry.prototype.right = function() {
      return pointsBounds(this.points(), 'max', 'x');
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

  /* src/geomjs/mixins/surface.coffee */;


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

  /* src/geomjs/mixins/path.coffee */;


  Path = (function(_super) {

    __extends(Path, _super);

    function Path() {
      return Path.__super__.constructor.apply(this, arguments);
    }

    Path.prototype.length = function() {
      return null;
    };

    Path.prototype.pathPointAt = function(pos, pathBasedOnLength) {
      var points;
      if (pathBasedOnLength == null) {
        pathBasedOnLength = true;
      }
      if (pos < 0) {
        pos = 0;
      }
      if (pos > 1) {
        pos = 1;
      }
      points = this.points();
      if (pos === 0) {
        return points[0];
      }
      if (pos === 1) {
        return points[points.length - 1];
      }
      if (pathBasedOnLength) {
        return this.walkPathBasedOnLength(pos, points);
      } else {
        return this.walkPathBasedOnSegments(pos, points);
      }
    };

    Path.prototype.pathOrientationAt = function(n, pathBasedOnLength) {
      var d, p1, p2;
      if (pathBasedOnLength == null) {
        pathBasedOnLength = true;
      }
      p1 = this.pathPointAt(n - 0.01, pathBasedOnLength);
      p2 = this.pathPointAt(n + 0.01, pathBasedOnLength);
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
      return this.pathPointAt((n + accuracy) % 1, pathBasedOnLength).subtract(this.pathPointAt((1 + n - accuracy) % 1), pathBasedOnLength).normalize(1);
    };

    Path.prototype.walkPathBasedOnLength = function(pos, points) {
      var i, innerStepPos, length, p1, p2, stepLength, walked, _i, _ref;
      walked = 0;
      length = this.length();
      for (i = _i = 1, _ref = points.length - 1; 1 <= _ref ? _i <= _ref : _i >= _ref; i = 1 <= _ref ? ++_i : --_i) {
        p1 = points[i - 1];
        p2 = points[i];
        stepLength = p1.distance(p2) / length;
        if (walked + stepLength > pos) {
          innerStepPos = Math.map(pos, walked, walked + stepLength, 0, 1);
          return this.pointInSegment(innerStepPos, [p1, p2]);
        }
        walked += stepLength;
      }
    };

    Path.prototype.walkPathBasedOnSegments = function(pos, points) {
      var segment, segments;
      segments = points.length - 1;
      pos = pos * segments;
      segment = Math.floor(pos);
      if (segment === segments) {
        segment -= 1;
      }
      return this.pointInSegment(pos - segment, points.slice(segment, +(segment + 1) + 1 || 9e9));
    };

    Path.prototype.pointInSegment = function(pos, segment) {
      return segment[0].add(segment[1].subtract(segment[0]).scale(pos));
    };

    return Path;

  })(Mixin);

  /* src/geomjs/mixins/intersections.coffee */;


  Intersections = (function(_super) {

    __extends(Intersections, _super);

    function Intersections() {
      return Intersections.__super__.constructor.apply(this, arguments);
    }

    Intersections.iterators = {};

    Intersections.prototype.intersects = function(geometry) {
      var iterator, output;
      if ((geometry.bounds != null) && !this.boundsCollide(geometry)) {
        return false;
      }
      output = false;
      iterator = this.intersectionsIterator(this, geometry);
      iterator.call(this, this, geometry, function() {
        return output = true;
      });
      return output;
    };

    Intersections.prototype.intersections = function(geometry) {
      var iterator, output;
      if ((geometry.bounds != null) && !this.boundsCollide(geometry)) {
        return null;
      }
      output = [];
      iterator = this.intersectionsIterator(this, geometry);
      iterator.call(this, this, geometry, function(intersection) {
        output.push(intersection);
        return false;
      });
      if (output.length > 0) {
        return output;
      } else {
        return null;
      }
    };

    Intersections.prototype.boundsCollide = function(geometry) {
      var bounds1, bounds2;
      bounds1 = this.bounds();
      bounds2 = geometry.bounds();
      return !(bounds1.top > bounds2.bottom || bounds1.left > bounds2.right || bounds1.bottom < bounds2.top || bounds1.right < bounds2.left);
    };

    Intersections.prototype.intersectionsIterator = function(geom1, geom2) {
      var c1, c2, iterator;
      c1 = geom1.classname ? geom1.classname() : '';
      c2 = geom2.classname ? geom2.classname() : '';
      iterator = null;
      iterator = Intersections.iterators[c1 + c2];
      iterator || (iterator = Intersections.iterators[c1]);
      iterator || (iterator = Intersections.iterators[c2]);
      return iterator || this.eachIntersections;
    };

    Intersections.prototype.eachIntersections = function(geom1, geom2, block, providesDataInCallback) {
      var context, cross, d1, d2, d3, d4, dif1, dif2, ev1, ev2, i, j, lastIntersection, length1, length2, points1, points2, sv1, sv2, _i, _j, _ref, _ref1;
      if (providesDataInCallback == null) {
        providesDataInCallback = false;
      }
      points1 = geom1.points();
      points2 = geom2.points();
      length1 = points1.length;
      length2 = points2.length;
      lastIntersection = null;
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
            if (cross.equals(lastIntersection)) {
              lastIntersection = cross;
              continue;
            }
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
            lastIntersection = cross;
          }
        }
      }
    };

    Intersections.prototype.perCrossing = function(start1, dir1, start2, dir2) {
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

    return Intersections;

  })(Mixin);

  /* src/geomjs/mixins/triangulable.coffee */;


  Triangulable = (function(_super) {
    var arrayCopy, pointInTriangle, polyArea, triangulate;

    __extends(Triangulable, _super);

    function Triangulable() {
      return Triangulable.__super__.constructor.apply(this, arguments);
    }

    Memoizable.attachTo(Triangulable);

    arrayCopy = function(arrayTo, arrayFrom) {
      var i, n, _i, _len, _results;
      _results = [];
      for (i = _i = 0, _len = arrayFrom.length; _i < _len; i = ++_i) {
        n = arrayFrom[i];
        _results.push(arrayTo[i] = n);
      }
      return _results;
    };

    pointInTriangle = function(pt, v1, v2, v3) {
      var b1, b2, b3, denom;
      denom = (v1.y - v3.y) * (v2.x - v3.x) + (v2.y - v3.y) * (v3.x - v1.x);
      b1 = ((pt.y - v3.y) * (v2.x - v3.x) + (v2.y - v3.y) * (v3.x - pt.x)) / denom;
      b2 = ((pt.y - v1.y) * (v3.x - v1.x) + (v3.y - v1.y) * (v1.x - pt.x)) / denom;
      b3 = ((pt.y - v2.y) * (v1.x - v2.x) + (v1.y - v2.y) * (v2.x - pt.x)) / denom;
      if (b1 < 0 || b2 < 0 || b3 < 0) {
        return false;
      }
      return true;
    };

    polyArea = function(pts) {
      var i, l, sum, _i, _ref;
      sum = 0;
      i = 0;
      l = pts.length;
      for (i = _i = 0, _ref = l - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
        sum += pts[i].x * pts[(i + 1) % l].y - pts[(i + 1) % l].x * pts[i].y;
      }
      return sum / 2;
    };

    triangulate = function(vertices) {
      var cr, i, j, l, n, nr, ok, pArea, pts, ptsArea, r1, r2, r3, refs, tArea, triangulated, v1, v2, v3;
      if (vertices.length < 4) {
        return;
      }
      pts = vertices;
      refs = (function() {
        var _i, _len, _results;
        _results = [];
        for (i = _i = 0, _len = pts.length; _i < _len; i = ++_i) {
          n = pts[i];
          _results.push(i);
        }
        return _results;
      })();
      ptsArea = [];
      i = 0;
      l = refs.length;
      while (i < l) {
        ptsArea[i] = pts[refs[i]].clone();
        ++i;
      }
      pArea = polyArea(ptsArea);
      cr = [];
      nr = [];
      arrayCopy(cr, refs);
      while (cr.length > 3) {
        i = 0;
        l = cr.length;
        while (i < l) {
          r1 = cr[i % l];
          r2 = cr[(i + 1) % l];
          r3 = cr[(i + 2) % l];
          v1 = pts[r1];
          v2 = pts[r2];
          v3 = pts[r3];
          ok = true;
          j = (i + 3) % l;
          while (j !== i) {
            ptsArea = [v1, v2, v3];
            tArea = polyArea(ptsArea);
            if ((pArea < 0 && tArea > 0) || (pArea > 0 && tArea < 0) || pointInTriangle(pts[cr[j]], v1, v2, v3)) {
              ok = false;
              break;
            }
            j = (j + 1) % l;
          }
          if (ok) {
            nr.push(r1, r2, r3);
            cr.splice((i + 1) % l, 1);
            break;
          }
          ++i;
        }
      }
      nr.push.apply(nr, cr.slice(0, 3));
      triangulated = true;
      return nr;
    };

    Triangulable.prototype.triangles = function() {
      var a, b, c, i, index, indices, triangles, vertices, _i, _ref;
      if (this.memoized('triangles')) {
        return this.memoFor('triangles');
      }
      vertices = this.points();
      vertices.pop();
      indices = triangulate(vertices);
      triangles = [];
      for (i = _i = 0, _ref = indices.length / 3 - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
        index = i * 3;
        a = vertices[indices[index]];
        b = vertices[indices[index + 1]];
        c = vertices[indices[index + 2]];
        triangles.push(new Triangle(a, b, c));
      }
      return this.memoize('triangles', triangles);
    };

    return Triangulable;

  })(Mixin);

  /* src/geomjs/mixins/proxyable.coffee */;


  Proxyable = (function(_super) {

    __extends(Proxyable, _super);

    function Proxyable() {
      return Proxyable.__super__.constructor.apply(this, arguments);
    }

    Proxyable.included = function(klass) {
      return klass.proxyable = function(type, target) {
        var k, v;
        for (k in target) {
          v = target[k];
          v.proxyable = type;
          klass.prototype[k] = v;
        }
        return target;
      };
    };

    return Proxyable;

  })(Mixin);

  /* src/geomjs/mixins/spline.coffee */;


  Spline = function(segmentSize) {
    var ConcretSpline;
    return ConcretSpline = (function(_super) {

      __extends(ConcretSpline, _super);

      function ConcretSpline() {
        return ConcretSpline.__super__.constructor.apply(this, arguments);
      }

      Memoizable.attachTo(ConcretSpline);

      ConcretSpline.included = function(klass) {
        klass.prototype.clone = function() {
          return new klass(this.vertices.map(function(pt) {
            return pt.clone();
          }), this.bias);
        };
        return klass.segmentSize = function() {
          return segmentSize;
        };
      };

      ConcretSpline.prototype.initSpline = function(vertices, bias) {
        this.vertices = vertices;
        this.bias = bias != null ? bias : 20;
        if (!this.validateVertices(this.vertices)) {
          throw new Error("The number of vertices for " + this + " doesn't match");
        }
      };

      ConcretSpline.prototype.center = function() {
        var vertex, x, y, _i, _len, _ref;
        x = y = 0;
        _ref = this.vertices;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          vertex = _ref[_i];
          x += vertex.x;
          y += vertex.y;
        }
        x = x / this.vertices.length;
        y = y / this.vertices.length;
        return new Point(x, y);
      };

      ConcretSpline.prototype.translate = function(x, y) {
        var i, vertex, _i, _len, _ref, _ref1;
        _ref = Point.pointFrom(x, y), x = _ref.x, y = _ref.y;
        _ref1 = this.vertices;
        for (i = _i = 0, _len = _ref1.length; _i < _len; i = ++_i) {
          vertex = _ref1[i];
          this.vertices[i] = vertex.add(x, y);
        }
        return this;
      };

      ConcretSpline.prototype.rotate = function(rotation) {
        var center, i, vertex, _i, _len, _ref;
        center = this.center();
        _ref = this.vertices;
        for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
          vertex = _ref[i];
          this.vertices[i] = vertex.rotateAround(center, rotation);
        }
        return this;
      };

      ConcretSpline.prototype.scale = function(scale) {
        var center, i, vertex, _i, _len, _ref;
        center = this.center();
        _ref = this.vertices;
        for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
          vertex = _ref[i];
          this.vertices[i] = center.add(vertex.subtract(center).scale(scale));
        }
        return this;
      };

      ConcretSpline.prototype.points = function() {
        var i, points, segments;
        if (this.memoized('points')) {
          return this.memoFor('points').concat();
        }
        segments = this.segments() * this.bias;
        points = (function() {
          var _i, _results;
          _results = [];
          for (i = _i = 0; 0 <= segments ? _i <= segments : _i >= segments; i = 0 <= segments ? ++_i : --_i) {
            _results.push(this.pathPointAt(i / segments));
          }
          return _results;
        }).call(this);
        return this.memoize('points', points).concat();
      };

      ConcretSpline.prototype.validateVertices = function(vertices) {
        return vertices.length % segmentSize === 1 && vertices.length >= segmentSize + 1;
      };

      ConcretSpline.prototype.segments = function() {
        if (!(this.vertices != null) || this.vertices.length === 0) {
          return 0;
        }
        if (this.memoized('segments')) {
          return this.memoFor('segments');
        }
        return this.memoize('segments', (this.vertices.length - 1) / segmentSize);
      };

      ConcretSpline.prototype.segmentSize = function() {
        return segmentSize;
      };

      ConcretSpline.prototype.segment = function(index) {
        var k;
        if (index < this.segments()) {
          k = "segment" + index;
          if (this.memoized(k)) {
            return this.memoFor(k);
          }
          return this.memoize(k, this.vertices.concat().slice(index * segmentSize, (index + 1) * segmentSize + 1));
        } else {
          return null;
        }
      };

      ConcretSpline.prototype.length = function() {
        return this.measure(this.bias);
      };

      ConcretSpline.prototype.measure = function(bias) {
        var i, length, _i, _ref;
        if (this.memoized('measure')) {
          return this.memoFor('measure');
        }
        length = 0;
        for (i = _i = 0, _ref = this.segments() - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
          length += this.measureSegment(this.segment(i), bias);
        }
        return this.memoize('measure', length);
      };

      ConcretSpline.prototype.measureSegment = function(segment, bias) {
        var i, k, length, step, _i;
        k = "segment" + segment + "_" + bias + "Length";
        if (this.memoized(k)) {
          return this.memoFor(k);
        }
        step = 1 / bias;
        length = 0;
        for (i = _i = 1; 1 <= bias ? _i <= bias : _i >= bias; i = 1 <= bias ? ++_i : --_i) {
          length += this.pointInSegment((i - 1) * step, segment).distance(this.pointInSegment(i * step, segment));
        }
        return this.memoize(k, length);
      };

      ConcretSpline.prototype.pathPointAt = function(pos, pathBasedOnLength) {
        if (pathBasedOnLength == null) {
          pathBasedOnLength = true;
        }
        if (pos < 0) {
          pos = 0;
        }
        if (pos > 1) {
          pos = 1;
        }
        if (pos === 0) {
          return this.vertices[0];
        }
        if (pos === 1) {
          return this.vertices[this.vertices.length - 1];
        }
        if (pathBasedOnLength) {
          return this.walkPathBasedOnLength(pos);
        } else {
          return this.walkPathBasedOnSegments(pos);
        }
      };

      ConcretSpline.prototype.walkPathBasedOnLength = function(pos) {
        var i, innerStepPos, length, segment, segments, stepLength, walked, _i, _ref;
        walked = 0;
        length = this.length();
        segments = this.segments();
        for (i = _i = 0, _ref = segments - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
          segment = this.segment(i);
          stepLength = this.measureSegment(segment, this.bias) / length;
          if (walked + stepLength > pos) {
            innerStepPos = Math.map(pos, walked, walked + stepLength, 0, 1);
            return this.pointInSegment(innerStepPos, segment);
          }
          walked += stepLength;
        }
      };

      ConcretSpline.prototype.walkPathBasedOnSegments = function(pos) {
        var segment, segments;
        segments = this.segments();
        pos = pos * segments;
        segment = Math.floor(pos);
        if (segment === segments) {
          segment -= 1;
        }
        return this.pointInSegment(pos - segment, this.segment(segment));
      };

      ConcretSpline.prototype.fill = function() {};

      ConcretSpline.prototype.drawPath = function(context) {
        var p, points, start, _i, _len, _results;
        points = this.points();
        start = points.shift();
        context.beginPath();
        context.moveTo(start.x, start.y);
        _results = [];
        for (_i = 0, _len = points.length; _i < _len; _i++) {
          p = points[_i];
          _results.push(context.lineTo(p.x, p.y));
        }
        return _results;
      };

      ConcretSpline.prototype.drawVertices = function(context, color) {
        var vertex, _i, _len, _ref, _results;
        context.fillStyle = color;
        _ref = this.vertices;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          vertex = _ref[_i];
          context.beginPath();
          context.arc(vertex.x, vertex.y, 2, 0, Math.PI * 2);
          context.fill();
          _results.push(context.closePath());
        }
        return _results;
      };

      ConcretSpline.prototype.drawVerticesConnections = function(context, color) {
        var i, vertexEnd, vertexStart, _i, _ref, _results;
        context.strokeStyle = color;
        _results = [];
        for (i = _i = 1, _ref = this.vertices.length - 1; 1 <= _ref ? _i <= _ref : _i >= _ref; i = 1 <= _ref ? ++_i : --_i) {
          vertexStart = this.vertices[i - 1];
          vertexEnd = this.vertices[i];
          context.beginPath();
          context.moveTo(vertexStart.x, vertexStart.y);
          context.lineTo(vertexEnd.x, vertexEnd.y);
          context.stroke();
          _results.push(context.closePath());
        }
        return _results;
      };

      ConcretSpline.prototype.memoizationKey = function() {
        return this.vertices.map(function(pt) {
          return "" + pt.x + ";" + pt.y;
        }).join(';');
      };

      return ConcretSpline;

    })(Mixin);
  };

  /* src/geomjs/point.coffee */;


  Point = (function() {

    include([Equatable('x', 'y'), Formattable('Point', 'x', 'y'), Sourcable('geomjs.Point', 'x', 'y'), Cloneable])["in"](Point);

    Point.isPoint = function(pt) {
      return (pt != null) && (pt.x != null) && (pt.y != null);
    };

    Point.pointFrom = function(xOrPt, y, strict) {
      var x;
      if (strict == null) {
        strict = false;
      }
      x = xOrPt;
      if ((xOrPt != null) && typeof xOrPt === 'object') {
        x = xOrPt.x, y = xOrPt.y;
      }
      if (strict && (isNaN(x) || isNaN(y))) {
        this.notAPoint([x, y]);
      }
      return new Point(x, y);
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
        } else if (Math.isFloat(args[0]) && Math.isFloat(args[1])) {
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
      var msg;
      msg = "Can't find the " + pos + " point in Point.interpolate arguments " + args;
      throw new Error(msg);
    };

    Point.notAPoint = function(args) {
      throw new Error("" + args + " is not a point");
    };

    function Point(x, y) {
      if (x != null) {
        y = x.y || y;
      }
      if (isNaN(y)) {
        y = 0;
      }
      if (x != null) {
        x = x.x || x;
      }
      if (isNaN(x)) {
        x = 0;
      }
      this.x = x;
      this.y = y;
    }

    Point.prototype.length = function() {
      return Math.sqrt((this.x * this.x) + (this.y * this.y));
    };

    Point.prototype.angle = function() {
      return Math.atan2(this.y, this.x);
    };

    Point.prototype.angleWith = function(x, y) {
      var d, isPoint;
      if (!(x != null) && !(y != null)) {
        this.noPoint('dot');
      }
      isPoint = this.isPoint(x);
      y = isPoint ? x.y : y;
      x = isPoint ? x.x : x;
      if (isNaN(x) || isNaN(y)) {
        Point.notAPoint([x, y]);
      }
      d = this.normalize().dot(new Point(x, y).normalize());
      return Math.acos(Math.abs(d)) * (d < 0 ? -1 : 1);
    };

    Point.prototype.normalize = function(length) {
      var l;
      if (length == null) {
        length = 1;
      }
      if (!Math.isFloat(length)) {
        this.invalidLength(length);
      }
      l = this.length();
      return new Point(this.x / l * length, this.y / l * length);
    };

    Point.prototype.add = function(x, y) {
      if (x != null) {
        y = x.y || y;
      }
      if (isNaN(y)) {
        y = 0;
      }
      if (x != null) {
        x = x.x || x;
      }
      if (isNaN(x)) {
        x = 0;
      }
      return new Point(this.x + x, this.y + y);
    };

    Point.prototype.subtract = function(x, y) {
      if (x != null) {
        y = x.y || y;
      }
      if (isNaN(y)) {
        y = 0;
      }
      if (x != null) {
        x = x.x || x;
      }
      if (isNaN(x)) {
        x = 0;
      }
      return new Point(this.x - x, this.y - y);
    };

    Point.prototype.dot = function(x, y) {
      var isPoint;
      if (!(x != null) && !(y != null)) {
        this.noPoint('dot');
      }
      isPoint = this.isPoint(x);
      y = isPoint ? x.y : y;
      x = isPoint ? x.x : x;
      if (isNaN(x) || isNaN(y)) {
        Point.notAPoint([x, y]);
      }
      return this.x * x + this.y * y;
    };

    Point.prototype.distance = function(x, y) {
      var isPoint;
      if (!(x != null) && !(y != null)) {
        this.noPoint('distance');
      }
      isPoint = this.isPoint(x);
      y = isPoint ? x.y : y;
      x = isPoint ? x.x : x;
      if (isNaN(x) || isNaN(y)) {
        Point.notAPoint([x, y]);
      }
      return this.subtract(x, y).length();
    };

    Point.prototype.scale = function(n) {
      if (!Math.isFloat(n)) {
        this.invalidScale(n);
      }
      return new Point(this.x * n, this.y * n);
    };

    Point.prototype.rotate = function(n) {
      var a, l, x, y;
      if (!Math.isFloat(n)) {
        this.invalidRotation(n);
      }
      l = this.length();
      a = Math.atan2(this.y, this.x) + n;
      x = Math.cos(a) * l;
      y = Math.sin(a) * l;
      return new Point(x, y);
    };

    Point.prototype.rotateAround = function(x, y, a) {
      var isPoint;
      isPoint = this.isPoint(x);
      if (isPoint) {
        a = y;
      }
      y = isPoint ? x.y : y;
      x = isPoint ? x.x : x;
      return this.subtract(x, y).rotate(a).add(x, y);
    };

    Point.prototype.isPoint = Point.isPoint;

    Point.prototype.pointFrom = Point.pointFrom;

    Point.prototype.defaultToZero = function(x, y) {
      x = isNaN(x) ? 0 : x;
      y = isNaN(y) ? 0 : y;
      return [x, y];
    };

    Point.prototype.paste = function(x, y) {
      var isObject;
      if (!(x != null) && !(y != null)) {
        return this;
      }
      isObject = (x != null) && typeof x === 'object';
      y = isObject ? x.y : y;
      x = isObject ? x.x : x;
      if (!isNaN(x)) {
        this.x = x;
      }
      if (!isNaN(y)) {
        this.y = y;
      }
      return this;
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

    include([
      Equatable.apply(null, PROPERTIES), Formattable.apply(null, ['Matrix'].concat(PROPERTIES)), Sourcable.apply(null, ['geomjs.Matrix'].concat(PROPERTIES)), Parameterizable('matrixFrom', {
        a: 1,
        b: 0,
        c: 0,
        d: 1,
        tx: 0,
        ty: 0
      }), Cloneable
    ])["in"](Matrix);

    Matrix.isMatrix = function(m) {
      var k, _i, _len;
      if (m == null) {
        return false;
      }
      for (_i = 0, _len = PROPERTIES.length; _i < _len; _i++) {
        k = PROPERTIES[_i];
        if (!Math.isFloat(m[k])) {
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
      _ref = this.matrixFrom(a, b, c, d, tx, ty, true), this.a = _ref.a, this.b = _ref.b, this.c = _ref.c, this.d = _ref.d, this.tx = _ref.tx, this.ty = _ref.ty;
    }

    Matrix.prototype.transformPoint = function(xOrPt, y) {
      var x, _ref;
      if (!(xOrPt != null) && !(y != null)) {
        throw new Error("transformPoint was called without arguments");
      }
      _ref = Point.pointFrom(xOrPt, y, true), x = _ref.x, y = _ref.y;
      return new Point(x * this.a + y * this.c + this.tx, x * this.b + y * this.d + this.ty);
    };

    Matrix.prototype.translate = function(xOrPt, y) {
      var x, _ref;
      if (xOrPt == null) {
        xOrPt = 0;
      }
      if (y == null) {
        y = 0;
      }
      _ref = Point.pointFrom(xOrPt, y), x = _ref.x, y = _ref.y;
      this.tx += x;
      this.ty += y;
      return this;
    };

    Matrix.prototype.scale = function(xOrPt, y) {
      var x, _ref;
      if (xOrPt == null) {
        xOrPt = 1;
      }
      if (y == null) {
        y = 1;
      }
      _ref = Point.pointFrom(xOrPt, y), x = _ref.x, y = _ref.y;
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
      cos = Math.cos(angle);
      sin = Math.sin(angle);
      _ref = [this.a * cos - this.b * sin, this.a * sin + this.b * cos, this.c * cos - this.d * sin, this.c * sin + this.d * cos, this.tx * cos - this.ty * sin, this.tx * sin + this.ty * cos], this.a = _ref[0], this.b = _ref[1], this.c = _ref[2], this.d = _ref[3], this.tx = _ref[4], this.ty = _ref[5];
      return this;
    };

    Matrix.prototype.skew = function(xOrPt, y) {
      var pt;
      pt = Point.pointFrom(xOrPt, y, 0);
      return this.append(Math.cos(pt.y), Math.sin(pt.y), -Math.sin(pt.x), Math.cos(pt.x));
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
      _ref = this.matrixFrom(a, b, c, d, tx, ty, true), a = _ref.a, b = _ref.b, c = _ref.c, d = _ref.d, tx = _ref.tx, ty = _ref.ty;
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
      _ref = this.matrixFrom(a, b, c, d, tx, ty, true), a = _ref.a, b = _ref.b, c = _ref.c, d = _ref.d, tx = _ref.tx, ty = _ref.ty;
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

    Matrix.prototype.isMatrix = function(m) {
      return Matrix.isMatrix(m);
    };

    return Matrix;

  })();

  /* src/geomjs/rectangle.coffee */;


  Rectangle = (function() {
    var PROPERTIES, iterators, k;

    PROPERTIES = ['x', 'y', 'width', 'height', 'rotation'];

    include([
      Equatable.apply(null, PROPERTIES), Formattable.apply(null, ['Rectangle'].concat(PROPERTIES)), Sourcable.apply(null, ['geomjs.Rectangle'].concat(PROPERTIES)), Parameterizable('rectangleFrom', {
        x: NaN,
        y: NaN,
        width: NaN,
        height: NaN,
        rotation: NaN
      }), Cloneable, Geometry, Surface, Path, Triangulable, Proxyable, Intersections
    ])["in"](Rectangle);

    Rectangle.eachRectangleRectangleIntersections = function(geom1, geom2, block, data) {
      var p, _i, _len, _ref;
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
        return this.eachIntersections(geom1, geom2, block, data);
      }
    };

    iterators = Intersections.iterators;

    k = 'RectangleRectangle';

    iterators[k] = Rectangle.eachRectangleRectangleIntersections;

    function Rectangle(x, y, width, height, rotation) {
      var args;
      args = this.defaultToZero(this.rectangleFrom.apply(this, arguments));
      this.x = args.x, this.y = args.y, this.width = args.width, this.height = args.height, this.rotation = args.rotation;
    }

    Rectangle.prototype.corners = function() {
      return [this.topLeft(), this.topRight(), this.bottomRight(), this.bottomLeft()];
    };

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
      return this.topLeft().add(this.diagonal().scale(0.5));
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

    Rectangle.prototype.edges = function() {
      return [this.topEdge(), this.topRight(), this.bottomRight(), this.bottomLeft()];
    };

    Rectangle.prototype.topEdge = function() {
      return new Point(this.width * Math.cos(this.rotation), this.width * Math.sin(this.rotation));
    };

    Rectangle.prototype.leftEdge = function() {
      return new Point(this.height * Math.cos(this.rotation + Math.PI / 2), this.height * Math.sin(this.rotation + Math.PI / 2));
    };

    Rectangle.prototype.bottomEdge = function() {
      return this.topEdge();
    };

    Rectangle.prototype.rightEdge = function() {
      return this.leftEdge();
    };

    Rectangle.prototype.diagonal = function() {
      return this.leftEdge().add(this.topEdge());
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
      var pt;
      pt = Point.pointFrom(xOrPt, y).subtract(this.center());
      this.x += pt.x;
      this.y += pt.y;
      return this;
    };

    Rectangle.prototype.translate = function(xOrPt, y) {
      var pt;
      pt = Point.pointFrom(xOrPt, y);
      this.x += pt.x;
      this.y += pt.y;
      return this;
    };

    Rectangle.prototype.rotate = function(rotation) {
      var _ref;
      _ref = this.topLeft().rotateAround(this.center(), rotation), this.x = _ref.x, this.y = _ref.y;
      this.rotation += rotation;
      return this;
    };

    Rectangle.prototype.scale = function(scale) {
      var dif, topLeft, _ref;
      topLeft = this.topLeft();
      dif = topLeft.subtract(this.center()).scale(scale);
      _ref = topLeft.add(dif.scale(1 / 2)), this.x = _ref.x, this.y = _ref.y;
      this.width *= scale;
      this.height *= scale;
      return this;
    };

    Rectangle.prototype.rotateAroundCenter = Rectangle.prototype.rotate;

    Rectangle.prototype.scaleAroundCenter = Rectangle.prototype.scale;

    Rectangle.prototype.inflateAroundCenter = function(xOrPt, y) {
      var center;
      center = this.center();
      this.inflate(xOrPt, y);
      this.setCenter(center);
      return this;
    };

    Rectangle.prototype.inflate = function(xOrPt, y) {
      var pt;
      pt = Point.pointFrom(xOrPt, y);
      this.width += pt.x;
      this.height += pt.y;
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
      var pt;
      pt = Point.pointFrom(xOrPt, y);
      this.inflateLeft(pt.x);
      this.inflateTop(pt.y);
      return this;
    };

    Rectangle.prototype.inflateTopRight = function(xOrPt, y) {
      var pt;
      pt = Point.pointFrom(xOrPt, y);
      this.inflateRight(pt.x);
      this.inflateTop(pt.y);
      return this;
    };

    Rectangle.prototype.inflateBottomLeft = function(xOrPt, y) {
      var pt;
      pt = Point.pointFrom(xOrPt, y);
      this.inflateLeft(pt.x);
      this.inflateBottom(pt.y);
      return this;
    };

    Rectangle.prototype.inflateBottomRight = function(xOrPt, y) {
      return this.inflate(xOrPt, y);
    };

    Rectangle.prototype.closedGeometry = function() {
      return true;
    };

    Rectangle.proxyable('PointList', {
      points: function() {
        return [this.topLeft(), this.topRight(), this.bottomRight(), this.bottomLeft(), this.topLeft()];
      }
    });

    Rectangle.prototype.pointAtAngle = function(angle) {
      var center, vec, _ref;
      center = this.center();
      vec = center.add(Math.cos(angle) * 10000, Math.sin(angle) * 10000);
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
      var x, _ref;
      _ref = new Point(xOrPt, y).rotateAround(this.topLeft(), -this.rotation), x = _ref.x, y = _ref.y;
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

    Rectangle.proxyable('Point', {
      pathPointAt: function(n, pathBasedOnLength) {
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
      }
    });

    Rectangle.proxyable('Angle', {
      pathOrientationAt: function(n, pathBasedOnLength) {
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
      }
    });

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

    Rectangle.prototype.paste = function(x, y, width, height, rotation) {
      var v, values, _results;
      values = this.rectangleFrom(x, y, width, height, rotation);
      _results = [];
      for (k in values) {
        v = values[k];
        if (Math.isFloat(v)) {
          _results.push(this[k] = parseFloat(v));
        }
      }
      return _results;
    };

    Rectangle.prototype.defaultToZero = function(values) {
      var v;
      for (k in values) {
        v = values[k];
        if (!Math.isFloat(v)) {
          values[k] = 0;
        }
      }
      return values;
    };

    return Rectangle;

  })();

  /* src/geomjs/triangle.coffee */;


  Triangle = (function() {

    include([Equatable('a', 'b', 'c'), Formattable('Triangle', 'a', 'b', 'c'), Sourcable('geomjs.Triangle', 'a', 'b', 'c'), Cloneable, Memoizable, Geometry, Surface, Path, Intersections])["in"](Triangle);

    Triangle.triangleFrom = function(a, b, c) {
      var _ref;
      if ((a != null) && typeof a === 'object' && !Point.isPoint(a)) {
        _ref = a, a = _ref.a, b = _ref.b, c = _ref.c;
      }
      if (!Point.isPoint(a)) {
        this.invalidPoint('a', a);
      }
      if (!Point.isPoint(b)) {
        this.invalidPoint('b', b);
      }
      if (!Point.isPoint(c)) {
        this.invalidPoint('c', c);
      }
      return {
        a: new Point(a),
        b: new Point(b),
        c: new Point(c)
      };
    };

    function Triangle(a, b, c) {
      var _ref;
      _ref = this.triangleFrom(a, b, c), this.a = _ref.a, this.b = _ref.b, this.c = _ref.c;
      this.__cache__ = {};
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

    Triangle.prototype.edges = function() {
      return [this.ab(), this.bc(), this.ca()];
    };

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
      sqr = Math.PI / 2;
      return Math.deltaBelowRatio(Math.abs(this.abc()), sqr) || Math.deltaBelowRatio(Math.abs(this.bac()), sqr) || Math.deltaBelowRatio(Math.abs(this.acb()), sqr);
    };

    Triangle.prototype.translate = function(x, y) {
      var pt;
      pt = Point.pointFrom(x, y);
      this.a.x += pt.x;
      this.a.y += pt.y;
      this.b.x += pt.x;
      this.b.y += pt.y;
      this.c.x += pt.x;
      this.c.y += pt.y;
      return this;
    };

    Triangle.prototype.rotate = function(rotation) {
      var center;
      center = this.center();
      this.a = this.a.rotateAround(center, rotation);
      this.b = this.b.rotateAround(center, rotation);
      this.c = this.c.rotateAround(center, rotation);
      return this;
    };

    Triangle.prototype.scale = function(scale) {
      var center;
      center = this.center();
      this.a = center.add(this.a.subtract(center).scale(scale));
      this.b = center.add(this.b.subtract(center).scale(scale));
      this.c = center.add(this.c.subtract(center).scale(scale));
      return this;
    };

    Triangle.prototype.rotateAroundCenter = Triangle.prototype.rotate;

    Triangle.prototype.scaleAroundCenter = Triangle.prototype.scale;

    Triangle.prototype.closedGeometry = function() {
      return true;
    };

    Triangle.prototype.points = function() {
      return [this.a.clone(), this.b.clone(), this.c.clone(), this.a.clone()];
    };

    Triangle.prototype.pointAtAngle = function(angle) {
      var center, vec, _ref;
      center = this.center();
      vec = center.add(Math.cos(angle) * 10000, Math.sin(angle) * 10000);
      return (_ref = this.intersections({
        points: function() {
          return [center, vec];
        }
      })) != null ? _ref[0] : void 0;
    };

    Triangle.prototype.acreage = function() {
      if (this.memoized('acreage')) {
        return this.memoFor('acreage');
      }
      return this.memoize('acreage', this.ab().length() * this.bc().length() * Math.abs(Math.sin(this.abc())) / 2);
    };

    Triangle.prototype.contains = function(xOrPt, y) {
      var dot00, dot01, dot02, dot11, dot12, invDenom, p, u, v, v0, v1, v2;
      p = new Point(xOrPt, y);
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
      return u > 0 && v > 0 && u + v < 1;
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

    Triangle.prototype.memoizationKey = function() {
      return "" + this.a.x + ";" + this.a.y + ";" + this.b.x + ";" + this.b.y + ";" + this.c.x + ";" + this.c.y;
    };

    Triangle.prototype.triangleFrom = Triangle.triangleFrom;

    Triangle.prototype.invalidPoint = function(k, v) {
      throw new Error("Invalid point " + v + " for vertex " + k);
    };

    return Triangle;

  })();

  /* src/geomjs/circle.coffee */;


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

  /* src/geomjs/ellipsis.coffee */;


  Ellipsis = (function() {
    var PROPERTIES;

    PROPERTIES = ['radius1', 'radius2', 'x', 'y', 'rotation', 'segments'];

    include([
      Equatable.apply(null, PROPERTIES), Formattable.apply(null, ['Ellipsis'].concat(PROPERTIES)), Parameterizable('ellipsisFrom', {
        radius1: 1,
        radius2: 1,
        x: 0,
        y: 0,
        rotation: 0,
        segments: 36
      }), Sourcable.apply(null, ['geomjs.Ellipsis'].concat(PROPERTIES)), Cloneable, Memoizable, Geometry, Surface, Path, Intersections
    ])["in"](Ellipsis);

    function Ellipsis(r1, r2, x, y, rot, segments) {
      var _ref;
      _ref = this.ellipsisFrom(r1, r2, x, y, rot, segments), this.radius1 = _ref.radius1, this.radius2 = _ref.radius2, this.x = _ref.x, this.y = _ref.y, this.rotation = _ref.rotation, this.segments = _ref.segments;
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
      phi = this.rotation;
      t = Math.atan(-this.radius2 * Math.tan(phi) / this.radius1);
      return [t, t + Math.PI].map(function(t) {
        return _this.x + _this.radius1 * Math.cos(t) * Math.cos(phi) - _this.radius2 * Math.sin(t) * Math.sin(phi);
      });
    };

    Ellipsis.prototype.yBounds = function() {
      var phi, t,
        _this = this;
      phi = this.rotation;
      t = Math.atan(this.radius2 * (Math.cos(phi) / Math.sin(phi)) / this.radius1);
      return [t, t + Math.PI].map(function(t) {
        return _this.y + _this.radius1 * Math.cos(t) * Math.sin(phi) + _this.radius2 * Math.sin(t) * Math.cos(phi);
      });
    };

    Ellipsis.prototype.translate = function(xOrPt, y) {
      var x, _ref;
      _ref = Point.pointFrom(xOrPt, y), x = _ref.x, y = _ref.y;
      this.x += x;
      this.y += y;
      return this;
    };

    Ellipsis.prototype.rotate = function(rotation) {
      this.rotation += rotation;
      return this;
    };

    Ellipsis.prototype.scale = function(scale) {
      this.radius1 *= scale;
      this.radius2 *= scale;
      return this;
    };

    Ellipsis.prototype.points = function() {
      var n;
      if (this.memoized('points')) {
        this.memoFor('points').concat();
      }
      return this.memoize('points', (function() {
        var _i, _ref, _results;
        _results = [];
        for (n = _i = 0, _ref = this.segments; 0 <= _ref ? _i <= _ref : _i >= _ref; n = 0 <= _ref ? ++_i : --_i) {
          _results.push(this.pathPointAt(n / this.segments));
        }
        return _results;
      }).call(this));
    };

    Ellipsis.prototype.triangles = function() {
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

    Ellipsis.prototype.closedGeometry = function() {
      return true;
    };

    Ellipsis.prototype.pointAtAngle = function(angle) {
      var a, p, ratio, vec;
      a = angle - this.rotation;
      ratio = this.radius1 / this.radius2;
      vec = new Point(Math.cos(a) * this.radius1, Math.sin(a) * this.radius1);
      if (this.radius1 < this.radius2) {
        vec.x = vec.x / ratio;
      }
      if (this.radius1 > this.radius2) {
        vec.y = vec.y * ratio;
      }
      a = vec.angle();
      p = new Point(Math.cos(a) * this.radius1, Math.sin(a) * this.radius2);
      return this.center().add(p.rotate(this.rotation));
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
      var a, c, d, p, p2;
      p = new Point(xOrPt, y);
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
      context.rotate(this.rotation);
      context.scale(this.radius1, this.radius2);
      context.beginPath();
      context.arc(0, 0, 1, 0, Math.PI * 2);
      context.closePath();
      return context.restore();
    };

    Ellipsis.prototype.memoizationKey = function() {
      return "" + this.radius1 + ";" + this.radius2 + ";" + this.x + ";" + this.y + ";" + this.segments;
    };

    return Ellipsis;

  })();

  /* src/geomjs/diamond.coffee */;


  Diamond = (function() {
    var PROPERTIES;

    PROPERTIES = ['topLength', 'rightLength', 'bottomLength', 'leftLength', 'x', 'y', 'rotation'];

    include([
      Formattable.apply(Formattable, ['Diamond'].concat(PROPERTIES)), Parameterizable('diamondFrom', {
        topLength: 1,
        rightLength: 1,
        bottomLength: 1,
        leftLength: 1,
        x: 0,
        y: 0,
        rotation: 0
      }), Sourcable(['geomjs.Diamond'].concat(PROPERTIES)), Equatable.apply(Equatable, PROPERTIES), Cloneable, Geometry, Memoizable, Surface, Path, Intersections
    ])["in"](Diamond);

    function Diamond(topLength, rightLength, bottomLength, leftLength, x, y, rotation) {
      var args;
      args = this.diamondFrom(topLength, rightLength, bottomLength, leftLength, x, y, rotation);
      this.topLength = args.topLength, this.rightLength = args.rightLength, this.bottomLength = args.bottomLength, this.leftLength = args.leftLength, this.x = args.x, this.y = args.y, this.rotation = args.rotation;
    }

    Diamond.prototype.center = function() {
      return new Point(this.x, this.y);
    };

    Diamond.prototype.topAxis = function() {
      return new Point(0, -this.topLength).rotate(this.rotation);
    };

    Diamond.prototype.bottomAxis = function() {
      return new Point(0, this.bottomLength).rotate(this.rotation);
    };

    Diamond.prototype.leftAxis = function() {
      return new Point(-this.leftLength, 0).rotate(this.rotation);
    };

    Diamond.prototype.rightAxis = function() {
      return new Point(this.rightLength, 0).rotate(this.rotation);
    };

    Diamond.prototype.corners = function() {
      return [this.topCorner(), this.rightCorner(), this.bottomCorner(), this.leftCorner()];
    };

    Diamond.prototype.topCorner = function() {
      return this.center().add(this.topAxis());
    };

    Diamond.prototype.bottomCorner = function() {
      return this.center().add(this.bottomAxis());
    };

    Diamond.prototype.leftCorner = function() {
      return this.center().add(this.leftAxis());
    };

    Diamond.prototype.rightCorner = function() {
      return this.center().add(this.rightAxis());
    };

    Diamond.prototype.edges = function() {
      return [this.topLeftEdge(), this.topRightEdge(), this.bottomRightEdge(), this.bottomLeftEdge()];
    };

    Diamond.prototype.topLeftEdge = function() {
      return this.topCorner().subtract(this.leftCorner());
    };

    Diamond.prototype.topRightEdge = function() {
      return this.rightCorner().subtract(this.topCorner());
    };

    Diamond.prototype.bottomLeftEdge = function() {
      return this.leftCorner().subtract(this.bottomCorner());
    };

    Diamond.prototype.bottomRightEdge = function() {
      return this.bottomCorner().subtract(this.rightCorner());
    };

    Diamond.prototype.quadrants = function() {
      return [this.topLeftQuadrant(), this.topRightQuadrant(), this.bottomRightQuadrant(), this.bottomLeftQuadrant()];
    };

    Diamond.prototype.topLeftQuadrant = function() {
      var k;
      k = 'topLeftQuadrant';
      if (this.memoized(k)) {
        return this.memoFor(k);
      }
      return this.memoize(k, new Triangle(this.center(), this.topCorner(), this.leftCorner()));
    };

    Diamond.prototype.topRightQuadrant = function() {
      var k;
      k = 'topRightQuadrant';
      if (this.memoized(k)) {
        return this.memoFor(k);
      }
      return this.memoize(k, new Triangle(this.center(), this.topCorner(), this.rightCorner()));
    };

    Diamond.prototype.bottomLeftQuadrant = function() {
      var k;
      k = 'bottomLeftQuadrant';
      if (this.memoized(k)) {
        return this.memoFor(k);
      }
      return this.memoize(k, new Triangle(this.center(), this.bottomCorner(), this.leftCorner()));
    };

    Diamond.prototype.bottomRightQuadrant = function() {
      var k;
      k = 'bottomRightQuadrant';
      if (this.memoized(k)) {
        return this.memoFor(k);
      }
      return this.memoize(k, new Triangle(this.center(), this.bottomCorner(), this.rightCorner()));
    };

    Diamond.prototype.top = function() {
      return Math.min(this.topCorner().y, this.bottomCorner().y, this.leftCorner().y, this.rightCorner().y);
    };

    Diamond.prototype.bottom = function() {
      return Math.max(this.topCorner().y, this.bottomCorner().y, this.leftCorner().y, this.rightCorner().y);
    };

    Diamond.prototype.left = function() {
      return Math.min(this.topCorner().x, this.bottomCorner().x, this.leftCorner().x, this.rightCorner().x);
    };

    Diamond.prototype.right = function() {
      return Math.max(this.topCorner().x, this.bottomCorner().x, this.leftCorner().x, this.rightCorner().x);
    };

    Diamond.prototype.translate = function(xOrPt, y) {
      var x, _ref;
      _ref = Point.pointFrom(xOrPt, y), x = _ref.x, y = _ref.y;
      this.x += x;
      this.y += y;
      return this;
    };

    Diamond.prototype.rotate = function(rotation) {
      this.rotation += rotation;
      return this;
    };

    Diamond.prototype.scale = function(scale) {
      this.topLength *= scale;
      this.bottomLength *= scale;
      this.rightLength *= scale;
      this.leftLength *= scale;
      return this;
    };

    Diamond.prototype.points = function() {
      var t;
      return [t = this.topCorner(), this.rightCorner(), this.bottomCorner(), this.leftCorner(), t];
    };

    Diamond.prototype.triangles = function() {
      return this.quadrants();
    };

    Diamond.prototype.closedGeometry = function() {
      return true;
    };

    Diamond.prototype.pointAtAngle = function(angle) {
      var center, vec, _ref;
      center = this.center();
      vec = center.add(Math.cos(angle) * 10000, Math.sin(angle) * 10000);
      return (_ref = this.intersections({
        points: function() {
          return [center, vec];
        }
      })) != null ? _ref[0] : void 0;
    };

    Diamond.prototype.acreage = function() {
      return this.topLeftQuadrant().acreage() + this.topRightQuadrant().acreage() + this.bottomLeftQuadrant().acreage() + this.bottomRightQuadrant().acreage();
    };

    Diamond.prototype.contains = function(x, y) {
      return this.center().equals(x, y) || this.topLeftQuadrant().contains(x, y) || this.topRightQuadrant().contains(x, y) || this.bottomLeftQuadrant().contains(x, y) || this.bottomRightQuadrant().contains(x, y);
    };

    Diamond.prototype.randomPointInSurface = function(random) {
      var a, a1, a2, a3, a4, l, l1, l2, l3, l4, n, q1, q2, q3, q4;
      l = this.acreage();
      q1 = this.topLeftQuadrant();
      q2 = this.topRightQuadrant();
      q3 = this.bottomRightQuadrant();
      q4 = this.bottomLeftQuadrant();
      a1 = q1.acreage();
      a2 = q2.acreage();
      a3 = q3.acreage();
      a4 = q4.acreage();
      a = a1 + a2 + a3 + a4;
      l1 = a1 / a;
      l2 = a2 / a;
      l3 = a3 / a;
      l4 = a4 / a;
      n = random.get();
      if (n < l1) {
        return q1.randomPointInSurface(random);
      } else if (n < l1 + l2) {
        return q2.randomPointInSurface(random);
      } else if (n < l1 + l2 + l3) {
        return q3.randomPointInSurface(random);
      } else {
        return q4.randomPointInSurface(random);
      }
    };

    Diamond.prototype.length = function() {
      return this.topRightEdge().length() + this.topLeftEdge().length() + this.bottomRightEdge().length() + this.bottomLeftEdge().length();
    };

    Diamond.prototype.pathPointAt = function(n, pathBasedOnLength) {
      var p1, p2, p3, _ref;
      if (pathBasedOnLength == null) {
        pathBasedOnLength = true;
      }
      _ref = this.pathSteps(pathBasedOnLength), p1 = _ref[0], p2 = _ref[1], p3 = _ref[2];
      if (n < p1) {
        return this.topCorner().add(this.topRightEdge().scale(Math.map(n, 0, p1, 0, 1)));
      } else if (n < p2) {
        return this.rightCorner().add(this.bottomRightEdge().scale(Math.map(n, p1, p2, 0, 1)));
      } else if (n < p3) {
        return this.bottomCorner().add(this.bottomLeftEdge().scale(Math.map(n, p2, p3, 0, 1)));
      } else {
        return this.leftCorner().add(this.topLeftEdge().scale(Math.map(n, p3, 1, 0, 1)));
      }
    };

    Diamond.prototype.pathOrientationAt = function(n, pathBasedOnLength) {
      var p, p1, p2, p3, _ref;
      if (pathBasedOnLength == null) {
        pathBasedOnLength = true;
      }
      _ref = this.pathSteps(pathBasedOnLength), p1 = _ref[0], p2 = _ref[1], p3 = _ref[2];
      if (n < p1) {
        p = this.topRightEdge();
      } else if (n < p2) {
        p = this.bottomRightEdge();
      } else if (n < p3) {
        p = this.bottomLeftEdge().scale(-1);
      } else {
        p = this.topLeftEdge().scale(-1);
      }
      return p.angle();
    };

    Diamond.prototype.pathSteps = function(pathBasedOnLength) {
      var l, p1, p2, p3;
      if (pathBasedOnLength == null) {
        pathBasedOnLength = true;
      }
      if (pathBasedOnLength) {
        l = this.length();
        p1 = this.topRightEdge().length() / l;
        p2 = p1 + this.bottomRightEdge().length() / l;
        p3 = p2 + this.bottomLeftEdge().length() / l;
      } else {
        p1 = 1 / 4;
        p2 = 1 / 2;
        p3 = 3 / 4;
      }
      return [p1, p2, p3];
    };

    Diamond.prototype.memoizationKey = function() {
      return "" + this.x + ";" + this.y + ";" + this.topLength + ";" + this.bottomLength + ";" + this.leftLength + ";" + this.rightLength;
    };

    return Diamond;

  })();

  /* src/geomjs/polygon.coffee */;


  Polygon = (function() {

    include([Formattable('Polygon', 'vertices'), Sourcable('geomjs.Polygon', 'vertices'), Cloneable, Geometry, Intersections, Triangulable, Surface, Path])["in"](Polygon);

    Polygon.polygonFrom = function(vertices) {
      var isArray;
      if ((vertices != null) && typeof vertices === 'object') {
        isArray = Object.prototype.toString.call(vertices).indexOf('Array') !== -1;
        if (!isArray) {
          return vertices;
        }
        return {
          vertices: vertices
        };
      } else {
        return {
          vertices: null
        };
      }
    };

    function Polygon(vertices) {
      vertices = this.polygonFrom(vertices).vertices;
      if (vertices == null) {
        this.noVertices();
      }
      if (vertices.length < 3) {
        this.notEnougthVertices(vertices);
      }
      this.vertices = vertices;
    }

    Polygon.prototype.center = function() {
      var vertex, x, y, _i, _len, _ref;
      x = y = 0;
      _ref = this.vertices;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        vertex = _ref[_i];
        x += vertex.x;
        y += vertex.y;
      }
      x = x / this.vertices.length;
      y = y / this.vertices.length;
      return new Point(x, y);
    };

    Polygon.prototype.translate = function(x, y) {
      var vertex, _i, _len, _ref, _ref1;
      _ref = Point.pointFrom(x, y), x = _ref.x, y = _ref.y;
      _ref1 = this.vertices;
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        vertex = _ref1[_i];
        vertex.x += x;
        vertex.y += y;
      }
      return this;
    };

    Polygon.prototype.rotate = function(rotation) {
      var center, i, vertex, _i, _len, _ref;
      center = this.center();
      _ref = this.vertices;
      for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
        vertex = _ref[i];
        this.vertices[i] = vertex.rotateAround(center, rotation);
      }
      return this;
    };

    Polygon.prototype.scale = function(scale) {
      var center, i, vertex, _i, _len, _ref;
      center = this.center();
      _ref = this.vertices;
      for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
        vertex = _ref[i];
        this.vertices[i] = center.add(vertex.subtract(center).scale(scale));
      }
      return this;
    };

    Polygon.prototype.rotateAroundCenter = Polygon.prototype.rotate;

    Polygon.prototype.scaleAroundCenter = Polygon.prototype.scale;

    Polygon.prototype.points = function() {
      var vertex;
      return ((function() {
        var _i, _len, _ref, _results;
        _ref = this.vertices;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          vertex = _ref[_i];
          _results.push(vertex.clone());
        }
        return _results;
      }).call(this)).concat(this.vertices[0].clone());
    };

    Polygon.prototype.closedGeometry = function() {
      return true;
    };

    Polygon.prototype.pointAtAngle = function(angle) {
      var center, distance, vec, _ref;
      center = this.center();
      distance = function(a, b) {
        return a.distance(center) - b.distance(center);
      };
      vec = center.add(Math.cos(angle) * 10000, Math.sin(angle) * 10000);
      return (_ref = this.intersections({
        points: function() {
          return [center, vec];
        }
      })) != null ? _ref.sort(distance)[0] : void 0;
    };

    Polygon.prototype.acreage = function() {
      var acreage, tri, _i, _len, _ref;
      acreage = 0;
      _ref = this.triangles();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        tri = _ref[_i];
        acreage += tri.acreage();
      }
      return acreage;
    };

    Polygon.prototype.contains = function(x, y) {
      var tri, _i, _len, _ref;
      _ref = this.triangles();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        tri = _ref[_i];
        if (tri.contains(x, y)) {
          return true;
        }
      }
      return false;
    };

    Polygon.prototype.randomPointInSurface = function(random) {
      var acreage, i, n, ratios, triangles, _i, _len;
      if (random == null) {
        random = new chancejs.Random(new chancejs.MathRandom);
      }
      acreage = this.acreage();
      triangles = this.triangles();
      ratios = triangles.map(function(t, i) {
        return t.acreage() / acreage;
      });
      for (i = _i = 0, _len = ratios.length; _i < _len; i = ++_i) {
        n = ratios[i];
        if (i > 0) {
          ratios[i] += ratios[i - 1];
        }
      }
      return random.inArray(triangles, ratios, true).randomPointInSurface(random);
    };

    Polygon.prototype.length = function() {
      var i, length, points, _i, _ref;
      length = 0;
      points = this.points();
      for (i = _i = 1, _ref = points.length - 1; 1 <= _ref ? _i <= _ref : _i >= _ref; i = 1 <= _ref ? ++_i : --_i) {
        length += points[i - 1].distance(points[i]);
      }
      return length;
    };

    Polygon.prototype.memoizationKey = function() {
      return this.vertices.map(function(pt) {
        return "" + pt.x + "," + pt.y;
      }).join(";");
    };

    Polygon.prototype.polygonFrom = Polygon.polygonFrom;

    Polygon.prototype.noVertices = function() {
      throw new Error('No vertices provided to Polygon');
    };

    Polygon.prototype.notEnougthVertices = function(vertices) {
      var length;
      length = vertices.length;
      throw new Error("Polygon must have at least 3 vertices, was " + length);
    };

    return Polygon;

  })();

  /* src/geomjs/linear_spline.coffee */;


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

  /* src/geomjs/cubic_bezier.coffee */;


  CubicBezier = (function() {

    include([Formattable('CubicBezier'), Sourcable('geomjs.CubicBezier', 'vertices', 'bias'), Geometry, Path, Intersections, Spline(3)])["in"](CubicBezier);

    function CubicBezier(vertices, bias) {
      if (bias == null) {
        bias = 20;
      }
      this.initSpline(vertices, bias);
    }

    CubicBezier.prototype.pointInSegment = function(t, seg) {
      var pt;
      pt = new Point();
      pt.x = (seg[0].x * this.b1(t)) + (seg[1].x * this.b2(t)) + (seg[2].x * this.b3(t)) + (seg[3].x * this.b4(t));
      pt.y = (seg[0].y * this.b1(t)) + (seg[1].y * this.b2(t)) + (seg[2].y * this.b3(t)) + (seg[3].y * this.b4(t));
      return pt;
    };

    CubicBezier.prototype.b1 = function(t) {
      return (1 - t) * (1 - t) * (1 - t);
    };

    CubicBezier.prototype.b2 = function(t) {
      return 3 * t * (1 - t) * (1 - t);
    };

    CubicBezier.prototype.b3 = function(t) {
      return 3 * t * t * (1 - t);
    };

    CubicBezier.prototype.b4 = function(t) {
      return t * t * t;
    };

    return CubicBezier;

  })();

  /* src/geomjs/quad_bezier.coffee */;


  QuadBezier = (function() {

    include([Formattable('QuadBezier'), Sourcable('geomjs.QuadBezier', 'vertices', 'bias'), Geometry, Path, Intersections, Spline(2)])["in"](QuadBezier);

    function QuadBezier(vertices, bias) {
      if (bias == null) {
        bias = 20;
      }
      this.initSpline(vertices, bias);
    }

    QuadBezier.prototype.pointInSegment = function(t, seg) {
      var pt;
      pt = new Point();
      pt.x = (seg[0].x * this.b1(t)) + (seg[1].x * this.b2(t)) + (seg[2].x * this.b3(t));
      pt.y = (seg[0].y * this.b1(t)) + (seg[1].y * this.b2(t)) + (seg[2].y * this.b3(t));
      return pt;
    };

    QuadBezier.prototype.b1 = function(t) {
      return (1 - t) * (1 - t);
    };

    QuadBezier.prototype.b2 = function(t) {
      return 2 * t * (1 - t);
    };

    QuadBezier.prototype.b3 = function(t) {
      return t * t;
    };

    return QuadBezier;

  })();

  /* src/geomjs/quint_bezier.coffee */;


  QuintBezier = (function() {

    include([Formattable('QuintBezier'), Sourcable('geomjs.QuintBezier', 'vertices', 'bias'), Geometry, Path, Intersections, Spline(4)])["in"](QuintBezier);

    function QuintBezier(vertices, bias) {
      if (bias == null) {
        bias = 20;
      }
      this.initSpline(vertices, bias);
    }

    QuintBezier.prototype.pointInSegment = function(t, seg) {
      var pt;
      pt = new Point();
      pt.x = (seg[0].x * this.b1(t)) + (seg[1].x * this.b2(t)) + (seg[2].x * this.b3(t)) + (seg[3].x * this.b4(t)) + (seg[4].x * this.b5(t));
      pt.y = (seg[0].y * this.b1(t)) + (seg[1].y * this.b2(t)) + (seg[2].y * this.b3(t)) + (seg[3].y * this.b4(t)) + (seg[4].y * this.b5(t));
      return pt;
    };

    QuintBezier.prototype.b1 = function(t) {
      return (1 - t) * (1 - t) * (1 - t) * (1 - t);
    };

    QuintBezier.prototype.b2 = function(t) {
      return 4 * t * (1 - t) * (1 - t) * (1 - t);
    };

    QuintBezier.prototype.b3 = function(t) {
      return 6 * t * t * (1 - t) * (1 - t);
    };

    QuintBezier.prototype.b4 = function(t) {
      return 4 * t * t * t * (1 - t);
    };

    QuintBezier.prototype.b5 = function(t) {
      return t * t * t * t;
    };

    return QuintBezier;

  })();

  /* src/geomjs/spiral.coffee */;


  Spiral = (function() {
    var PROPERTIES, memoizationKey;

    PROPERTIES = ['radius1', 'radius2', 'twirl', 'x', 'y', 'rotation', 'segments'];

    include([
      Equatable.apply(null, PROPERTIES), Formattable.apply(null, ['Spiral'].concat(PROPERTIES)), Parameterizable('spiralFrom', {
        radius1: 1,
        radius2: 1,
        twirl: 1,
        x: 0,
        y: 0,
        rotation: 0,
        segments: 36
      }), Sourcable.apply(null, ['geomjs.Spiral'].concat(PROPERTIES)), Cloneable, Memoizable, Geometry, Path, Intersections
    ])["in"](Spiral);

    function Spiral(r1, r2, twirl, x, y, rot, segments) {
      var _ref;
      _ref = this.spiralFrom(r1, r2, twirl, x, y, rot, segments), this.radius1 = _ref.radius1, this.radius2 = _ref.radius2, this.twirl = _ref.twirl, this.x = _ref.x, this.y = _ref.y, this.rotation = _ref.rotation, this.segments = _ref.segments;
    }

    Spiral.prototype.center = function() {
      return new Point(this.x, this.y);
    };

    Spiral.prototype.ellipsis = function() {
      if (this.memoized('ellipsis')) {
        return this.memoFor('ellipsis');
      }
      return this.memoize('ellipsis', new Ellipsis(this));
    };

    Spiral.prototype.translate = function(x, y) {
      var _ref;
      _ref = Point.pointFrom(x, y), x = _ref.x, y = _ref.y;
      this.x += x;
      this.y += y;
      return this;
    };

    Spiral.prototype.rotate = function(rotation) {
      this.rotation += rotation;
      return this;
    };

    Spiral.prototype.scale = function(scale) {
      this.radius1 *= scale;
      this.radius2 *= scale;
      return this;
    };

    Spiral.prototype.points = function() {
      var center, ellipsis, i, p, points, _i, _ref;
      if (this.memoized('points')) {
        return this.memoFor('points').concat();
      }
      points = [];
      center = this.center();
      ellipsis = this.ellipsis();
      for (i = _i = 0, _ref = this.segments; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
        p = i / this.segments;
        points.push(this.pathPointAt(p));
      }
      return this.memoize('points', points);
    };

    Spiral.prototype.pathPointAt = function(pos, posBasedOnLength) {
      var PI2, angle, center, ellipsis, pt, _ref;
      if (posBasedOnLength == null) {
        posBasedOnLength = true;
      }
      center = this.center();
      ellipsis = this.ellipsis();
      PI2 = Math.PI * 2;
      angle = this.rotation + pos * PI2 * this.twirl % PI2;
      pt = (_ref = ellipsis.pointAtAngle(angle)) != null ? _ref.subtract(center).scale(pos) : void 0;
      return center.add(pt);
    };

    Spiral.prototype.fill = function() {};

    Spiral.prototype.drawPath = function(context) {
      var p, points, start, _i, _len, _results;
      points = this.points();
      start = points.shift();
      context.beginPath();
      context.moveTo(start.x, start.y);
      _results = [];
      for (_i = 0, _len = points.length; _i < _len; _i++) {
        p = points[_i];
        _results.push(context.lineTo(p.x, p.y));
      }
      return _results;
    };

    memoizationKey = function() {
      return "" + this.radius1 + ";" + this.radius2 + ";" + this.twirl + ";" + this.x + ";" + this.y + ";" + this.rotation + ";" + this.segments;
    };

    return Spiral;

  })();

  /* src/geomjs/transformation_proxy.coffee */;


  TransformationProxy = (function() {

    TransformationProxy.defineProxy = function(key, type) {
      switch (type) {
        case 'PointList':
          return this.prototype[key] = function() {
            var points,
              _this = this;
            points = this.geometry[key].apply(this.geometry, arguments);
            if (this.matrix != null) {
              return points.map(function(pt) {
                return _this.matrix.transformPoint(pt);
              });
            } else {
              return points;
            }
          };
        case 'Point':
          return this.prototype[key] = function() {
            var point;
            point = this.geometry[key].apply(this.geometry, arguments);
            if (this.matrix != null) {
              return this.matrix.transformPoint(point);
            } else {
              return point;
            }
          };
        case 'Angle':
          return this.prototype[key] = function() {
            var angle, vec;
            angle = this.geometry[key].apply(this.geometry, arguments);
            if (this.matrix != null) {
              vec = new Point(Math.cos(angle), Math.sin(angle));
              return this.matrix.transformPoint(vec).angle();
            } else {
              return angle;
            }
          };
      }
    };

    function TransformationProxy(geometry, matrix) {
      this.geometry = geometry;
      this.matrix = matrix;
      this.proxiedMethods = this.detectProxyableMethods(this.geometry);
    }

    TransformationProxy.prototype.proxied = function() {
      var k, v, _ref, _results;
      _ref = this.proxiedMethods;
      _results = [];
      for (k in _ref) {
        v = _ref[k];
        _results.push(k);
      }
      return _results;
    };

    TransformationProxy.prototype.detectProxyableMethods = function(geometry) {
      var k, proxiedMethods, v, _ref;
      proxiedMethods = {};
      _ref = geometry.constructor.prototype;
      for (k in _ref) {
        v = _ref[k];
        if (v.proxyable) {
          proxiedMethods[k] = v.proxyable;
          TransformationProxy.defineProxy(k, v.proxyable);
        }
      }
      return proxiedMethods;
    };

    return TransformationProxy;

  })();

  this.geomjs.include = include;

  this.geomjs.Mixin = Mixin;

  this.geomjs.Equatable = Equatable;

  this.geomjs.Formattable = Formattable;

  this.geomjs.Cloneable = Cloneable;

  this.geomjs.Sourcable = Sourcable;

  this.geomjs.Memoizable = Memoizable;

  this.geomjs.Parameterizable = Parameterizable;

  this.geomjs.Geometry = Geometry;

  this.geomjs.Surface = Surface;

  this.geomjs.Path = Path;

  this.geomjs.Intersections = Intersections;

  this.geomjs.Triangulable = Triangulable;

  this.geomjs.Proxyable = Proxyable;

  this.geomjs.Spline = Spline;

  this.geomjs.Point = Point;

  this.geomjs.Matrix = Matrix;

  this.geomjs.Rectangle = Rectangle;

  this.geomjs.Triangle = Triangle;

  this.geomjs.Circle = Circle;

  this.geomjs.Ellipsis = Ellipsis;

  this.geomjs.Diamond = Diamond;

  this.geomjs.Polygon = Polygon;

  this.geomjs.LinearSpline = LinearSpline;

  this.geomjs.CubicBezier = CubicBezier;

  this.geomjs.QuadBezier = QuadBezier;

  this.geomjs.QuintBezier = QuintBezier;

  this.geomjs.Spiral = Spiral;

  this.geomjs.TransformationProxy = TransformationProxy;

}).call(this);
