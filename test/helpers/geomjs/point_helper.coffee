
global.addPointMatchers = (scope) ->
  scope.addMatchers

    toBePoint: (x=0, y=0) ->
      actual = @actual
      notText = if @isNot then " not" else ""

      @message = ->
        "Expected #{actual}#{notText} to be a point with x = #{x} and y = #{y}"

      actual.x is x and actual.y is y
