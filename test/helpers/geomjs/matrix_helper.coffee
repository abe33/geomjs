Matrix = require '../../../lib/geomjs/matrix'

global.matrix = (a, b, c, d, tx, ty) -> new Matrix a, b, c, d, tx, ty

matrix.identity = -> new Matrix
matrix.transformed = -> new Matrix 1, 2, 3, 4, 5, 6
matrix.inverted = -> new Matrix -2, 1, 1.5, -0.5, 1, -2
matrix.translated = -> new Matrix 1, 2, 3, 4, 3, 8
matrix.scaled = -> new Matrix 0.5, 2, 3, 8, 2.5, 12
matrix.rotated = ->
  new Matrix(
    -1.474897313797955,
    -1.6806778137857286,
    -3.917045215869792,
    -3.107532264809421,
    -6.35919311794163,
    -4.534386715833113
  )

matrix.appended = ->
  new Matrix(
    6*1 + 5*3,
    6*2 + 5*4,
    4*1 + 3*3,
    4*2 + 3*4,
    2*1 + 1*3 + 5,
    2*2 + 1*4 + 6,
  )

global.addMatrixMatchers = (scope) ->
  scope.addMatchers
    toBeSameMatrix: (m) ->
      @message = ->
        "Expected #{@actual}#{if @isNot then ' not' else ''}
         to be a matrix equal to #{m}".squeeze()

      @actual.a is m.a and
      @actual.b is m.b and
      @actual.c is m.c and
      @actual.d is m.d and
      @actual.tx is m.tx and
      @actual.ty is m.ty

    toBeIdentity: ->
      @message = ->
        "Expected #{@actual}#{if @isNot then ' not' else ''}
         to be an identity matrix".squeeze()

      @actual.a is 1 and
      @actual.b is 0 and
      @actual.c is 0 and
      @actual.d is 1 and
      @actual.tx is 0 and
      @actual.ty is 0
