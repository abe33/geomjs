
Rectangle = require '../../../lib/geomjs/rectangle'

global.rectangle = (x, y, width, height) -> new Rectangle x, y, width, height

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


