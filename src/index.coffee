# @toc

## GeomJS

# `GeomJS` is a small utility that provides many geometric primitives such
# `Triangle`, `Circle` or `Rectangle`; and more complex geometries
# such `Polygon`, `Diamond` or bezier splines.

# The library is articulated around several interfaces that all geometries
# implements, with an exception for the `Surface` interface that can't possibly
# be implemented by splines.
# Below the list of the interfaces and their roles:
#
#  * `Geometry`: All geometries provides methods to retrieve an array of points
#    corresponding to their display shape, retrieve their bounds and draw the
#    geometry on a canvas.
#  * `Path`: All geometries have an outline, and this outline can be used as
#    a path, providing both points and orientation on the path at a given
#    position.
#  * `Surface`: All geometries, except splines and spiral, provides method
#    to retrieve the surface acreage or to retrieve a random point in the
#    surface.
#  * `Triangulable`: All surface geometries can return an array containing
#    the triangulated version of the geometry.
#  * `Intersections`: All geometries can intersect with each other.
#  * `Sourcable`: All geometries can return the source code of their current
#    state.
#  * `Cloneable`: All geometries can return a copy of themselves.
#  * `Equatable`: All geometries provides a `equals` method to compare
#    instances of the same class.

module.exports =
  # ## Geometries

  #### Circle
  # [Go to documentation](./src_geomjs_circle.html)
  Circle: require './geomjs/circle'
  #### CubicBezier
  # [Go to documentation](./src_geomjs_cubic_bezier.html)
  CubicBezier: require './geomjs/cubic_bezier'
  #### Diamond
  # [Go to documentation](./src_geomjs_diamond.html)
  Diamond: require './geomjs/diamond'
  #### Ellipsis
  # [Go to documentation](./src_geomjs_ellipsis.html)
  Ellipsis: require './geomjs/ellipsis'
  #### Matrix
  # [Go to documentation](./src_geomjs_matrix.html)
  Matrix: require './geomjs/matrix'
  #### LinearSpline
  # [Go to documentation](./src_geomjs_linear_spline.html)
  LinearSpline: require './geomjs/linear_spline'
  #### Point
  # [Go to documentation](./src_geomjs_point.html)
  Point: require './geomjs/point'
  #### Polygon
  # [Go to documentation](./src_geomjs_polygon.html)
  Polygon: require './geomjs/polygon'
  #### QuadBezier
  # [Go to documentation](./src_geomjs_quad_bezier.html)
  QuadBezier: require './geomjs/quad_bezier'
  #### QuintBezier
  # [Go to documentation](./src_geomjs_quint_bezier.html)
  QuintBezier: require './geomjs/quint_bezier'
  #### Rectangle
  # [Go to documentation](./src_geomjs_rectangle.html)
  Rectangle: require './geomjs/rectangle'
  #### Spiral
  # [Go to documentation](./src_geomjs_spiral.html)
  Spiral: require './geomjs/spiral'
  #### Triangle
  # [Go to documentation](./src_geomjs_triangle.html)
  Triangle: require './geomjs/triangle'

  # ## Mixins

  #### Cloneable
  # [Go to documentation](./src_geomjs_mixins_cloneable.html)
  Cloneable: require './geomjs/mixins/cloneable'
  #### Equatable
  # [Go to documentation](./src_geomjs_mixins_equatable.html)
  Equatable: require './geomjs/mixins/equatable'
  #### Formattable
  # [Go to documentation](./src_geomjs_mixins_formattable.html)
  Formattable: require './geomjs/mixins/formattable'
  #### Geometry
  # [Go to documentation](./src_geomjs_mixins_geometry.html)
  Geometry: require './geomjs/mixins/geometry'
  #### Intersections
  # [Go to documentation](./src_geomjs_mixins_intersections.html)
  Intersections: require './geomjs/mixins/intersections'
  #### Memoizable
  # [Go to documentation](./src_geomjs_mixins_memoizable.html)
  Memoizable: require './geomjs/mixins/memoizable'
  #### Mixin
  # [Go to documentation](./src_geomjs_mixins_mixin.html)
  Mixin: require './geomjs/mixins/mixin'
  #### Parameterizable
  # [Go to documentation](./src_geomjs_mixins_parameterizable.html)
  Parameterizable: require './geomjs/mixins/parameterizable'
  #### Path
  # [Go to documentation](./src_geomjs_mixins_path.html)
  Path: require './geomjs/mixins/path'
  #### Sourcable
  # [Go to documentation](./src_geomjs_mixins_sourcable.html)
  Sourcable: require './geomjs/mixins/sourcable'
  #### Spline
  # [Go to documentation](./src_geomjs_mixins_spline.html)
  Spline: require './geomjs/mixins/spline'
  #### Surface
  # [Go to documentation](./src_geomjs_mixins_surface.html)
  Surface: require './geomjs/mixins/surface'
  #### Triangulable
  # [Go to documentation](./src_geomjs_mixins_triangulable.html)
  Triangulable: require './geomjs/mixins/triangulable'

