class Tester

  colorPalette =
    shapeStroke: '#ff0000'
    shapeFill: 'rgba(255,0,0,0.2)'
    bounds: 'rgba(133, 153, 0, 0.3)'
    intersections: '#268bd2'
    intersections2: 'white'
    text: '#93a1a1'
    mobile: '#b58900'

  constructor: (@geometry, @options) ->
    @pathPosition = 0
    @random = new chancejs.Random new chancejs.MathRandom
    @name = @geometry.classname().toLowerCase()

  animate: (t) ->
    @pathPosition += t
    @pathPosition -= 10000 if @pathPosition > 10000

  renderShape: (context) ->
    @geometry.fill(context, colorPalette.shapeFill)
    @geometry.stroke(context, colorPalette.shapeStroke)

  renderPath: (context) ->
    pt = @geometry.pathPointAt(@pathPosition / 10000)
    tan = @geometry.pathOrientationAt(@pathPosition / 10000)

    tr = new geomjs.Rectangle(pt.x,pt.y,6,6,tan)
    tr.stroke(context, colorPalette.mobile)

  renderSurface: (context) ->
    context.fillStyle = colorPalette.shapeStroke
    for i in [0..100]
      pt = @geometry.randomPointInSurface @random
      context.fillRect(pt.x, pt.y, 1, 1)

  renderBounds: (context) ->
    context.strokeStyle = colorPalette.bounds
    r = @geometry.boundingBox()
    context.strokeRect(r.x, r.y, r.width, r.height)

  renderClosedGeometry: (context) ->
    c = @geometry.center()
    pt1 = @geometry.pointAtAngle(0)
    pt2 = @geometry.pointAtAngle(-90)

    context.fillStyle = colorPalette.intersections
    context.strokeStyle = colorPalette.intersections

    context.fillRect(pt1.x-2, pt1.y-2, 4, 4)
    context.fillRect(pt2.x-2, pt2.y-2, 4, 4)

    context.beginPath()
    context.moveTo(pt1.x,pt1.y)
    context.lineTo(c.x,c.y)
    context.lineTo(pt2.x,pt2.y)
    context.stroke()

  render: (context) ->
    @renderShape context if @geometry.stroke? and @geometry.fill?
    @renderBounds context if @options.bounds and @geometry.bounds?
    @renderPath context if @options.path and
                           @geometry.pathPointAt? and
                           @geometry.pathOrientationAt?

    @renderSurface context if @options.surface and
                              @geometry.randomPointInSurface?
    @renderClosedGeometry context if @options.angle and
                                     @geometry.center? and
                                     @geometry.pointAtAngle?
