(function() {
  var Tester;

  Tester = (function() {
    var colorPalette;

    colorPalette = {
      shapeStroke: '#ff0000',
      shapeFill: 'rgba(255,0,0,0.2)',
      bounds: 'rgba(133, 153, 0, 0.3)',
      intersections: '#268bd2',
      intersections2: 'white',
      text: '#93a1a1',
      mobile: '#b58900'
    };

    function Tester(geometry) {
      this.geometry = geometry;
      this.pathPosition = 0;
      this.random = new chancejs.Random(new chancejs.MathRandom);
    }

    Tester.prototype.animate = function(t) {
      this.pathPosition += t;
      if (this.pathPosition > 10000) {
        return this.pathPosition -= 10000;
      }
    };

    Tester.prototype.renderShape = function(context) {
      this.geometry.fill(context, colorPalette.shapeFill);
      return this.geometry.stroke(context, colorPalette.shapeStroke);
    };

    Tester.prototype.renderPath = function(context) {
      var pt, tan, tr;
      pt = this.geometry.pathPointAt(this.pathPosition / 10000);
      tan = this.geometry.pathOrientationAt(this.pathPosition / 10000);
      tr = new geomjs.Rectangle(pt.x, pt.y, 6, 6, tan);
      return tr.stroke(context, colorPalette.mobile);
    };

    Tester.prototype.renderSurface = function(context) {
      var i, pt, _i, _results;
      context.fillStyle = colorPalette.shapeStroke;
      _results = [];
      for (i = _i = 0; _i <= 100; i = ++_i) {
        pt = this.geometry.randomPointInSurface(this.random);
        _results.push(context.fillRect(pt.x, pt.y, 1, 1));
      }
      return _results;
    };

    Tester.prototype.renderBounds = function(context) {
      var r;
      context.strokeStyle = colorPalette.bounds;
      r = this.geometry.boundingBox();
      return context.strokeRect(r.x, r.y, r.width, r.height);
    };

    Tester.prototype.renderClosedGeometry = function(context) {
      var c, pt1, pt2;
      c = this.geometry.center();
      pt1 = this.geometry.pointAtAngle(0);
      pt2 = this.geometry.pointAtAngle(-90);
      context.fillStyle = colorPalette.intersections;
      context.strokeStyle = colorPalette.intersections;
      context.fillRect(pt1.x - 2, pt1.y - 2, 4, 4);
      context.fillRect(pt2.x - 2, pt2.y - 2, 4, 4);
      context.beginPath();
      context.moveTo(pt1.x, pt1.y);
      context.lineTo(c.x, c.y);
      context.lineTo(pt2.x, pt2.y);
      return context.stroke();
    };

    Tester.prototype.render = function(context) {
      if ((this.geometry.stroke != null) && (this.geometry.fill != null)) {
        this.renderShape(context);
      }
      if (this.geometry.bounds != null) {
        this.renderBounds(context);
      }
      if ((this.geometry.pathPointAt != null) && (this.geometry.pathOrientationAt != null)) {
        this.renderPath(context);
      }
      if (this.geometry.randomPointInSurface != null) {
        this.renderSurface(context);
      }
      if ((this.geometry.center != null) && (this.geometry.pointAtAngle != null)) {
        return this.renderClosedGeometry(context);
      }
    };

    return Tester;

  })();

  $(document).ready(function() {
    var animate, animated, canvas, context, geometries, render, requestAnimationFrame, stats, t, testers;
    stats = new Stats;
    stats.setMode(0);
    $('div').prepend(stats.domElement);
    requestAnimationFrame = window.mozRequestAnimationFrame || window.webkitRequestAnimationFrame || window.msRequestAnimationFrame || window.oRequestAnimationFrame || window.requestAnimationFrame || function(f) {
      return setTimeout(f, 1000 / 60);
    };
    canvas = $('canvas');
    context = canvas[0].getContext('2d');
    animated = false;
    geometries = [new geomjs.Rectangle(250, 40, 180, 100, 16), new geomjs.Triangle(new geomjs.Point(100, 80), new geomjs.Point(320, 120), new geomjs.Point(140, 200)), new geomjs.Circle(60, 80, 160), new geomjs.Ellipsis(120, 60, 470, 180, 10), new geomjs.Diamond(50, 100, 60, 40, 420, 250)];
    testers = geometries.map(function(g) {
      return new Tester(g);
    });
    t = new Date().valueOf();
    render = function() {
      var a, g1, g2, intersection, intersections, tested, _i, _j, _k, _len, _len1, _len2, _results;
      context.fillStyle = '#042029';
      context.fillRect(0, 0, canvas.width(), canvas.height());
      testers.forEach(function(t) {
        return t.render(context);
      });
      intersections = [];
      tested = {};
      for (_i = 0, _len = geometries.length; _i < _len; _i++) {
        g1 = geometries[_i];
        for (_j = 0, _len1 = geometries.length; _j < _len1; _j++) {
          g2 = geometries[_j];
          if (g1 === g2) {
            continue;
          }
          if (tested[g2 + g1]) {
            continue;
          }
          a = g1.intersections(g2);
          if (a != null) {
            intersections = intersections.concat(a);
          }
          tested[g1 + g2] = true;
        }
      }
      context.fillStyle = '#ffffff';
      _results = [];
      for (_k = 0, _len2 = intersections.length; _k < _len2; _k++) {
        intersection = intersections[_k];
        _results.push(context.fillRect(intersection.x - 2, intersection.y - 2, 4, 4));
      }
      return _results;
    };
    animate = function(n) {
      var d;
      stats.begin();
      d = n - t;
      t = n;
      testers.forEach(function(t) {
        return t.animate(d);
      });
      geometries[0].rotateAroundCenter(d / 70);
      geometries[0].inflateAroundCenter(Math.cos(t * Math.PI / 180), Math.sin(t * Math.PI / 180));
      geometries[1].rotateAroundCenter(-d / 60);
      geometries[1].scaleAroundCenter(1 + Math.cos(t / 12 * Math.PI / 180) / 200);
      geometries[2].radius = 40 + Math.sin(t / 17 * Math.PI / 180) * 20;
      geometries[3].radius1 = 120 + Math.sin(t / 17 * Math.PI / 180) * 20;
      geometries[3].radius2 = 60 + Math.cos(t / 17 * Math.PI / 180) * 20;
      geometries[3].rotation += -d / 60;
      render();
      if (animated) {
        requestAnimationFrame(animate);
      }
      return stats.end();
    };
    canvas.click(function(e) {
      if (!animated) {
        t = new Date().valueOf();
        requestAnimationFrame(animate);
        return animated = true;
      } else {
        return animated = false;
      }
    });
    return render();
  });

}).call(this);
