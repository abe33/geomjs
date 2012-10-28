Matrix = require '../../../lib/geomjs/matrix'

global.matrix = (a, b, c, d, tx, ty) -> new Matrix a, b, c, d, tx, ty

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
