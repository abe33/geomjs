$(document).ready ->
  stats = new Stats
  stats.setMode 0

  $('#canvas').prepend(stats.domElement)

  requestAnimationFrame = window.mozRequestAnimationFrame or
                          window.webkitRequestAnimationFrame or
                          window.msRequestAnimationFrame or
                          window.oRequestAnimationFrame or
                          window.requestAnimationFrame or
                          (f) -> setTimeout f, 1000 / 60

  canvas = $('canvas')
  context = canvas[0].getContext('2d')

  animated = false
  geometries = [
    new geomjs.Rectangle(250, 40, 180, 100, 16)
    new geomjs.Triangle(new geomjs.Point(100,80),
                        new geomjs.Point(320,120),
                        new geomjs.Point(140,200))
    new geomjs.Circle(60, 80, 160)
    new geomjs.Ellipsis(120, 60, 470, 180, 10)
    new geomjs.Diamond(50,100, 60, 40, 420, 250)

    new geomjs.Polygon([
      new geomjs.Point(160, 190)
      new geomjs.Point(200, 280)
      new geomjs.Point(260, 260)
      new geomjs.Point(280, 280)
      new geomjs.Point(380, 190)
      new geomjs.Point(180, 160)
      new geomjs.Point(260, 220)
    ])

    new geomjs.LinearSpline([
      new geomjs.Point(260, 290)
      new geomjs.Point(300, 380)
      new geomjs.Point(320, 300)
      new geomjs.Point(340, 380)
      new geomjs.Point(380, 290)
    ])

    new geomjs.CubicBezier([
      new geomjs.Point(120, 300)
      new geomjs.Point(100, 350)
      new geomjs.Point(280, 420)
      new geomjs.Point(120, 420)
      new geomjs.Point(40, 420)
      new geomjs.Point(100, 240)
      new geomjs.Point(180, 200)
    ])
  ]

  options =
    bounds: true
    path: true
    surface: true
    angle: true
    intersections: true
    vertices: true
    triangles: true

  testers = geometries.map (g) ->
    tester = new Tester g, options
    options[tester.name] = true
    tester

  t = new Date().valueOf()

  mouseX= 0
  mouseY= 0

  render = ->
    context.fillStyle = '#042029'
    context.fillRect(0, 0, canvas.width(), canvas.height())
    testers.forEach (t) ->
      t.isOver mouseX, mouseY
      t.render context if options[t.name]

    if options.intersections
      intersections = []
      tested = {}

      for g1 in geometries
        continue unless options[g1.classname().toLowerCase()]
        for g2 in geometries
          continue unless options[g2.classname().toLowerCase()]
          continue if g1 is g2
          continue if tested[g2 + g1]

          a = g1.intersections g2
          intersections = intersections.concat a if a?
          tested[g1 + g2] = true

      context.fillStyle = '#ffffff'
      for intersection in intersections
        context.fillRect intersection.x-2, intersection.y-2, 4, 4

  [
    rectangle
    triangle
    circle
    ellipsis
    diamond
    polygon
    linearSpline
    cubicBezier
  ] = geometries

  linearSplinePoints = (pt.clone() for pt in linearSpline.vertices)
  cubicBezierPoints = (pt.clone() for pt in cubicBezier.vertices)

  animate = (n) ->
    n = new Date().valueOf() if isNaN n
    stats.begin()
    d = n - t
    t = n

    testers.forEach (t) -> t.animate d if options[t.name]

    rectangle.rotateAroundCenter(d / 70)
    rectangle.inflateAroundCenter(Math.cos(Math.degToRad(t)) ,
                                  Math.sin(Math.degToRad(t)) )

    triangle.rotateAroundCenter(-d / 60)
    triangle.scaleAroundCenter(1 + Math.cos(Math.degToRad(t / 12)) / 200)

    circle.radius = 40 + Math.sin(Math.degToRad(t / 17)) * 20

    ellipsis.radius1 = 120 + Math.sin(Math.degToRad(t / 17)) * 20
    ellipsis.radius2 = 60 + Math.cos(Math.degToRad(t / 17)) * 20
    ellipsis.rotation += -d / 60

    diamond.topLength = 50 + Math.sin(Math.degToRad(t / 17)) * 20
    diamond.rightLength = 100 +
                          Math.cos(Math.degToRad(Math.PI / 2 + t / 17)) * 20
    diamond.bottomLength = 60 + Math.sin(Math.degToRad(Math.PI + t / 17)) * 20
    diamond.leftLength = 40 +
                         Math.sin(Math.degToRad(Math.PI * 1.5 + t / 17)) * 20
    diamond.rotation += -d / 80

    linearSpline.vertices.forEach (vertex, i) ->
      v = linearSplinePoints[i]
      i += 1
      vertex.x = v.x + Math.cos(i + Math.degToRad(Math.PI * 1.5 + t / 5)) * 20
      vertex.y = v.y + Math.sin(i + Math.degToRad(Math.PI * 1.5 + t / 5)) * 20

    cubicBezier.vertices.forEach (vertex, i) ->
      v = cubicBezierPoints[i]
      i += 1
      vertex.x = v.x + Math.cos(i + Math.degToRad(Math.PI * 1.5 + t / 5)) * 20
      vertex.y = v.y + Math.sin(i + Math.degToRad(Math.PI * 1.5 + t / 5)) * 20

    polygon.rotateAroundCenter(d / 80)
    polygon.scaleAroundCenter(1 + Math.cos(Math.degToRad(t / 10)) / 120)

    render()
    requestAnimationFrame(animate) if animated
    stats.end()

  initUI = ->
    canvas.mousemove (e) ->
      mouseX = e.pageX - canvas.offset().left
      mouseY = e.pageY - canvas.offset().top

    checkboxes = $('input[type=checkbox]').widgets()
    checkboxes.forEach (checkbox) ->
      checkbox.valueChanged.add (w,v) ->
        options[w.jTarget.attr('id')] = v
        render()

    play = $('input[type=button]').widgets()[0]
    play.action = action: ->
      unless $('#canvas .hint').hasClass 'clicked'
        $('#canvas .hint').addClass 'clicked'

      unless animated
        t = new Date().valueOf()
        requestAnimationFrame(animate)
        animated = true
        play.set 'value', 'Pause'
        play.removeClasses 'green'
      else
        animated = false
        play.set 'value', 'Play'
        play.addClasses 'green'


  initUI()
  render()

  $('body').removeClass 'preload'
