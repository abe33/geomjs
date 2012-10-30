(function() {
  var Matrix, Point, Rectangle,
    __slice = [].slice;

  this.geomjs || (this.geomjs = {});

  /* src/geomjs/math.coffee */;


  Math.degToRad = function(n) {
    return n * Math.PI / 180;
  };

  Math.radToDeg = function(n) {
    return n * 180 / Math.PI;
  };

  /* src/geomjs/point.coffee */;


  /* src/geomjs/point.coffee<Point> line:18 */;


  Point = (function() {
    /* src/geomjs/point.coffee<Point.isPoint> line:30 */;

    Point.isPoint = function(pt) {
      return (pt != null) && (pt.x != null) && (pt.y != null);
    };

    Point.isFloat = function(n) {
      return !isNaN(parseFloat(n));
    };

    /* src/geomjs/point.coffee<Point.coordsFrom> line:73 */;


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

    /* src/geomjs/point.coffee<Point.polar> line:89 */;


    Point.polar = function(angle, length) {
      if (length == null) {
        length = 1;
      }
      return new Point(Math.sin(angle) * length, Math.cos(angle) * length);
    };

    /* src/geomjs/point.coffee<Point.interpolate> line:102 */;


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

    /* src/geomjs/point.coffee<Point.missingPosition> line:130 */;


    Point.missingPosition = function(pos) {
      throw new Error("Point.interpolate require a position but " + pos + " was given");
    };

    /* src/geomjs/point.coffee<Point.missingPoint> line:136 */;


    Point.missingPoint = function(args, pos) {
      throw new Error("Can't find the " + pos + " point in Point.interpolate arguments " + args);
    };

    /* src/geomjs/point.coffee<Point.notAPoint> line:143 */;


    Point.notAPoint = function(pt) {
      throw new Error("" + pt + " isn't a point-like object");
    };

    /* src/geomjs/point.coffee<Point::constructor> line:158 */;


    function Point(xOrPt, y) {
      var x, _ref, _ref1;
      _ref = this.coordsFrom(xOrPt, y), x = _ref[0], y = _ref[1];
      _ref1 = this.defaultToZero(x, y), this.x = _ref1[0], this.y = _ref1[1];
    }

    /* src/geomjs/point.coffee<Point::length> line:167 */;


    Point.prototype.length = function() {
      return Math.sqrt((this.x * this.x) + (this.y * this.y));
    };

    /* src/geomjs/point.coffee<Point::angle> line:174 */;


    Point.prototype.angle = function() {
      return Math.radToDeg(Math.atan2(this.y, this.x));
    };

    /* src/geomjs/point.coffee<Point::equals> line:183 */;


    Point.prototype.equals = function(o) {
      return (o != null) && o.x === this.x && o.y === this.y;
    };

    /* src/geomjs/point.coffee<Point::angleWith> line:196 */;


    Point.prototype.angleWith = function(xOrPt, y) {
      var d, x, _ref;
      if (!(xOrPt != null) && !(y != null)) {
        this.noPoint('dot');
      }
      _ref = this.coordsFrom(xOrPt, y, true), x = _ref[0], y = _ref[1];
      d = this.normalize().dot(new Point(x, y).normalize());
      return Math.radToDeg(Math.acos(Math.abs(d)) * (d < 0 ? -1 : 1));
    };

    /* src/geomjs/point.coffee<Point::normalize> line:213 */;


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

    /* src/geomjs/point.coffee<Point::add> line:228 */;


    Point.prototype.add = function(xOrPt, y) {
      var x, _ref, _ref1;
      _ref = this.coordsFrom(xOrPt, y), x = _ref[0], y = _ref[1];
      _ref1 = this.defaultToZero(x, y), x = _ref1[0], y = _ref1[1];
      return new Point(this.x + x, this.y + y);
    };

    /* src/geomjs/point.coffee<Point::subtract> line:243 */;


    Point.prototype.subtract = function(xOrPt, y) {
      var x, _ref, _ref1;
      _ref = this.coordsFrom(xOrPt, y), x = _ref[0], y = _ref[1];
      _ref1 = this.defaultToZero(x, y), x = _ref1[0], y = _ref1[1];
      return new Point(this.x - x, this.y - y);
    };

    /* src/geomjs/point.coffee<Point::dot> line:254 */;


    Point.prototype.dot = function(xOrPt, y) {
      var x, _ref;
      if (!(xOrPt != null) && !(y != null)) {
        this.noPoint('dot');
      }
      _ref = this.coordsFrom(xOrPt, y, true), x = _ref[0], y = _ref[1];
      return this.x * x + this.y * y;
    };

    /* src/geomjs/point.coffee<Point::distance> line:265 */;


    Point.prototype.distance = function(xOrPt, y) {
      var x, _ref;
      if (!(xOrPt != null) && !(y != null)) {
        this.noPoint('dot');
      }
      _ref = this.coordsFrom(xOrPt, y, true), x = _ref[0], y = _ref[1];
      return this.subtract(x, y).length();
    };

    /* src/geomjs/point.coffee<Point::paste> line:280 */;


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

    /* src/geomjs/point.coffee<Point::scale> line:293 */;


    Point.prototype.scale = function(n) {
      if (!this.isFloat(n)) {
        this.invalidScale(n);
      }
      return new Point(this.x * n, this.y * n);
    };

    /* src/geomjs/point.coffee<Point::rotate> line:305 */;


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

    /* src/geomjs/point.coffee<Point::rotateAround> line:322 */;


    Point.prototype.rotateAround = function(xOrPt, y, a) {
      var x, _ref;
      if (this.isPoint(xOrPt)) {
        a = y;
      }
      _ref = this.coordsFrom(xOrPt, y, true), x = _ref[0], y = _ref[1];
      return this.subtract(x, y).rotate(a).add(x, y);
    };

    /* src/geomjs/point.coffee<Point::isPoint> line:331 */;


    Point.prototype.isPoint = function(pt) {
      return Point.isPoint(pt);
    };

    /* src/geomjs/point.coffee<Point::isFloat> line:336 */;


    Point.prototype.isFloat = function(n) {
      return Point.isFloat(n);
    };

    /* src/geomjs/point.coffee<Point::coordsFrom> line:341 */;


    Point.prototype.coordsFrom = function(xOrPt, y, strict) {
      return Point.coordsFrom(xOrPt, y, strict);
    };

    /* src/geomjs/point.coffee<Point::defaultToZero> line:347 */;


    Point.prototype.defaultToZero = function(x, y) {
      x = isNaN(x) ? 0 : x;
      y = isNaN(y) ? 0 : y;
      return [x, y];
    };

    /* src/geomjs/point.coffee<Point::clone> line:355 */;


    Point.prototype.clone = function() {
      return new Point(this);
    };

    /* src/geomjs/point.coffee<Point::toString> line:360 */;


    Point.prototype.toString = function() {
      return "[object Point(" + this.x + "," + this.y + ")]";
    };

    /* src/geomjs/point.coffee<Point::noPoint> line:368 */;


    Point.prototype.noPoint = function(method) {
      throw new Error("" + method + " was called without arguments");
    };

    /* src/geomjs/point.coffee<Point::invalidLength> line:374 */;


    Point.prototype.invalidLength = function(l) {
      throw new Error("Invalid length " + l + " provided");
    };

    /* src/geomjs/point.coffee<Point::invalidScale> line:380 */;


    Point.prototype.invalidScale = function(s) {
      throw new Error("Invalid scale " + s + " provided");
    };

    /* src/geomjs/point.coffee<Point::invalidRotation> line:387 */;


    Point.prototype.invalidRotation = function(a) {
      throw new Error("Invalid rotation " + a + " provided");
    };

    return Point;

  })();

  /* src/geomjs/matrix.coffee */;


  /* src/geomjs/matrix.coffee<Matrix> line:20 */;


  Matrix = (function() {
    var PROPERTIES;

    PROPERTIES = ['a', 'b', 'c', 'd', 'tx', 'ty'];

    /* src/geomjs/matrix.coffee<Matrix.isMatrix> line:46 */;


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

    /* src/geomjs/matrix.coffee<Matrix.isFloat> line:56 */;


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

    /* src/geomjs/matrix.coffee<Matrix::constructor> line:75 */;


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

    /* src/geomjs/matrix.coffee<Matrix::equals> line:91 */;


    Matrix.prototype.equals = function(o) {
      var k, _i, _len;
      if (o == null) {
        return false;
      }
      for (_i = 0, _len = PROPERTIES.length; _i < _len; _i++) {
        k = PROPERTIES[_i];
        if (o[k] !== this[k]) {
          return false;
        }
      }
      return true;
    };

    /* src/geomjs/matrix.coffee<Matrix::transformPoint> line:107 */;


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

    /* src/geomjs/matrix.coffee<Matrix::translate> line:119 */;


    Matrix.prototype.translate = function(xOrPt, y) {
      var x, _ref;
      _ref = this.coordsFrom(xOrPt, y, 0), x = _ref[0], y = _ref[1];
      this.tx += x;
      this.ty += y;
      return this;
    };

    /* src/geomjs/matrix.coffee<Matrix::scale> line:129 */;


    Matrix.prototype.scale = function(xOrPt, y) {
      var x, _ref;
      _ref = this.coordsFrom(xOrPt, y, 1), x = _ref[0], y = _ref[1];
      this.a *= x;
      this.d *= y;
      this.tx *= x;
      this.ty *= y;
      return this;
    };

    /* src/geomjs/matrix.coffee<Matrix::rotate> line:141 */;


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

    /* src/geomjs/matrix.coffee<Matrix::skew> line:157 */;


    Matrix.prototype.skew = function(xOrPt, y) {
      var x, _ref, _ref1;
      _ref = this.coordsFrom(xOrPt, y, 0), x = _ref[0], y = _ref[1];
      _ref1 = [Math.degToRad(x), Math.degToRad(y)], x = _ref1[0], y = _ref1[1];
      return this.append(Math.cos(y), Math.sin(y), -Math.sin(x), Math.cos(x));
    };

    /* src/geomjs/matrix.coffee<Matrix::append> line:168 */;


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

    /* src/geomjs/matrix.coffee<Matrix::prepend> line:183 */;


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

    /* src/geomjs/matrix.coffee<Matrix::identity> line:202 */;


    Matrix.prototype.identity = function() {
      var _ref;
      _ref = [1, 0, 0, 1, 0, 0], this.a = _ref[0], this.b = _ref[1], this.c = _ref[2], this.d = _ref[3], this.tx = _ref[4], this.ty = _ref[5];
      return this;
    };

    /* src/geomjs/matrix.coffee<Matrix::inverse> line:207 */;


    Matrix.prototype.inverse = function() {
      var n, _ref;
      n = this.a * this.d - this.b * this.c;
      _ref = [this.d / n, -this.b / n, -this.c / n, this.a / n, (this.c * this.ty - this.d * this.tx) / n, -(this.a * this.ty - this.b * this.tx) / n], this.a = _ref[0], this.b = _ref[1], this.c = _ref[2], this.d = _ref[3], this.tx = _ref[4], this.ty = _ref[5];
      return this;
    };

    /* src/geomjs/matrix.coffee<Matrix::asFloat> line:222 */;


    Matrix.prototype.asFloat = function() {
      var floats, i, n, _i, _len;
      floats = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      for (i = _i = 0, _len = floats.length; _i < _len; i = ++_i) {
        n = floats[i];
        floats[i] = parseFloat(n);
      }
      return floats;
    };

    /* src/geomjs/matrix.coffee<Matrix::matrixFrom> line:233 */;


    Matrix.prototype.matrixFrom = function(a, b, c, d, tx, ty) {
      var _ref;
      if (this.isMatrix(a)) {
        _ref = a, a = _ref.a, b = _ref.b, c = _ref.c, d = _ref.d, tx = _ref.tx, ty = _ref.ty;
      } else if (!this.isFloat(a, b, c, d, tx, ty)) {
        this.invalidMatrixArguments([a, b, c, d, tx, ty]);
      }
      return this.asFloat(a, b, c, d, tx, ty);
    };

    /* src/geomjs/matrix.coffee<Matrix::coordsFrom> line:245 */;


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

    /* src/geomjs/matrix.coffee<Matrix::isMatrix> line:254 */;


    Matrix.prototype.isMatrix = function(m) {
      return Matrix.isMatrix(m);
    };

    /* src/geomjs/matrix.coffee<Matrix::isFloat> line:259 */;


    Matrix.prototype.isFloat = function() {
      var floats;
      floats = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return Matrix.isFloat.apply(Matrix, floats);
    };

    /* src/geomjs/matrix.coffee<Matrix::clone> line:264 */;


    Matrix.prototype.clone = function() {
      return new Matrix(this);
    };

    /* src/geomjs/matrix.coffee<Matrix::toString> line:269 */;


    Matrix.prototype.toString = function() {
      return "[object Matrix(" + this.a + "," + this.b + "," + this.c + "," + this.d + "," + this.tx + "," + this.ty + ")]";
    };

    /* src/geomjs/matrix.coffee<Matrix::invalidMatrixArguments> line:276 */;


    Matrix.prototype.invalidMatrixArguments = function(args) {
      throw new Error("Invalid arguments " + args + " for a Matrix");
    };

    return Matrix;

  })();

  /* src/geomjs/rectangle.coffee */;


  /* src/geomjs/rectangle.coffee<Rectangle> line:2 */;


  Rectangle = (function() {
    /* src/geomjs/rectangle.coffee<Rectangle::constructor> line:3 */;

    function Rectangle(x, y, width, height, rotation) {
      this.x = x != null ? x : 0;
      this.y = y != null ? y : 0;
      this.width = width != null ? width : 0;
      this.height = height != null ? height : 0;
      this.rotation = rotation != null ? rotation : 0;
    }

    /* src/geomjs/rectangle.coffee<Rectangle::topLeft> line:5 */;


    Rectangle.prototype.topLeft = function() {
      return new Point(this.x, this.y);
    };

    /* src/geomjs/rectangle.coffee<Rectangle::topRight> line:6 */;


    Rectangle.prototype.topRight = function() {
      return this.topLeft().add(this.topEdge());
    };

    /* src/geomjs/rectangle.coffee<Rectangle::bottomLeft> line:7 */;


    Rectangle.prototype.bottomLeft = function() {
      return this.topLeft().add(this.leftEdge());
    };

    /* src/geomjs/rectangle.coffee<Rectangle::bottomRight> line:8 */;


    Rectangle.prototype.bottomRight = function() {
      return this.topLeft().add(this.topEdge()).add(this.leftEdge());
    };

    /* src/geomjs/rectangle.coffee<Rectangle::center> line:10 */;


    Rectangle.prototype.center = function() {
      return this.topLeft().add(this.topEdge().scale(0.5)).add(this.leftEdge().scale(0.5));
    };

    /* src/geomjs/rectangle.coffee<Rectangle::topEdgeCenter> line:11 */;


    Rectangle.prototype.topEdgeCenter = function() {
      return this.topLeft().add(this.topEdge().scale(0.5));
    };

    /* src/geomjs/rectangle.coffee<Rectangle::bottomEdgeCenter> line:12 */;


    Rectangle.prototype.bottomEdgeCenter = function() {
      return this.bottomLeft().add(this.topEdge().scale(0.5));
    };

    /* src/geomjs/rectangle.coffee<Rectangle::leftEdgeCenter> line:13 */;


    Rectangle.prototype.leftEdgeCenter = function() {
      return this.topLeft().add(this.leftEdge().scale(0.5));
    };

    /* src/geomjs/rectangle.coffee<Rectangle::rightEdgeCenter> line:14 */;


    Rectangle.prototype.rightEdgeCenter = function() {
      return this.topRight().add(this.leftEdge().scale(0.5));
    };

    /* src/geomjs/rectangle.coffee<Rectangle::topEdge> line:16 */;


    Rectangle.prototype.topEdge = function() {
      return new Point(this.width * Math.cos(Math.degToRad(this.rotation)), this.width * Math.sin(Math.degToRad(this.rotation)));
    };

    /* src/geomjs/rectangle.coffee<Rectangle::leftEdge> line:18 */;


    Rectangle.prototype.leftEdge = function() {
      return new Point(this.height * Math.cos(Math.degToRad(this.rotation) + Math.PI / 2), this.height * Math.sin(Math.degToRad(this.rotation) + Math.PI / 2));
    };

    /* src/geomjs/rectangle.coffee<Rectangle::bottomEdge> line:22 */;


    Rectangle.prototype.bottomEdge = function() {
      return this.topEdge();
    };

    /* src/geomjs/rectangle.coffee<Rectangle::rightEdge> line:23 */;


    Rectangle.prototype.rightEdge = function() {
      return this.leftEdge();
    };

    /* src/geomjs/rectangle.coffee<Rectangle::top> line:25 */;


    Rectangle.prototype.top = function() {
      return Math.min(this.y, this.topRight().y, this.bottomRight().y, this.bottomLeft().y);
    };

    /* src/geomjs/rectangle.coffee<Rectangle::bottom> line:26 */;


    Rectangle.prototype.bottom = function() {
      return Math.max(this.y, this.topRight().y, this.bottomRight().y, this.bottomLeft().y);
    };

    /* src/geomjs/rectangle.coffee<Rectangle::left> line:27 */;


    Rectangle.prototype.left = function() {
      return Math.min(this.x, this.topRight().x, this.bottomRight().x, this.bottomLeft().x);
    };

    /* src/geomjs/rectangle.coffee<Rectangle::right> line:28 */;


    Rectangle.prototype.right = function() {
      return Math.max(this.x, this.topRight().x, this.bottomRight().x, this.bottomLeft().x);
    };

    /* src/geomjs/rectangle.coffee<Rectangle::acreage> line:31 */;


    Rectangle.prototype.acreage = function() {
      return this.width * this.height;
    };

    /* src/geomjs/rectangle.coffee<Rectangle::length> line:34 */;


    Rectangle.prototype.length = function() {
      return this.width * 2 + this.height * 2;
    };

    /* src/geomjs/rectangle.coffee<Rectangle::stroke> line:37 */;


    Rectangle.prototype.stroke = function(context, color) {
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

    /* src/geomjs/rectangle.coffee<Rectangle::fill> line:44 */;


    Rectangle.prototype.fill = function(context, color) {
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

    /* src/geomjs/rectangle.coffee<Rectangle::drawPath> line:51 */;


    Rectangle.prototype.drawPath = function(context) {
      context.beginPath();
      context.moveTo(this.x, this.y);
      context.lineTo(this.topRight().x, this.topRight().y);
      context.lineTo(this.bottomRight().x, this.bottomRight().y);
      context.lineTo(this.bottomLeft().x, this.bottomLeft().y);
      context.lineTo(this.x, this.y);
      return context.closePath();
    };

    return Rectangle;

  })();

  this.geomjs.Point = Point;

  this.geomjs.Matrix = Matrix;

  this.geomjs.Rectangle = Rectangle;

}).call(this);
