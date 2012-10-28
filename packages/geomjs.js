(function() {
  var Matrix, Point,
    __slice = [].slice;

  this.geomjs || (this.geomjs = {});

  /* src/geomjs/matrix.coffee */;


  /* src/geomjs/matrix.coffee<Matrix> line:1 */;


  Matrix = (function() {

    Matrix.DEG_TO_RAD = Math.PI / 180;

    /* src/geomjs/matrix.coffee<Matrix.isMatrix> line:3 */;


    Matrix.isMatrix = function(m) {
      var k, _i, _len, _ref;
      if (m == null) {
        return false;
      }
      _ref = ['a', 'b', 'c', 'd', 'tx', 'ty'];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        k = _ref[_i];
        if (!(m[k] != null)) {
          return false;
        }
      }
      return true;
    };

    /* src/geomjs/matrix.coffee<Matrix::constructor> line:8 */;


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

    /* src/geomjs/matrix.coffee<Matrix::translate> line:11 */;


    Matrix.prototype.translate = function(x, y) {
      if (x == null) {
        x = 0;
      }
      if (y == null) {
        y = 0;
      }
      this.tx += x;
      this.ty += y;
      return this;
    };

    /* src/geomjs/matrix.coffee<Matrix::scale> line:16 */;


    Matrix.prototype.scale = function(x, y) {
      if (x == null) {
        x = 1;
      }
      if (y == null) {
        y = 1;
      }
      this.a *= x;
      this.d *= y;
      this.tx *= x;
      this.ty *= y;
      return this;
    };

    /* src/geomjs/matrix.coffee<Matrix::rotate> line:23 */;


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

    /* src/geomjs/matrix.coffee<Matrix::skew> line:36 */;


    Matrix.prototype.skew = function(x, y) {
      var _ref;
      if (x == null) {
        x = 0;
      }
      if (y == null) {
        y = 0;
      }
      _ref = [x * Matrix.DEG_TO_RAD, y * Matrix.DEG_TO_RAD], x = _ref[0], y = _ref[1];
      return this.append(Math.cos(y), Math.sin(y), -Math.sin(x), Math.cos(x));
    };

    /* src/geomjs/matrix.coffee<Matrix::append> line:43 */;


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

    /* src/geomjs/matrix.coffee<Matrix::prepend> line:55 */;


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

    /* src/geomjs/matrix.coffee<Matrix::identity> line:71 */;


    Matrix.prototype.identity = function() {
      var _ref;
      _ref = [1, 0, 0, 1, 0, 0], this.a = _ref[0], this.b = _ref[1], this.c = _ref[2], this.d = _ref[3], this.tx = _ref[4], this.ty = _ref[5];
      return this;
    };

    /* src/geomjs/matrix.coffee<Matrix::inverse> line:73 */;


    Matrix.prototype.inverse = function() {
      var n, _ref;
      n = this.a * this.d - this.b * this.c;
      _ref = [this.d / n, -this.b / n, -this.c / n, this.a / n, (this.c * this.ty - this.d * this.tx) / n, -(this.a * this.ty - this.b * this.tx) / n], this.a = _ref[0], this.b = _ref[1], this.c = _ref[2], this.d = _ref[3], this.tx = _ref[4], this.ty = _ref[5];
      return this;
    };

    /* src/geomjs/matrix.coffee<Matrix::asFloat> line:85 */;


    Matrix.prototype.asFloat = function() {
      var floats, i, n, _i, _len;
      floats = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      for (i = _i = 0, _len = floats.length; _i < _len; i = ++_i) {
        n = floats[i];
        floats[i] = parseFloat(n);
      }
      return floats;
    };

    /* src/geomjs/matrix.coffee<Matrix::matrixFrom> line:89 */;


    Matrix.prototype.matrixFrom = function(a, b, c, d, tx, ty) {
      var _ref;
      if (this.isMatrix(a)) {
        _ref = a, a = _ref.a, b = _ref.b, c = _ref.c, d = _ref.d, tx = _ref.tx, ty = _ref.ty;
      } else if (!this.isFloat(a, b, c, d, tx, ty)) {
        this.invalidMatrixArguments([a, b, c, d, tx, ty]);
      }
      return this.asFloat(a, b, c, d, tx, ty);
    };

    /* src/geomjs/matrix.coffee<Matrix::isMatrix> line:97 */;


    Matrix.prototype.isMatrix = function(m) {
      return Matrix.isMatrix(m);
    };

    /* src/geomjs/matrix.coffee<Matrix::isFloat> line:98 */;


    Matrix.prototype.isFloat = function() {
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

    /* src/geomjs/matrix.coffee<Matrix::invalidMatrixArguments> line:102 */;


    Matrix.prototype.invalidMatrixArguments = function(args) {
      throw new Error("Invalid arguments " + args + " for a Matrix");
    };

    /* src/geomjs/matrix.coffee<Matrix::clone> line:105 */;


    Matrix.prototype.clone = function() {
      return new Matrix(this);
    };

    /* src/geomjs/matrix.coffee<Matrix::toString> line:106 */;


    Matrix.prototype.toString = function() {
      return "[object Matrix(" + this.a + "," + this.b + "," + this.c + "," + this.d + "," + this.tx + "," + this.ty + ")]";
    };

    return Matrix;

  })();

  /* src/geomjs/point.coffee */;


  /* src/geomjs/point.coffee<Point> line:1 */;


  Point = (function() {
    /* src/geomjs/point.coffee<Point.isPoint> line:2 */;

    Point.isPoint = function(pt) {
      return (pt != null) && (pt.x != null) && (pt.y != null);
    };

    Point.isFloat = function(n) {
      return !isNaN(parseFloat(n));
    };

    /* src/geomjs/point.coffee<Point.polar> line:5 */;


    Point.polar = function(angle, length) {
      if (length == null) {
        length = 1;
      }
      return new Point(Math.sin(angle) * length, Math.cos(angle) * length);
    };

    Point.interpolate = function() {
      var args, dif, i, pos, pt1, pt2, v, _i, _len;
      args = [];
      for (i = _i = 0, _len = arguments.length; _i < _len; i = ++_i) {
        v = arguments[i];
        args[i] = v;
      }
      if (this.isPoint(args[0])) {
        pt1 = args.shift();
      } else if (this.isFloat(args[0]) && this.isFloat(args[1])) {
        pt1 = new Point(args[0], args[1]);
        args.splice(0, 2);
      } else {
        this.pointNotFound(args, 'first');
      }
      if (this.isPoint(args[0])) {
        pt2 = args.shift();
      } else if (this.isFloat(args[0]) && this.isFloat(args[1])) {
        pt2 = new Point(args[0], args[1]);
        args.splice(0, 2);
      } else {
        this.pointNotFound(args, 'second');
      }
      pos = parseFloat(args.shift());
      if (isNaN(pos)) {
        this.missingPosition(pos);
      }
      dif = pt2.subtract(pt1);
      return new Point(pt1.x + dif.x * pos, pt1.y + dif.y * pos);
    };

    /* src/geomjs/point.coffee<Point.missingPosition> line:30 */;


    Point.missingPosition = function(pos) {
      throw new Error("Point.interpolate require a position but " + pos + " was given");
    };

    /* src/geomjs/point.coffee<Point.pointNotFound> line:32 */;


    Point.pointNotFound = function(args, pos) {
      throw new Error("Can't find the " + pos + " point in Point.interpolate arguments " + args);
    };

    /* src/geomjs/point.coffee<Point::constructor> line:35 */;


    function Point(x, y) {
      var _ref, _ref1;
      _ref = this.coordsFrom(x, y), x = _ref[0], y = _ref[1];
      _ref1 = this.defaultToZero(x, y), this.x = _ref1[0], this.y = _ref1[1];
    }

    /* src/geomjs/point.coffee<Point::length> line:39 */;


    Point.prototype.length = function() {
      return Math.sqrt((this.x * this.x) + (this.y * this.y));
    };

    /* src/geomjs/point.coffee<Point::normalize> line:41 */;


    Point.prototype.normalize = function(length) {
      var l;
      if (length == null) {
        length = 1;
      }
      if (isNaN(parseFloat(length))) {
        this.invalidLength(length);
      }
      l = this.length();
      return new Point(this.x / l * length, this.y / l * length);
    };

    /* src/geomjs/point.coffee<Point::add> line:46 */;


    Point.prototype.add = function(x, y) {
      var _ref, _ref1;
      _ref = this.coordsFrom(x, y), x = _ref[0], y = _ref[1];
      _ref1 = this.defaultToZero(x, y), x = _ref1[0], y = _ref1[1];
      return new Point(this.x + x, this.y + y);
    };

    /* src/geomjs/point.coffee<Point::subtract> line:51 */;


    Point.prototype.subtract = function(x, y) {
      var _ref, _ref1;
      _ref = this.coordsFrom(x, y), x = _ref[0], y = _ref[1];
      _ref1 = this.defaultToZero(x, y), x = _ref1[0], y = _ref1[1];
      return new Point(this.x - x, this.y - y);
    };

    /* src/geomjs/point.coffee<Point::dot> line:56 */;


    Point.prototype.dot = function(x, y) {
      var _ref;
      if (!(x != null) && !(y != null)) {
        this.noPoint('dot');
      }
      _ref = this.coordsFrom(x, y, true), x = _ref[0], y = _ref[1];
      return this.x * x + this.y * y;
    };

    /* src/geomjs/point.coffee<Point::distance> line:61 */;


    Point.prototype.distance = function(x, y) {
      var _ref;
      if (!(x != null) && !(y != null)) {
        this.noPoint('dot');
      }
      _ref = this.coordsFrom(x, y, true), x = _ref[0], y = _ref[1];
      return this.subtract(x, y).length();
    };

    /* src/geomjs/point.coffee<Point::paste> line:66 */;


    Point.prototype.paste = function(x, y) {
      var _ref;
      _ref = this.coordsFrom(x, y), x = _ref[0], y = _ref[1];
      if (typeof x === 'number') {
        this.x = x;
      }
      if (typeof y === 'number') {
        this.y = y;
      }
      return this;
    };

    /* src/geomjs/point.coffee<Point::scale> line:72 */;


    Point.prototype.scale = function(n) {
      if (!this.isFloat(n)) {
        this.invalidScale(n);
      }
      return new Point(this.x * n, this.y * n);
    };

    /* src/geomjs/point.coffee<Point::coordsFrom> line:76 */;


    Point.prototype.coordsFrom = function(x, y, strict) {
      var _ref;
      if (strict == null) {
        strict = false;
      }
      if (typeof x === 'object') {
        if (strict && !this.isPoint(x)) {
          this.notAPoint(x);
        }
        if (x != null) {
          _ref = x, x = _ref.x, y = _ref.y;
        }
      }
      if (typeof x === 'string') {
        x = parseFloat(x);
      }
      if (typeof y === 'string') {
        y = parseFloat(y);
      }
      return [x, y];
    };

    /* src/geomjs/point.coffee<Point::defaultToZero> line:86 */;


    Point.prototype.defaultToZero = function(x, y) {
      x = isNaN(x) ? 0 : x;
      y = isNaN(y) ? 0 : y;
      return [x, y];
    };

    /* src/geomjs/point.coffee<Point::isPoint> line:91 */;


    Point.prototype.isPoint = function(pt) {
      return Point.isPoint(pt);
    };

    /* src/geomjs/point.coffee<Point::isFloat> line:92 */;


    Point.prototype.isFloat = function(n) {
      return Point.isFloat(n);
    };

    /* src/geomjs/point.coffee<Point::notAPoint> line:94 */;


    Point.prototype.notAPoint = function(pt) {
      throw new Error("" + pt + " isn't a point-like object");
    };

    /* src/geomjs/point.coffee<Point::noPoint> line:96 */;


    Point.prototype.noPoint = function(method) {
      throw new Error("" + method + " was called without arguments");
    };

    /* src/geomjs/point.coffee<Point::invalidLength> line:98 */;


    Point.prototype.invalidLength = function(l) {
      throw new Error("Invalid length " + l + " provided");
    };

    /* src/geomjs/point.coffee<Point::invalidScale> line:100 */;


    Point.prototype.invalidScale = function(s) {
      throw new Error("Invalid scale " + s + " provided");
    };

    /* src/geomjs/point.coffee<Point::clone> line:104 */;


    Point.prototype.clone = function() {
      return new Point(this);
    };

    /* src/geomjs/point.coffee<Point::toString> line:105 */;


    Point.prototype.toString = function() {
      return "[object Point(" + this.x + "," + this.y + ")]";
    };

    return Point;

  })();

  this.geomjs.Matrix = Matrix;

  this.geomjs.Point = Point;

}).call(this);
