
Math.degToRad = (n) -> n * Math.PI / 180

Math.radToDeg = (n) -> n * 180 / Math.PI

Math.normalize = (value, minimum, maximum) ->
  (value - minimum) / (maximum - minimum)

Math.interpolate = (normValue, minimum, maximum) ->
  minimum + (maximum - minimum) * normValue

Math.deltaBelowRatio = (a, b, ratio=10000000000) -> Math.abs(a - b) < 1 / ratio

Math.map = (value, min1, max1, min2, max2) ->
  Math.interpolate Math.normalize(value, min1, max1), min2, max2
