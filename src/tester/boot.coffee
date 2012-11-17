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

    new geomjs.LinearSpline([
      new geomjs.Point(260, 290)
      new geomjs.Point(300, 380)
      new geomjs.Point(320, 300)
      new geomjs.Point(340, 380)
      new geomjs.Point(380, 290)
    ])
  ]

  options =
    bounds: true
    path: true
    surface: true
    angle: true
    intersections: true
    vertices: true

  testers = geometries.map (g) ->
    tester = new Tester g, options
    options[tester.name] = true
    tester

  t = new Date().valueOf()

  render = ->
    context.fillStyle = '#042029'
    context.fillRect(0, 0, canvas.width(), canvas.height())
    testers.forEach (t) ->
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

  [rectangle, triangle, circle, ellipsis, diamond] = geometries

  animate = (n) ->
    stats.begin()
    d = n - t
    t = n

    testers.forEach (t) -> t.animate d if options[t.name]

    rectangle.rotateAroundCenter(d / 70)
    rectangle.inflateAroundCenter(Math.cos(t * Math.PI / 180) ,
                                  Math.sin(t * Math.PI / 180) )

    triangle.rotateAroundCenter(-d / 60)
    triangle.scaleAroundCenter(1 + Math.cos(t / 12 * Math.PI / 180) / 200)

    circle.radius = 40 + Math.sin(t / 17 * Math.PI / 180) * 20

    ellipsis.radius1 = 120 + Math.sin(t / 17 * Math.PI / 180) * 20
    ellipsis.radius2 = 60 + Math.cos(t / 17 * Math.PI / 180) * 20
    ellipsis.rotation += -d / 60

    diamond.topLength = 50 + Math.sin(t / 17 * Math.PI / 180) * 20
    diamond.rightLength = 100 + Math.cos((Math.PI / 2 + t / 17 * Math.PI) / 180) * 20
    diamond.bottomLength = 60 + Math.sin((Math.PI + t / 17 * Math.PI) / 180) * 20
    diamond.leftLength = 40 + Math.sin((Math.PI * 1.5 + t / 17 * Math.PI) / 180) * 20
    diamond.rotation += -d / 80

    render()
    requestAnimationFrame(animate) if animated
    stats.end()

  initUI = ->
    canvas.click (e) ->
      unless $('#canvas .hint').hasClass 'clicked'
        $('#canvas .hint').addClass 'clicked'

      unless animated
        t = new Date().valueOf()
        requestAnimationFrame(animate)
        animated = true
      else
        animated = false

    widgets = $('input').widgets()
    widgets.forEach (widget) ->
      widget.valueChanged.add (w,v) ->
        options[w.jTarget.attr('id')] = v
        render()

  initUI()
  render()

  $('body').removeClass 'preload'
