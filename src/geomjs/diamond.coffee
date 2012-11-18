# @toc
Point = require './point'
Triangle = require './triangle'
Equatable = require './mixins/equatable'
Formattable = require './mixins/formattable'
Cloneable = require './mixins/cloneable'
Sourcable = require './mixins/sourcable'
Memoizable = require './mixins/memoizable'
Parameterizable = require './mixins/parameterizable'
Geometry = require './mixins/geometry'
Surface = require './mixins/surface'
Path = require './mixins/path'
Intersections = require './mixins/intersections'

## Diamond
class Diamond
  PROPERTIES = ['x','y','topLength','leftLength','bottomLength','rightLength']

  Formattable.apply(Formattable,['Diamond'].concat PROPERTIES).attachTo Diamond
  Parameterizable('diamondFrom',{
    topLength: 1
    rightLength: 1
    bottomLength: 1
    leftLength: 1
    x: 0
    y: 0
    rotation: 0
  }).attachTo Diamond
  Sourcable('geomjs.Diamond',
            'topLength',
            'rightLength',
            'bottomLength',
            'leftLength',
            'x','y',
            'rotation'
  ).attachTo Diamond
  Equatable.apply(Equatable, PROPERTIES).attachTo Diamond
  Cloneable.attachTo Diamond
  Geometry.attachTo Diamond
  Memoizable.attachTo Diamond
  Surface.attachTo Diamond
  Path.attachTo Diamond
  Intersections.attachTo Diamond

  ##### Diamond::constructor
  #
  constructor: (topLength,
                rightLength,
                bottomLength,
                leftLength,
                x, y,
                rotation) ->

    args = @diamondFrom topLength,
                        rightLength,
                        bottomLength,
                        leftLength,
                        x, y,
                        rotation
    {
      @topLength,
      @rightLength,
      @bottomLength,
      @leftLength,
      @x, @y,
      @rotation
    } = args

  ##### Diamond::center
  #
  center: -> new Point(@x, @y)

  #### Axis

  ##### Diamond::topAxis
  #
  topAxis: -> new Point(0,-@topLength).rotate(@rotation)
  ##### Diamond::bottomAxis
  #
  bottomAxis: -> new Point(0,@bottomLength).rotate(@rotation)
  ##### Diamond::leftAxis
  #
  leftAxis: -> new Point(-@leftLength,0).rotate(@rotation)
  ##### Diamond::rightAxis
  #
  rightAxis: -> new Point(@rightLength,0).rotate(@rotation)

  #### Corners

  ##### Diamond::corners
  #
  corners: ->
    [
      @topCorner()
      @rightCorner()
      @bottomCorner()
      @leftCorner()
    ]

  ##### Diamond::topCorner
  #
  topCorner: -> @center().add(@topAxis())
  ##### Diamond::bottomCorner
  #
  bottomCorner: -> @center().add(@bottomAxis())
  ##### Diamond::leftCorner
  #
  leftCorner: -> @center().add(@leftAxis())
  ##### Diamond::rightCorner
  #
  rightCorner: -> @center().add(@rightAxis())

  #### Edges

  ##### Diamond::edges
  #
  edges: ->
    [
      @topLeftEdge()
      @topRightEdge()
      @bottomRightEdge()
      @bottomLeftEdge()
    ]

  ##### Diamond::topLeftEdge
  #
  topLeftEdge: -> @topCorner().subtract(@leftCorner())
  ##### Diamond::topRightEdge
  #
  topRightEdge: -> @rightCorner().subtract(@topCorner())
  ##### Diamond::bottomLeftEdge
  #
  bottomLeftEdge: -> @leftCorner().subtract(@bottomCorner())
  ##### Diamond::bottomRightEdge
  #
  bottomRightEdge: -> @bottomCorner().subtract(@rightCorner())

  #### Quadrants

  ##### Diamond::quadrants
  #
  quadrants: ->
    [
      @topLeftQuadrant()
      @topRightQuadrant()
      @bottomRightQuadrant()
      @bottomLeftQuadrant()
    ]

  ##### Diamond::topLeftQuadrant
  #
  topLeftQuadrant: ->
    k = 'topLeftQuadrant'
    return @memoFor k if @memoized k
    @memoize k, new Triangle(@center(),
                             @topCorner(),
                             @leftCorner())

  ##### Diamond::topRightQuadrant
  #
  topRightQuadrant: ->
    k = 'topRightQuadrant'
    return @memoFor k if @memoized k
    @memoize k, new Triangle(@center(),
                             @topCorner(),
                             @rightCorner())

  ##### Diamond::bottomLeftQuadrant
  #
  bottomLeftQuadrant: ->
    k = 'bottomLeftQuadrant'
    return @memoFor k if @memoized k
    @memoize k, new Triangle(@center(),
                             @bottomCorner(),
                             @leftCorner())

  ##### Diamond::bottomRightQuadrant
  #
  bottomRightQuadrant: ->
    k = 'bottomRightQuadrant'
    return @memoFor k if @memoized k
    @memoize k, new Triangle(@center(),
                             @bottomCorner(),
                             @rightCorner())

  #### Bounds

  ##### Diamond::top
  #
  top: -> Math.min @topCorner().y,
                   @bottomCorner().y,
                   @leftCorner().y,
                   @rightCorner().y,

  ##### Diamond::bottom
  #
  bottom: -> Math.max @topCorner().y,
                      @bottomCorner().y,
                      @leftCorner().y,
                      @rightCorner().y,

  ##### Diamond::left
  #
  left: -> Math.min @topCorner().x,
                    @bottomCorner().x,
                    @leftCorner().x,
                    @rightCorner().x,

  ##### Diamond::right
  #
  right: -> Math.max @topCorner().x,
                     @bottomCorner().x,
                     @leftCorner().x,
                     @rightCorner().x,

  ##### Diamond::bounds
  #
  # See
  # [Geometry.bounds](src_geomjs_mixins_geometry.html#geometrybounds)

  ##### Diamond::boundingBox
  #
  # See
  # [Geometry.boundingbox](src_geomjs_mixins_geometry.html#geometryboundingbox)

  #### Geometry API

  ##### Diamond::points
  #
  points: ->
    [t = @topCorner(), @rightCorner(), @bottomCorner(), @leftCorner(), t]

  ##### Diamond::closedGeometry
  #
  closedGeometry: -> true

  ##### Diamond::pointAtAngle
  #
  pointAtAngle: (angle) ->
    center = @center()
    vec = center.add Math.cos(Math.degToRad(angle))*10000,
                     Math.sin(Math.degToRad(angle))*10000
    @intersections(points: -> [center, vec])?[0]

  ##### Diamond::intersects
  #
  # See
  # [Intersections.intersects](src_geomjs_mixins_intersections.html#intersectionsintersects)

  ##### Diamond::intersections
  #
  # See
  # [Intersections.intersections](src_geomjs_mixins_intersections.html#intersectionsintersections)

  #### Surface API

  ##### Diamond::acreage
  #
  acreage: ->
    @topLeftQuadrant().acreage() +
    @topRightQuadrant().acreage() +
    @bottomLeftQuadrant().acreage() +
    @bottomRightQuadrant().acreage()

  ##### Diamond::contains
  #
  contains: (x,y) ->
    @center().equals(x,y) or
    @topLeftQuadrant().contains(x,y) or
    @topRightQuadrant().contains(x,y) or
    @bottomLeftQuadrant().contains(x,y) or
    @bottomRightQuadrant().contains(x,y)

  ##### Diamond::containsGeometry
  #
  # See
  # [Surface.containsgeometry](src_geomjs_mixins_surface.html#surfacecontainsgeometry)

  ##### Diamond::randomPointInSurface
  #
  randomPointInSurface: (random) ->
    l = @acreage()
    q1 = @topLeftQuadrant()
    q2 = @topRightQuadrant()
    q3 = @bottomRightQuadrant()
    q4 = @bottomLeftQuadrant()

    a1 = q1.acreage()
    a2 = q2.acreage()
    a3 = q3.acreage()
    a4 = q4.acreage()
    a = a1 + a2 + a3 + a4

    l1 = a1 / a
    l2 = a2 / a
    l3 = a3 / a
    l4 = a4 / a

    n = random.get()

    if n < l1
      q1.randomPointInSurface random
    else if n < l1 + l2
      q2.randomPointInSurface random
    else if n < l1 + l2 + l3
      q3.randomPointInSurface random
    else
      q4.randomPointInSurface random



  #### Path API

  ##### Diamond::length
  #
  length: ->
    @topRightEdge().length() +
    @topLeftEdge().length() +
    @bottomRightEdge().length() +
    @bottomLeftEdge().length()

  ##### Diamond::pathPointAt
  #
  pathPointAt: (n, pathBasedOnLength=true) ->
    [p1,p2,p3] = @pathSteps pathBasedOnLength

    if n < p1
      @topCorner().add @topRightEdge().scale Math.map n, 0, p1, 0, 1
    else if n < p2
      @rightCorner().add @bottomRightEdge().scale Math.map n, p1, p2, 0, 1
    else if n < p3
      @bottomCorner().add @bottomLeftEdge().scale Math.map n, p2, p3, 0, 1
    else
      @leftCorner().add @topLeftEdge().scale Math.map n, p3, 1, 0, 1

  ##### Diamond::pathOrientationAt
  #
  pathOrientationAt: (n, pathBasedOnLength=true) ->
    [p1,p2,p3] = @pathSteps pathBasedOnLength

    if n < p1
      p = @topRightEdge()
    else if n < p2
      p = @bottomRightEdge()
    else if n < p3
      p = @bottomLeftEdge().scale -1
    else
      p = @topLeftEdge().scale -1

    p.angle()

  ##### Diamond::pathTangentAt
  #
  # See
  # [Path.pathTangentAt](src_geomjs_mixins_geometry.html#pathpathTangentAt)

  ##### Rectangle::pathSteps
  #
  pathSteps: (pathBasedOnLength=true) ->
    if pathBasedOnLength
      l = @length()
      p1 = @topRightEdge().length() / l
      p2 = p1 + @bottomRightEdge().length() / l
      p3 = p2 + @bottomLeftEdge().length() / l
    else
      p1 = 1 / 4
      p2 = 1 / 2
      p3 = 3 / 4

    [p1, p2, p3]

  #### Drawing API

  ##### Diamond::stroke
  #
  # See
  # [Geometry.stroke](src_geomjs_mixins_geometry.html#geometrystroke)

  ##### Diamond::fill
  #
  # See
  # [Geometry.fill](src_geomjs_mixins_geometry.html#geometryfill)


  #### Memoization

  ##### Diamond::memoizationKey
  #
  memoizationKey: ->
    "#{@x};#{@y};#{@topLength};#{@bottomLength};#{@leftLength};#{@rightLength}"

  #### Utilities

  ##### Diamond::equals
  #
  # See
  # [Equatable.equals](src_geomjs_mixins_equatable.html#equatableequals)

  ##### Diamond::clone
  #
  # See
  # [Cloneable.clone](src_geomjs_mixins_cloneable.html#cloneableclone)

  ##### Diamond::toString
  #
  # See
  # [Formattable.toString](src_geomjs_mixins_formattable.html#formattabletostring)





module.exports = Diamond
