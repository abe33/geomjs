
Circle = require '../../../lib/geomjs/circle'

DEFAULT_SEGMENTS = 36

global.addCircleMatchers = (scope) ->
  scope.addMatchers
    toBeCircle: (radius, x, y, segments) ->
      @message = ->
        notText = if @isNot then ' not' else ''
        "Expected #{@actual}#{notText} to be a circle with
        radius=#{radius}, x=#{x}, y=#{y}, segments=#{segments}".squeeze()

      @actual.radius is radius and
      @actual.x is x and
      @actual.y is y and
      @actual.segments is segments

global.circle = (radius, x, y, segments) ->
  new Circle radius, x, y, segments

global.circleData = (radius, x, y, segments) ->
  data = {radius, x, y, segments}

  data.merge
    acreage: Math.PI * radius * radius
    length: 2 * Math.PI * radius
    top: y - radius
    bottom: y + radius
    left: x - radius
    right: x + radius

  data.merge
    bounds:
      top: data.top
      bottom: data.bottom
      left: data.left
      right: data.right

  data

global.circleFactories =
  default:
    args: [1,1,1]
    test: [1,1,1,DEFAULT_SEGMENTS]
  withSegments:
    args: [2,3,4,60]
    test: [2,3,4,60]
  empty:
    args:[]
    test:[1,0,0,DEFAULT_SEGMENTS]
