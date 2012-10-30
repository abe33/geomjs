
Rectangle = require '../../../lib/geomjs/rectangle'

global.rectangle = (x, y, width, height, rotation) ->
  new Rectangle x, y, width, height, rotation

global.addRectangleMatchers = (scope) ->
  scope.addMatchers
    toBeRectangle: (x=0, y=0, width=0, height=0, rotation=0) ->
      @message = ->
        "Expect #{@actual}#{if @isNot then ' not' else ''} to be a rectangle
         equals to (#{x},#{y},#{width},#{height},#{rotation})".squeeze()

      @actual.x is x and
      @actual.y is y and
      @actual.width is width and
      @actual.height is height and
      @actual.rotation is rotation

global.testRotatedRectangle = (source, x, y, width, height, rotation) ->
  xTopEdge = width * Math.cos Math.degToRad rotation
  yTopEdge = width * Math.sin Math.degToRad rotation

  xLeftEdge = height * Math.cos Math.degToRad(rotation) + Math.PI / 2
  yLeftEdge = height * Math.sin Math.degToRad(rotation) + Math.PI / 2

  # Corners
  pointOf(source, 'topLeft').shouldBe(x,y)
  pointOf(source, 'topRight').shouldBe(x + xTopEdge, y + yTopEdge)
  pointOf(source, 'bottomLeft').shouldBe(x + xLeftEdge, y + yLeftEdge)
  pointOf(source, 'bottomRight').shouldBe(x + xTopEdge + xLeftEdge,
                                          y + yTopEdge + yLeftEdge)
  # Edges
  pointOf(source, 'topEdge').shouldBe(xTopEdge, yTopEdge)
  pointOf(source, 'bottomEdge').shouldBe(xTopEdge, yTopEdge)
  pointOf(source, 'leftEdge').shouldBe(xLeftEdge, yLeftEdge)
  pointOf(source, 'rightEdge').shouldBe(xLeftEdge, yLeftEdge)

  # Centers
  pointOf(source, 'center').shouldBe(x + xTopEdge / 2 + xLeftEdge / 2,
                                     y + yTopEdge / 2 + yLeftEdge / 2 )
  pointOf(source, 'topEdgeCenter')
    .shouldBe(x + xTopEdge / 2,
              y + yTopEdge / 2)
  pointOf(source, 'bottomEdgeCenter')
    .shouldBe(x + xTopEdge / 2 + xLeftEdge,
              y + yTopEdge / 2 + yLeftEdge)
  pointOf(source, 'leftEdgeCenter')
    .shouldBe(x + xLeftEdge / 2,
              y + yLeftEdge / 2)
  pointOf(source, 'rightEdgeCenter')
    .shouldBe(x + xLeftEdge / 2 + xTopEdge,
              y + yLeftEdge / 2 + yTopEdge)

  # Bounds
  bounds =
    top: Math.min y, y+yTopEdge, y+yLeftEdge, y+yTopEdge+yLeftEdge
    bottom: Math.max y, y+yTopEdge, y+yLeftEdge, y+yTopEdge+yLeftEdge
    left: Math.min x, x+xTopEdge, x+xLeftEdge, x+xTopEdge+xLeftEdge
    right: Math.max x, x+xTopEdge, x+xLeftEdge, x+xTopEdge+xLeftEdge

  bounds.map (k,v) ->
    describe "the #{source} #{k} method", ->
      it "should return #{v}", ->
        expect(@[source][k]()).toBeClose(v)

