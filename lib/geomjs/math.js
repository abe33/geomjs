// Generated by CoffeeScript 1.4.0
(function() {
  var __slice = [].slice;

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

}).call(this);
