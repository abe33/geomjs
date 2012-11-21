require '../../test_helper'

CubicBezier = require '../../../lib/geomjs/cubic_bezier'

describe 'CubicBezier', ->
  describe 'when called with four vertices', ->
    beforeEach ->
      @curve = new CubicBezier([
        point(0,0)
        point(4,0)
        point(4,4)
        point(0,4)
      ], 20)

    it 'should exist', ->
      expect(@curve).toBeDefined()

    describe 'its points method', ->
      it 'should return as many points as its bias plus one', ->
        expect(@curve.points().length).toBe(@curve.bias + 1)
