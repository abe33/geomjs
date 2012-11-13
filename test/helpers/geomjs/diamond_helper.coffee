
Diamond = require '../../../lib/geomjs/diamond'

global.addDiamondMatchers = (scope) ->
  scope.addMatchers
    toBeDiamond: (top, right, bottom, left, x, y, rotation) ->

      @message = ->
        notText = if @isNot then ' not' else ''
        "Expected #{@actual}#{notText} to be a diamond with
        left=#{left}, right=#{right}, top=#{top}, bottom=#{bottom},
        x=#{x}, y=#{y}, rotation=#{rotation}".squeeze()

      @actual.left is left and
      @actual.top is top and
      @actual.right is right and
      @actual.bottom is bottom and
      @actual.x is x and
      @actual.y is y and
      @actual.rotation is rotation

global.diamond = (top, right, bottom, left, x, y, rotation) ->
  new Diamond top, right, bottom, left, x, y, rotation

global.diamondData = (top, right, bottom, left, x, y, rotation) ->

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
    args: [{top:1,right:2,bottom:3,left:4,x:5,y:6,rotation:7}]
    test: [1,2,3,4,5,6,7]
  'with a partial object':
    args: [{top:1,right:2,x:5}]
    test: [1,2,1,1,5,0,0]



