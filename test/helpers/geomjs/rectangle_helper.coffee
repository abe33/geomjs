
Rectangle = require '../../../lib/geomjs/rectangle'

global.rectangle = (x, y, width, height, rotation) ->
  new Rectangle x, y, width, height, rotation

global.addRectangleMatchers = (scope) ->
  scope.addMatchers
    toBeRectangle: (x, y, width, height) ->
      @message = ->
        "Expect #{@actual}#{if @isNot then ' not' else ''} to be a rectangle
         equals to (#{x},#{y},#{width},#{height})".squeeze()

      @actual.x is x and
      @actual.y is y and
      @actual.width is width and
      @actual.height is height

global.testRotatedRectangle = (source, x, y, width, height, rotation) ->
  xTopEdge = width * Math.cos Math.degToRad rotation
  yTopEdge = width * Math.sin Math.degToRad rotation

  xleftEdge = height * Math.cos Math.degToRad(rotation) + Math.PI / 2
  yleftEdge = height * Math.sin Math.degToRad(rotation) + Math.PI / 2

  pointOf('rectangle', 'topLeft').shouldBe(x,y)
  pointOf('rectangle', 'topRight').shouldBe(x + xTopEdge, y + yTopEdge)
  pointOf('rectangle', 'bottomLeft').shouldBe(x + xleftEdge, y + yleftEdge)
  pointOf('rectangle', 'bottomRight').shouldBe(x + xTopEdge + xleftEdge,
                                               y + yTopEdge + yleftEdge)

  pointOf('rectangle', 'topEdge').shouldBe(xTopEdge, yTopEdge)
  pointOf('rectangle', 'bottomEdge').shouldBe(xTopEdge, yTopEdge)
  pointOf('rectangle', 'leftEdge').shouldBe(xleftEdge, yleftEdge)
  pointOf('rectangle', 'rightEdge').shouldBe(xleftEdge, yleftEdge)
