(function() {
  var Tester;

  Tester = (function() {
    var colorPalette;

    colorPalette = {
      shapeStroke: '#ff0000',
      shapeFill: 'rgba(255,0,0,0.2)',
      shapeOverStroke: '#859900',
      shapeOverFill: 'rgba(133, 153, 0, 0.2)',
      bounds: 'rgba(133, 153, 0, 0.3)',
      intersections: '#268bd2',
      intersections2: 'white',
      text: '#93a1a1',
      mobile: '#b58900',
      vertices: '#d33682',
      verticesConnections: 'rgba(211,54,130,0.5)'
    };

    function Tester(geometry, options) {
      this.geometry = geometry;
      this.options = options;
      this.pathPosition = 0;
      this.random = new chancejs.Random(new chancejs.MathRandom);
      this.name = this.geometry.classname().toLowerCase();
      this.angle = 0;
      this.angleSpeed = this.random["in"](-2, 2);
      this.shate;
      this.fillColor = colorPalette.shapeFill;
      this.strokeColor = colorPalette.shapeStroke;
    }

    Tester.prototype.isOver = function(mouseX, mouseY) {
      if ((this.geometry.contains != null) && this.geometry.contains(mouseX, mouseY)) {
        this.fillColor = colorPalette.shapeOverFill;
        return this.strokeColor = colorPalette.shapeOverStroke;
      } else {
        this.fillColor = colorPalette.shapeFill;
        return this.strokeColor = colorPalette.shapeStroke;
      }
    };

    Tester.prototype.animate = function(t) {
      this.pathPosition += t / 5;
      if (this.pathPosition > 1) {
        this.pathPosition -= 1;
      }
      this.angle += t * this.angleSpeed;
      this.geometry.rotate(-(t * this.angleSpeed / 10));
      this.geometry.translate(Math.sin(this.angle) * 2, Math.cos(this.angle) * 2);
      return this.geometry.scale(1 + Math.cos(this.angle * 3) / 100);
    };

    Tester.prototype.renderShape = function(context) {
      this.geometry.fill(context, this.fillColor);
      return this.geometry.stroke(context, this.strokeColor);
    };

    Tester.prototype.renderPath = function(context) {
      var pt, tan, tr;
      pt = this.geometry.pathPointAt(this.pathPosition, false);
      tan = this.geometry.pathOrientationAt(this.pathPosition, false);
      if ((pt != null) && (tan != null)) {
        tr = new geomjs.Rectangle(pt.x, pt.y, 6, 6, tan);
        return tr.stroke(context, colorPalette.mobile);
      }
    };

    Tester.prototype.renderSurface = function(context) {
      var i, pt, _i, _results;
      context.fillStyle = this.strokeColor;
      _results = [];
      for (i = _i = 0; _i <= 50; i = ++_i) {
        pt = this.geometry.randomPointInSurface(this.random);
        if (pt != null) {
          _results.push(context.fillRect(pt.x, pt.y, 1, 1));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    Tester.prototype.renderTriangles = function(context) {
      var tri, triangles, _i, _len, _results;
      triangles = this.geometry.triangles();
      _results = [];
      for (_i = 0, _len = triangles.length; _i < _len; _i++) {
        tri = triangles[_i];
        _results.push(tri.stroke(context, this.fillColor));
      }
      return _results;
    };

    Tester.prototype.renderBounds = function(context) {
      var r;
      context.strokeStyle = colorPalette.bounds;
      r = this.geometry.boundingBox();
      if (r != null) {
        return context.strokeRect(r.x, r.y, r.width, r.height);
      }
    };

    Tester.prototype.renderClosedGeometry = function(context) {
      var c, pt1, pt2, pt3;
      c = this.geometry.center();
      pt1 = this.geometry.pointAtAngle(this.angle);
      pt2 = this.geometry.pointAtAngle(this.angle - Math.PI * 2 / 3);
      pt3 = this.geometry.pointAtAngle(this.angle + Math.PI * 2 / 3);
      if ((pt1 != null) && (pt2 != null) && (pt3 != null)) {
        context.fillStyle = colorPalette.intersections;
        context.strokeStyle = colorPalette.intersections;
        context.fillRect(pt1.x - 2, pt1.y - 2, 4, 4);
        context.fillRect(pt2.x - 2, pt2.y - 2, 4, 4);
        context.fillRect(pt3.x - 2, pt3.y - 2, 4, 4);
        context.beginPath();
        context.moveTo(pt1.x, pt1.y);
        context.lineTo(c.x, c.y);
        context.lineTo(pt2.x, pt2.y);
        context.moveTo(c.x, c.y);
        context.lineTo(pt3.x, pt3.y);
        return context.stroke();
      }
    };

    Tester.prototype.renderVertices = function(context) {
      this.geometry.drawVertices(context, colorPalette.vertices);
      return this.geometry.drawVerticesConnections(context, colorPalette.verticesConnections);
    };

    Tester.prototype.render = function(context) {
      if ((this.geometry.stroke != null) && (this.geometry.fill != null)) {
        this.renderShape(context);
      }
      if (this.options.bounds && (this.geometry.bounds != null)) {
        this.renderBounds(context);
      }
      if (this.options.path && (this.geometry.pathPointAt != null) && (this.geometry.pathOrientationAt != null)) {
        this.renderPath(context);
      }
      if (this.options.surface && (this.geometry.randomPointInSurface != null)) {
        this.renderSurface(context);
      }
      if (this.options.triangles && (this.geometry.triangles != null)) {
        this.renderTriangles(context);
      }
      if (this.options.angle && (this.geometry.center != null) && (this.geometry.pointAtAngle != null)) {
        this.renderClosedGeometry(context);
      }
      if (this.options.vertices && (this.geometry.drawVertices != null)) {
        return this.renderVertices(context);
      }
    };

    return Tester;

  })();

  $(document).ready(function() {
    var animate, animated, canvas, context, geometries, initUI, mouseX, mouseY, options, render, requestAnimationFrame, stats, t, testers;
    stats = new Stats;
    stats.setMode(0);
    $('#canvas').prepend(stats.domElement);
    requestAnimationFrame = window.mozRequestAnimationFrame || window.webkitRequestAnimationFrame || window.msRequestAnimationFrame || window.oRequestAnimationFrame || window.requestAnimationFrame || function(f) {
      return setTimeout(f, 1000 / 60);
    };
    canvas = $('canvas');
    context = canvas[0].getContext('2d');
    animated = false;
    geometries = [new geomjs.Rectangle(250, 40, 180, 100, Math.PI / 7), new geomjs.Triangle(new geomjs.Point(100, 80), new geomjs.Point(320, 120), new geomjs.Point(140, 200)), new geomjs.Circle(60, 80, 160), new geomjs.Ellipsis(120, 60, 470, 180, 10), new geomjs.Diamond(50, 100, 60, 40, 420, 250), new geomjs.Polygon([new geomjs.Point(160, 190), new geomjs.Point(200, 280), new geomjs.Point(260, 260), new geomjs.Point(280, 280), new geomjs.Point(380, 190), new geomjs.Point(180, 160), new geomjs.Point(260, 220)]), new geomjs.LinearSpline([new geomjs.Point(260, 290), new geomjs.Point(300, 380), new geomjs.Point(320, 300), new geomjs.Point(340, 380), new geomjs.Point(380, 290)]), new geomjs.CubicBezier([new geomjs.Point(120, 300), new geomjs.Point(100, 350), new geomjs.Point(280, 420), new geomjs.Point(120, 420), new geomjs.Point(40, 420), new geomjs.Point(100, 240), new geomjs.Point(180, 200)]), new geomjs.QuadBezier([new geomjs.Point(180, 350), new geomjs.Point(220, 290), new geomjs.Point(260, 350), new geomjs.Point(300, 410), new geomjs.Point(360, 350)]), new geomjs.QuintBezier([new geomjs.Point(380, 350), new geomjs.Point(420, 290), new geomjs.Point(460, 340), new geomjs.Point(500, 290), new geomjs.Point(560, 350)]), new geomjs.Spiral(120, 60, 3, 470, 420, 10, 120)];
    options = {
      bounds: true,
      path: true,
      surface: true,
      angle: true,
      intersections: true,
      vertices: true,
      triangles: true
    };
    testers = geometries.map(function(g) {
      var tester;
      tester = new Tester(g, options);
      options[tester.name] = true;
      return tester;
    });
    t = new Date().valueOf();
    mouseX = 0;
    mouseY = 0;
    render = function() {
      var a, g1, g2, intersection, intersections, tested, _i, _j, _k, _len, _len1, _len2, _results;
      context.fillStyle = '#042029';
      context.fillRect(0, 0, canvas.width(), canvas.height());
      testers.forEach(function(t) {
        t.isOver(mouseX, mouseY);
        if (options[t.name]) {
          return t.render(context);
        }
      });
      if (options.intersections) {
        intersections = [];
        tested = {};
        for (_i = 0, _len = geometries.length; _i < _len; _i++) {
          g1 = geometries[_i];
          if (!options[g1.classname().toLowerCase()]) {
            continue;
          }
          for (_j = 0, _len1 = geometries.length; _j < _len1; _j++) {
            g2 = geometries[_j];
            if (!options[g2.classname().toLowerCase()]) {
              continue;
            }
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
      }
    };
    animate = function(n) {
      var d;
      if (isNaN(n)) {
        n = new Date().valueOf();
      }
      stats.begin();
      d = n - t;
      t = n;
      d = d / 1000;
      testers.forEach(function(t) {
        if (options[t.name]) {
          return t.animate(d);
        }
      });
      render();
      if (animated) {
        requestAnimationFrame(animate);
      }
      return stats.end();
    };
    initUI = function() {
      var checkboxes, play;
      canvas.mousemove(function(e) {
        mouseX = e.pageX - canvas.offset().left;
        return mouseY = e.pageY - canvas.offset().top;
      });
      checkboxes = $('input[type=checkbox]').widgets();
      checkboxes.forEach(function(checkbox) {
        return checkbox.valueChanged.add(function(w, v) {
          options[w.jTarget.attr('id')] = v;
          return render();
        });
      });
      play = $('input[type=button]').widgets()[0];
      return play.action = {
        action: function() {
          if (!$('#canvas .hint').hasClass('clicked')) {
            $('#canvas .hint').addClass('clicked');
          }
          if (!animated) {
            t = new Date().valueOf();
            requestAnimationFrame(animate);
            animated = true;
            play.set('value', 'Pause');
            return play.removeClasses('green');
          } else {
            animated = false;
            play.set('value', 'Play');
            return play.addClasses('green');
          }
        }
      };
    };
    initUI();
    render();
    return $('body').removeClass('preload');
  });

}).call(this);
