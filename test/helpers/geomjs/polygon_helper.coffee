
Polygon = require '../../../lib/geomjs/polygon'

global.polygon = (vertices) -> new Polygon vertices

global.polygonData = (vertices) ->
  data = {vertices}

  data.merge
    source: "new geomjs.Polygon([#{vertices.map (pt) -> pt.toSource()}])"

  data

global.polygonFactories =
  'with four points in an array':
    args: -> [[point(0,0), point(4,0), point(4,4), point(0,4)]]
    test: -> [point(0,0), point(4,0), point(4,4), point(0,4)]
  'with an object containing vertices':
    args: -> [vertices: [point(0,0), point(4,0), point(4,4), point(0,4)]]
    test: -> [point(0,0), point(4,0), point(4,4), point(0,4)]
