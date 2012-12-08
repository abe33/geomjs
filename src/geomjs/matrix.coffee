# This file define the `Matrix` class used by various class inside geomjs.
# @toc
mixinsjs = require 'mixinsjs'

{
  Equatable,
  Cloneable,
  Sourcable,
  Formattable,
  Parameterizable,
  include
} = mixinsjs

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

  include([
    Equatable.apply(null, PROPERTIES)
    Formattable.apply(null, ['Matrix'].concat PROPERTIES)
    Sourcable.apply(null, ['geomjs.Matrix'].concat PROPERTIES)
    Parameterizable('matrixFrom', {
      a: 1
      b: 0
      c: 0
      d: 1
      tx: 0
      ty: 0
    })
    Cloneable()
  ]).in Matrix

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
    return false for k in PROPERTIES when not Math.isFloat m[k]
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
    {@a, @b, @c, @d, @tx, @ty} = @matrixFrom a, b, c, d, tx, ty, true

  ##### Matrix::transformPoint
  #
  # Returns a new point corresponding to the transformation
  # of the passed-in point by the current matrix.
  #
  #     point = new Point 10, 0
  #
  #     matrix = new Matrix().scale(2,2).rotate(90)
  #
  #     projected = matrix.transformPoint point
  #     # projected = [object Point(0,20)]
  transformPoint: (xOrPt, y) ->
    if not xOrPt? and not y?
      throw new Error "transformPoint was called without arguments"

    {x,y} = Point.pointFrom xOrPt, y, true
    new Point x*@a + y*@c + @tx,
              x*@b + y*@d + @ty

  ##### Matrix::translate
  #
  # Translates the matrix by the amount of the passed-in point.
  translate: (xOrPt=0, y=0) ->
    {x,y} = Point.pointFrom xOrPt, y

    @tx += x
    @ty += y
    this

  ##### Matrix::scale
  #
  # Scales the matrix by the amount of the passed-in point.
  scale: (xOrPt=1, y=1) ->
    {x,y} = Point.pointFrom xOrPt, y

    @a *= x
    @d *= y
    @tx *= x
    @ty *= y
    this

  ##### Matrix::rotate
  #
  # Rotates the matrix by the amount of the passed-in angle in degrees.
  rotate: (angle=0) ->
    cos = Math.cos angle
    sin = Math.sin angle
    [@a, @b, @c, @d, @tx, @ty] = [
       @a*cos - @b*sin
       @a*sin + @b*cos
       @c*cos - @d*sin
       @c*sin + @d*cos
      @tx*cos - @ty*sin
      @tx*sin + @ty*cos
    ]
    this

  ##### Matrix::skew
  #
  # Skews the matrix by the amount of the passed-in point.
  skew: (xOrPt, y) ->
    pt = Point.pointFrom(xOrPt, y, 0)
    @append Math.cos(pt.y),
            Math.sin(pt.y),
            -Math.sin(pt.x),
            Math.cos(pt.x)

  ##### Matrix::append
  #
  # Append the passed-in matrix to this matrix.
  append: (a=1, b=0, c=0, d=1, tx=0, ty=0) ->
    {a, b, c, d, tx, ty} = @matrixFrom a, b, c, d, tx, ty, true
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
    {a, b, c, d, tx, ty} = @matrixFrom a, b, c, d, tx, ty, true
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

  ##### Matrix::isMatrix
  #
  # Alias the `Matrix.isMatrix` method in instances.
  isMatrix: (m) -> Matrix.isMatrix m

  ##### Matrix::toString
  #
  # See
  # [Formattable.toString][1]
  # [1]: src_geomjs_mixins_formattable.html#formattabletostring

  ##### Matrix::equals
  #
  # See
  # [Equatable.equals](src_geomjs_mixins_equatable.html#equatableequals)

  ##### Matrix::clone
  #
  # See
  # [Cloneable.clone](src_geomjs_mixins_cloneable.html#cloneableclone)


module.exports = Matrix
