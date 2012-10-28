class Matrix
  @isMatrix: (m) ->
    return false unless m?
    return false for k in ['a', 'b', 'c', 'd', 'tx', 'ty'] when not m[k]?
    true

  constructor: (a=1, b=0, c=0, d=1, tx=0, ty=0) ->
    if @isMatrix a
      {@a, @b, @c, @d, @tx, @ty} = a
    else if @isFloat a, b, c, d, tx, ty
      [@a, @b, @c, @d, @tx, @ty] = @asFloat a, b, c, d, tx, ty
    else
      @invalidMatrixArguments [a, b, c, d, tx, ty]

  translate: (x=0, y=0) ->
    @tx += x
    @ty += y
    this

  scale: (x=1, y=1) ->
    @a *= x
    @d *= y
    @tx *= x
    @ty *= y
    this

  rotate: (angle=0) ->
    cos = Math.cos angle
    sin = Math.sin angle
    [@a, @b, @c, @d, @tx, @ty] = [
      @a * cos - @b * sin
      @a * sin + @b * cos
      @c * cos - @d * sin
      @c * sin + @d * cos
      @tx * cos - @ty * sin
      @tx * sin + @ty * cos
    ]
    this

  append: (a=1, b=0, c=0, d=1, tx=0, ty=0) ->
    [@a, @b, @c, @d, @tx, @ty] = [
       a*@a + b*@c
       a*@b + b*@d
       c*@a + d*@c
       c*@b + d*@d
      tx*@a + ty*@c + @tx
      tx*@b + ty*@d + @ty
    ]
    this

  identity: -> [@a, @b, @c, @d, @tx, @ty] = [1, 0, 0, 1, 0, 0]; this

  inverse: ->
    n = @a * @d - @b * @c
    [@a, @b, @c, @d, @tx, @ty] = [
       @d / n
      -@b / n
      -@c / n
       @a / n
       (@c*@ty - @d*@tx) / n
      -(@a*@ty - @b*@tx) / n
    ]
    this

  asFloat: (floats...) ->
    floats[i] = parseFloat n for n,i in floats
    floats

  isMatrix: (m) -> Matrix.isMatrix m
  isFloat: (floats...) ->
    return false for float in floats when isNaN parseFloat float
    true

  invalidMatrixArguments: (args) ->
    throw new Error "Invalid arguments #{args} for a Matrix"

  clone: -> new Matrix this
  toString: -> "[object Matrix(#{@a},#{@b},#{@c},#{@d},#{@tx},#{@ty})]"

module.exports = Matrix
