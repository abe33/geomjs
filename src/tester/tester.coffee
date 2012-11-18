class Tester

  colorPalette =
    shapeStroke: '#ff0000'
    shapeFill: 'rgba(255,0,0,0.2)'
    shapeOverStroke: '#859900'
    shapeOverFill: 'rgba(133, 153, 0, 0.2)'
    bounds: 'rgba(133, 153, 0, 0.3)'
    intersections: '#268bd2'
    intersections2: 'white'
    text: '#93a1a1'
    mobile: '#b58900'
    vertices: '#d33682'

  constructor: (@geometry, @options) ->
    @pathPosition = 0
    @random = new chancejs.Random new chancejs.MathRandom
    @name = @geometry.classname().toLowerCase()
    @angle = 0
    @angleSpeed = @random.in [4..8]
    @shate
    @fillColor = colorPalette.shapeFill
    @strokeColor = colorPalette.shapeStroke

  isOver: (mouseX, mouseY) ->
    if @geometry.contains? and @geometry.contains mouseX, mouseY
      @fillColor = colorPalette.shapeOverFill
      @strokeColor = colorPalette.shapeOverStroke
    else
      @fillColor = colorPalette.shapeFill
      @strokeColor = colorPalette.shapeStroke

  animate: (t) ->
    @pathPosition += t
    @pathPosition -= 10000 if @pathPosition > 10000
    @angle += t / @angleSpeed

  renderShape: (context) ->
    @geometry.fill(context, @fillColor)
    @geometry.stroke(context, @strokeColor)

  renderPath: (context) ->
    pt = @geometry.pathPointAt(@pathPosition / 10000)
    tan = @geometry.pathOrientationAt(@pathPosition / 10000)

    if pt? and tan?
      tr = new geomjs.Rectangle(pt.x,pt.y,6,6,tan)
      tr.stroke(context, colorPalette.mobile)

  renderSurface: (context) ->
    context.fillStyle = @strokeColor
    for i in [0..100]
      pt = @geometry.randomPointInSurface @random
      context.fillRect(pt.x, pt.y, 1, 1) if pt?

  renderTriangles: (context) ->
    triangles = @geometry.triangles()
    for tri in triangles
      tri.stroke context, @fillColor

  renderBounds: (context) ->
    context.strokeStyle = colorPalette.bounds
    r = @geometry.boundingBox()
    context.strokeRect(r.x, r.y, r.width, r.height)  if r?

  renderClosedGeometry: (context) ->
    c = @geometry.center()
    pt1 = @geometry.pointAtAngle(@angle)
    pt2 = @geometry.pointAtAngle(@angle-120)
    pt3 = @geometry.pointAtAngle(@angle+120)

    if pt1? and pt2? and pt3?
      context.fillStyle = colorPalette.intersections
      context.strokeStyle = colorPalette.intersections

      context.fillRect(pt1.x-2, pt1.y-2, 4, 4)
      context.fillRect(pt2.x-2, pt2.y-2, 4, 4)
      context.fillRect(pt3.x-2, pt3.y-2, 4, 4)

      context.beginPath()
      context.moveTo(pt1.x,pt1.y)
      context.lineTo(c.x,c.y)
      context.lineTo(pt2.x,pt2.y)
      context.moveTo(c.x,c.y)
      context.lineTo(pt3.x,pt3.y)
      context.stroke()

  renderVertices: (context) ->
    @geometry.drawVertices context, colorPalette.vertices


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

    @renderVertices context if @options.vertices and @geometry.drawVertices?

    @renderTriangles context if @options.triangles and @geometry.triangles?
