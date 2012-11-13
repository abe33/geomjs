# @toc
Point = require './point'
Triangle = require './triangle'
Equatable = require './mixins/equatable'
Formattable = require './mixins/formattable'
Cloneable = require './mixins/cloneable'
Parameterizable = require './mixins/parameterizable'
Geometry = require './mixins/geometry'
Surface = require './mixins/surface'
Path = require './mixins/path'
Intersections = require './mixins/intersections'

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
  Equatable.apply(Equatable, PROPERTIES).attachTo Diamond
  Cloneable.attachTo Diamond
  Geometry.attachTo Diamond
  # Surface.attachTo Diamond
  # Path.attachTo Diamond
  # Intersections.attachTo Diamond

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

  center: -> new Point(@x, @y)

  topAxis: -> new Point(0,-@topLength).rotate(@rotation)
  bottomAxis: -> new Point(0,@bottomLength).rotate(@rotation)
  leftAxis: -> new Point(-@leftLength,0).rotate(@rotation)
  rightAxis: -> new Point(@rightLength,0).rotate(@rotation)

  topCorner: -> @center().add(@topAxis())
  bottomCorner: -> @center().add(@bottomAxis())
  leftCorner: -> @center().add(@leftAxis())
  rightCorner: -> @center().add(@rightAxis())

  topLeftEdge: -> @topCorner().subtract(@leftCorner())
  topRightEdge: -> @rightCorner().subtract(@topCorner())
  bottomLeftEdge: -> @leftCorner().subtract(@bottomCorner())
  bottomRightEdge: -> @bottomCorner().subtract(@rightCorner())

  topLeftQuadrant: -> new Triangle(@center(),
                                   @topCorner(),
                                   @leftCorner())

  topRightQuadrant: -> new Triangle(@center(),
                                    @topCorner(),
                                    @rightCorner())

  bottomLeftQuadrant: -> new Triangle(@center(),
                                      @bottomCorner(),
                                      @leftCorner())

  bottomRightQuadrant: -> new Triangle(@center(),
                                       @bottomCorner(),
                                       @rightCorner())

  points: ->
    [t = @topCorner(), @rightCorner(), @bottomCorner(), @leftCorner(), t]

  closedGeometry: -> true

  length: ->
    @topRightEdge().length() +
    @topLeftEdge().length() +
    @bottomRightEdge().length() +
    @bottomLeftEdge().length()

  acreage: ->
    @topLeftQuadrant().acreage() +
    @topRightQuadrant().acreage() +
    @bottomLeftQuadrant().acreage() +
    @bottomRightQuadrant().acreage()





module.exports = Diamond
