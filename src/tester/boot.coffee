
$(document).ready ->
  stats = new Stats
  stats.setMode 0

  $('div').prepend(stats.domElement)

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
  ]
  testers = geometries.map (g) -> new Tester g

  t = new Date().valueOf()

  render = ->
    context.fillStyle = '#042029'
    context.fillRect(0, 0, canvas.width(), canvas.height())
    testers.forEach (t) -> t.render context

    intersections = []
    tested = {}

    for g1 in geometries
      for g2 in geometries
        continue if g1 is g2
        continue if tested[g2 + g1]

        a = g1.intersections g2
        intersections = intersections.concat a if a?
        tested[g1 + g2] = true

    context.fillStyle = '#ffffff'
    for intersection in intersections
      context.fillRect intersection.x-2, intersection.y-2, 4, 4

  animate = (n) ->
    stats.begin()
    d = n - t
    t = n

    testers.forEach (t) -> t.animate d

    geometries[0].rotateAroundCenter(d / 70)
    geometries[0].inflateAroundCenter(Math.cos(t * Math.PI / 180) ,
                                      Math.sin(t * Math.PI / 180) )

    geometries[1].rotateAroundCenter(-d / 60)
    geometries[1].scaleAroundCenter(1 + Math.cos(t / 12 * Math.PI / 180) / 200)

    geometries[2].radius = 40 + Math.sin(t / 17 * Math.PI / 180) * 20

    geometries[3].radius1 = 120 + Math.sin(t / 17 * Math.PI / 180) * 20
    geometries[3].radius2 = 60 + Math.cos(t / 17 * Math.PI / 180) * 20
    geometries[3].rotation += -d / 60

    render()
    requestAnimationFrame(animate) if animated
    stats.end()

  canvas.click (e) ->
    unless animated
      t = new Date().valueOf()
      requestAnimationFrame(animate)
      animated = true
    else
      animated = false

  render()
