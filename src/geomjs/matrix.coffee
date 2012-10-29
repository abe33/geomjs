# This file define the `Matrix` class used by various class inside geomjs.
# @toc
require './math'
Point = require './point'

## Matrix

# The Matrix class represents a transformation matrix that
# determines how to map points from one coordinate space to another.
# These transformation functions include translation (x and
# y repositioning), rotation, scaling, and skewing.
#
# A matrix can created with the following signature:
#
#     matrix = new Matrix
#
#     matrix = new Matrix a, b, c, d, tx, ty
#
#     matrix = new Matrix {a, b, c, d, tx, ty}
#
# An identity matrix is created if no arguments is provided.
class Matrix

  # A list of the proprties to be checked to consider an object as a matrix.
  PROPERTIES = ['a', 'b', 'c', 'd', 'tx', 'ty']

  #### Class Methods

  ##### Matrix.isMatrix
  #
  # Returns `true` if the passed-in object `m` is a valid matrix.
  # A valid matrix is an object with properties `a`, `b`, `c`, `d`,
  # `tx` and `ty` and that properties must contains numbers.
  #
  #     Matrix.isMatrix new Matrix  # true
  #
  #     matrix2 =
  #       a: 1, b: 0, tx: 0
  #       c: 0, d: 1, ty: 0
  #     Matrix.isMatrix matrix      # true
  #
  #     matrix2 =
  #       a: '1', b: '0', tx: '0'
  #       c: '0', d: '1', ty: '0'
  #     Matrix.isMatrix matrix      # true
  #
  #     Matris.isMatrix {}          # false
  @isMatrix: (m) ->
    return false unless m?
    return false for k in PROPERTIES when not @isFloat m[k]
    true

  # Returns `true` if all the arguments passed to function are
  # floats or can be casted to floats.
  #
  #     Matrix.isFloat 1, 0.2, '0.5' # true
  #     Matrix.isFloat 'foo'         # false
  @isFloat: (floats...) ->
    return false for float in floats when isNaN parseFloat float
    true

  #### Instances Methods

  ##### Matrix::constructor
  #
  # Creates a new Matrix instance.
  #
  # A matrix can created with the following signature:
  #
  #     matrix = new Matrix
  #
  #     matrix = new Matrix a, b, c, d, tx, ty
  #
  #     matrix = new Matrix {a, b, c, d, tx, ty}
  #
  # An identity matrix is created if no arguments is provided.
  constructor: (a=1, b=0, c=0, d=1, tx=0, ty=0) ->
    [@a, @b, @c, @d, @tx, @ty] = @matrixFrom a, b, c, d, tx, ty

  ##### Matrix::equals
  #
  # Compares the current matrix with the passed-in object and
  # returns `true` when the two objects properties are equals.
  #
  #     matrix = new Matrix
  #
  #     matrix.equals new Matrix  # true
  #
  #     matrix2 =
  #       a: 1, b: 0, tx: 0
  #       c: 0, d: 1, ty: 0
  #     matrix.equals matrix2     # true
  equals: (o) ->
    return false unless o?
    return false for k in PROPERTIES when o[k] isnt @[k]
    true

  ##### Matrix::transformPoint
  #
  # Returns a new point corresponding to the transformation
  # of the passed-in point by the current matrix.
  #
  #     point = new Point, 10, 0
  #
  #     matrix = new Matrix().scale(2,2).rotate(90)
  #
  #     projected = matrix.transformPoint point
  #     # projected = [object Point(0,20)]
  transformPoint: (xOrPt, y) ->
    if not xOrPt? and not y?
      throw new Error "transformPoint was called without arguments"

    [x,y] = Point.coordsFrom xOrPt, y, true
    x2 = x*@a + y*@c + @tx
    y2 = x*@b + y*@d + @ty
    new Point x2, y2

  ##### Matrix::translate
  #
  # Translates the matrix by the amount of the passed-in point.
  translate: (xOrPt, y) ->
    [x,y] = @coordsFrom xOrPt, y, 0

    @tx += x
    @ty += y
    this

  ##### Matrix::scale
  #
  # Scales the matrix by the amount of the passed-in point.
  scale: (xOrPt, y) ->
    [x,y] = @coordsFrom xOrPt, y, 1

    @a *= x
    @d *= y
    @tx *= x
    @ty *= y
    this

  ##### Matrix::rotate
  #
  # Rotates the matrix by the amount of the passed-in angle in degrees.
  rotate: (angle=0) ->
    cos = Math.cos Math.degToRad angle
    sin = Math.sin Math.degToRad angle
    [@a, @b, @c, @d, @tx, @ty] = [
      @a * cos - @b * sin
      @a * sin + @b * cos
      @c * cos - @d * sin
      @c * sin + @d * cos
      @tx * cos - @ty * sin
      @tx * sin + @ty * cos
    ]
    this

  ##### Matrix::skew
  #
  # Skews the matrix by the amount of the passed-in point.
  skew: (xOrPt, y) ->
    [x,y] = @coordsFrom xOrPt, y, 0
    [x,y] = [Math.degToRad(x), Math.degToRad(y)]
    @append Math.cos(y),
            Math.sin(y),
            -Math.sin(x),
            Math.cos(x)

  ##### Matrix::append
  #
  # Append the passed-in matrix to this matrix.
  append: (a=1, b=0, c=0, d=1, tx=0, ty=0) ->
    [a, b, c, d, tx, ty] = @matrixFrom a, b, c, d, tx, ty
    [@a, @b, @c, @d, @tx, @ty] = [
       a*@a + b*@c
       a*@b + b*@d
       c*@a + d*@c
       c*@b + d*@d
      tx*@a + ty*@c + @tx
      tx*@b + ty*@d + @ty
    ]
    this

  ##### Matrix::prepend
  #
  # Prepend the passed-in matrix with this matrix.
  prepend: (a=1, b=0, c=0, d=1, tx=0, ty=0) ->
    [a, b, c, d, tx, ty] = @matrixFrom a, b, c, d, tx, ty
    if a isnt 1 or b isnt 0 or c isnt 0 or d isnt 1
      [@a, @b, @c, @d] = [
        @a*a + @b*c
        @a*b + @b*d
        @c*a + @d*c
        @c*b + @d*d
      ]

    [@tx, @ty] = [
      @tx*a + @ty*c + tx
      @tx*b + @ty*d + ty
    ]
    this

  ##### Matrix::identity
  #
  # Converts this matrix into an identity matrix.
  identity: -> [@a, @b, @c, @d, @tx, @ty] = [1, 0, 0, 1, 0, 0]; this

  ##### Matrix::inverse
  #
  # Converts this matrix into its inverse.
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

  ##### Matrix::asFloat
  #
  # Returns the passed-in arguments casted into floats.
  asFloat: (floats...) ->
    floats[i] = parseFloat n for n,i in floats
    floats

  ##### Matrix::matrixFrom
  #
  # Takes the arguments passed to a function that accept a matrix
  # and returns an array with all the components of a matrix.
  #
  # It handle both the case where all components are passed to the functions
  # as numbers or inside an object.
  matrixFrom: (a, b, c, d, tx, ty) ->
    if @isMatrix a
      {a, b, c, d, tx, ty} = a
    else unless @isFloat a, b, c, d, tx, ty
      @invalidMatrixArguments [a, b, c, d, tx, ty]

    @asFloat a, b, c, d, tx, ty

  ##### Matrix::coordsFrom
  #
  # Takes the arguments passed to a function that accept a point
  # and returns an array with the point coordinates.
  coordsFrom: (xOrPt, y, def) ->
    [x,y] = Point.coordsFrom xOrPt, y
    x = def if isNaN x
    y = def if isNaN y
    [x,y]

  ##### Matrix::isMatrix
  #
  # Alias the `Matrix.isMatrix` method in instances.
  isMatrix: (m) -> Matrix.isMatrix m

  ##### Matrix::isFloat
  #
  # Alias the `Matrix.isFloat` method in instances.
  isFloat: (floats...) -> Matrix.isFloat.apply Matrix, floats

  ##### Matrix::clone
  #
  # Returns a copy of this matrix.
  clone: -> new Matrix this

  ##### Matrix::toString
  #
  # Returns the string representation of this matrix.
  toString: -> "[object Matrix(#{@a},#{@b},#{@c},#{@d},#{@tx},#{@ty})]"

  #### Instance Errors Method

  ##### Matrix::invalidMatrixArguments
  #
  # Throws an error for invalid matrix components passed to a function.
  invalidMatrixArguments: (args) ->
    throw new Error "Invalid arguments #{args} for a Matrix"


module.exports = Matrix
