
Ellipsis = require '../../../lib/geomjs/ellipsis'

DEFAULT_SEGMENTS = 36

global.addEllipsisMatchers = (scope) ->
  scope.addMatchers
    toBeEllipsis: (r1, r2, x, y, rotation, segments) ->
      @message = ->
        notText = if @isNot then ' not' else ''
        "Expected #{@actual}#{notText} to be an ellipsis with
        radius1=#{r1}, radius2=#{r2}, x=#{x}, y=#{y}, rotation=#{rotation},
        segments=#{segments}".squeeze()

      @actual.radius1 is r1 and
      @actual.radius2 is r2 and
      @actual.x is x and
      @actual.y is y and
      @actual.rotation is rotation and
      @actual.segments is segments

global.ellipsis = (r1, r2, x, y, rotation, segments) ->
  new Ellipsis r1, r2, x, y, rotation, segments

global.ellipsisData= (radius1, radius2, x, y, rotation, segments) ->
  data = {radius1, radius2, x, y, rotation, segments}

  data.merge
    acreage: Math.PI * radius1 * radius2
    length: Math.PI * (3*(radius1 + radius2) -
            Math.sqrt((3* radius1 + radius2) * (radius1 + radius2 *3)))

  a = radius1
  b = radius2
  phi = Math.degToRad rotation
  t1 = Math.atan(-b * Math.tan(phi) / a)
  t2 = Math.atan(b * Math.cos(phi) / a)
  data.merge
    left: x + a*Math.cos(t1+Math.PI)*Math.cos(phi) -
              b*Math.sin(t1+Math.PI)*Math.sin(phi)
    right: x + a*Math.cos(t1)*Math.cos(phi) -
               b*Math.sin(t1)*Math.sin(phi)
    bottom: y + a*Math.sin(t2)*Math.cos(phi) +
                b*Math.cos(t2)*Math.sin(phi)
    top: y + a*Math.sin(t2+Math.PI)*Math.cos(phi) +
             b*Math.cos(t2+Math.PI)*Math.sin(phi)

  data.merge
    bounds:
      top: data.top
      bottom: data.bottom
      left: data.left
      right: data.right

  data

global.ellipsisFactories =
  'with four numbers':
    args: [1,2,3,4]
    test: [1,2,3,4,0,DEFAULT_SEGMENTS]
  'with five numbers':
    args: [1,2,3,4,5]
    test: [1,2,3,4,5,DEFAULT_SEGMENTS]
  'with six numbers':
    args: [1,2,3,4,5,60]
    test: [1,2,3,4,5,60]
  'without arguments':
    args: []
    test: [1,1,0,0,0,DEFAULT_SEGMENTS]
  'with an ellipsis without rotation or segments':
    args: [{radius1: 1, radius2: 2, x: 3, y: 4}]
    test: [1,2,3,4,0,DEFAULT_SEGMENTS]
  'with an ellipsis without segments':
    args: [{radius1: 1, radius2: 2, x: 3, y: 4, rotation: 5}]
    test: [1,2,3,4,5,DEFAULT_SEGMENTS]
  'with an ellipsis':
    args: [{radius1: 1, radius2: 2, x: 3, y: 4, rotation: 5, segments: 60}]
    test: [1,2,3,4,5,60]


