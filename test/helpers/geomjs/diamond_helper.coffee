
Diamond = require '../../../lib/geomjs/diamond'

global.addDiamondMatchers = (scope) ->
  scope.addMatchers
    toBeDiamond: (topLength,
                  rightLength,
                  bottomLength,
                  leftLength,
                  x,
                  y,
                  rotation) ->
      @message = ->
        notText = if @isNot then ' not' else ''
        "Expected #{@actual}#{notText} to be a diamond with
        leftLength=#{leftLength}, rightLength=#{rightLength}, topLength=#{topLength}, bottomLength=#{bottomLength},
        x=#{x}, y=#{y}, rotation=#{rotation}".squeeze()

      @actual.leftLength is leftLength and
      @actual.topLength is topLength and
      @actual.rightLength is rightLength and
      @actual.bottomLength is bottomLength and
      @actual.x is x and
      @actual.y is y and
      @actual.rotation is rotation

global.diamond = (topLength,
                  rightLength,
                  bottomLength,
                  leftLength,
                  x,
                  y,
                  rotation) ->

  new Diamond topLength, rightLength, bottomLength, leftLength, x, y, rotation

global.diamondData = (topLength,
                      rightLength,
                      bottomLength,
                      leftLength,
                      x,
                      y,
                      rotation) ->

  center = point(x,y)
  topVec = point(0,-topLength).rotate(rotation)
  bottomVec = point(0,bottomLength).rotate(rotation)
  leftVec = point(-leftLength,0).rotate(rotation)
  rightVec = point(rightLength,0).rotate(rotation)

  data = {topLength, rightLength, bottomLength, leftLength, x, y, rotation}

  data.merge
    center: center
    topCorner: center.add(topVec)
    bottomCorner: center.add(bottomVec)
    leftCorner: center.add(leftVec)
    rightCorner: center.add(rightVec)

  data.merge
    topLeftEdge: data.topCorner.subtract data.leftCorner
    topRightEdge: data.rightCorner.subtract data.topCorner
    bottomRightEdge: data.bottomCorner.subtract data.rightCorner
    bottomLeftEdge: data.leftCorner.subtract data.bottomCorner

  data.merge
    topLeftQuadrant: triangle(data.center,
                              data.topCorner,
                              data.leftCorner)
    topRightQuadrant: triangle(data.center,
                               data.topCorner,
                               data.rightCorner)
    bottomLeftQuadrant: triangle(data.center,
                                 data.bottomCorner,
                                 data.leftCorner)
    bottomRightQuadrant: triangle(data.center,
                                  data.bottomCorner,
                                  data.rightCorner)

  data.merge
    length: data.topLeftEdge.length() +
            data.topRightEdge.length() +
            data.bottomLeftEdge.length() +
            data.bottomRightEdge.length()
    acreage: data.topLeftQuadrant.acreage() +
             data.topRightQuadrant.acreage() +
             data.bottomLeftQuadrant.acreage() +
             data.bottomRightQuadrant.acreage()
    top: Math.min(data.topCorner.y,
                  data.leftCorner.y,
                  data.rightCorner.y,
                  data.bottomCorner.y)
    bottom: Math.max(data.topCorner.y,
                     data.leftCorner.y,
                     data.rightCorner.y,
                     data.bottomCorner.y)
    left: Math.min(data.topCorner.x,
                   data.leftCorner.x,
                   data.rightCorner.x,
                   data.bottomCorner.x)
    right: Math.max(data.topCorner.x,
                    data.leftCorner.x,
                    data.rightCorner.x,
                    data.bottomCorner.x)

  data.merge
    bounds:
      top: data.top
      bottom: data.bottom
      left: data.left
      right: data.right

  data

global.diamondFactories =
  'with all properties':
    args: [1,2,3,4,5,6,7]
    test: [1,2,3,4,5,6,7]
  'without rotation':
    args: [1,2,3,4,5,6]
    test: [1,2,3,4,5,6,0]
  'without neither position nor rotation':
    args: [1,2,3,4]
    test: [1,2,3,4,0,0,0]
  'with an object with all properties':
    args: [{
      topLength:1,
      rightLength:2,
      bottomLength:3,
      leftLength:4,
      x:5,
      y:6,
      rotation:7
    }]
    test: [1,2,3,4,5,6,7]
  'with a partial object':
    args: [{topLength:1,rightLength:2,x:5}]
    test: [1,2,1,1,5,0,0]





