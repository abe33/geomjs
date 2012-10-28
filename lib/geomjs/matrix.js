// Generated by CoffeeScript 1.4.0
(function() {
  var Matrix,
    __slice = [].slice;

  Matrix = (function() {

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
      if (this.isMatrix(a)) {
        this.a = a.a, this.b = a.b, this.c = a.c, this.d = a.d, this.tx = a.tx, this.ty = a.ty;
      } else if (this.isFloat(a, b, c, d, tx, ty)) {
        _ref = this.asFloat(a, b, c, d, tx, ty), this.a = _ref[0], this.b = _ref[1], this.c = _ref[2], this.d = _ref[3], this.tx = _ref[4], this.ty = _ref[5];
      } else {
        this.invalidMatrixArguments([a, b, c, d, tx, ty]);
      }
    }

    Matrix.prototype.inverse = function() {
      var n;
      n = this.a * this.d - this.b * this.c;
      return new Matrix(this.d / n, -this.b / n, -this.c / n, this.a / n, (this.c * this.ty - this.d * this.tx) / n, -(this.a * this.ty - this.b * this.tx) / n);
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

    Matrix.prototype.isMatrix = function(m) {
      return Matrix.isMatrix(m);
    };

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

    Matrix.prototype.invalidMatrixArguments = function(args) {
      throw new Error("Invalid arguments " + args + " for a Matrix");
    };

    Matrix.prototype.clone = function() {
      return new Matrix(this);
    };

    Matrix.prototype.toString = function() {
      return "[object Matrix(" + this.a + "," + this.b + "," + this.c + "," + this.d + "," + this.tx + "," + ty + ")]";
    };

    return Matrix;

  })();

  module.exports = Matrix;

}).call(this);