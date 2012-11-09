
Circle = require '../../../lib/geomjs/circle'

global.addCircleMatchers = (scope) ->
  scope.addMatchers
    toBeCircle: (radius, x, y) ->
      @message = ->
        notText = if @isNot then ' not' else ''
        "Expected #{@actual}#{notText} to be a circle with
        radius=#{radius}, x=#{x}, y=#{y}".squeeze()

      @actual.radius is radius and
      @actual.x is x and
      @actual.y is y

global.circle = (radius, x, y) ->
  new Circle radius, x, y

global.circleData = (radius, x, y) ->
  data = {radius, x, y}

  data.merge
    acreage: Math.PI * radius * radius

  data


global.circleFactories =
  default:
    args: [1,1,1]
    test: [1,1,1]
  empty:
    args:[]
    test:[0,0,0]
