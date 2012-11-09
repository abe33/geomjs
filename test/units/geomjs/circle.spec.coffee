require '../../test_helper'

describe 'Circle', ->
  beforeEach ->
    addPointMatchers this
    addRectangleMatchers this
    addCircleMatchers this

  circleFactories.map (k,v) ->
    {args, test} = v
    [radius, x, y] = test
    data = circleData.apply global, test

    describe "when instanciated with #{args}", ->
      beforeEach ->
        @circle = circle.apply global, args

      it 'should exist', ->
        expect(@circle).toBeDefined()

      it 'should have defined the ad hoc properties', ->
        expect(@circle).toBeCircle(radius, x, y)

