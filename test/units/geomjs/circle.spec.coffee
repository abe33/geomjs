require '../../test_helper'

describe 'Circle', ->
  beforeEach ->
    addPointMatchers this
    addRectangleMatchers this
    addCircleMatchers this

  circleFactories.map (k,v) ->
    {args, test} = v
    [radius, x, y, segments] = test
    source = 'circle'
    data = circleData.apply global, test

    describe "when instanciated with #{args}", ->
      beforeEach ->
        @circle = circle.apply global, args

      it 'should exist', ->
        expect(@circle).toBeDefined()

      it 'should have defined the ad hoc properties', ->
        expect(@circle).toBeCircle(radius, x, y, segments)

      # Path API
      lengthOf(source).shouldBe(data.length)

      # Surface API
      acreageOf(source).shouldBe(data.acreage)

      # Geometry API
      describe 'its top method', ->
        it 'should returns the circle top', ->
          expect(@circle.top()).toEqual(data.top)

      describe 'its bottom method', ->
        it 'should returns the circle bottom', ->
          expect(@circle.bottom()).toEqual(data.bottom)

      describe 'its left method', ->
        it 'should returns the circle left', ->
          expect(@circle.left()).toEqual(data.left)

      describe 'its right method', ->
        it 'should returns the circle right', ->
          expect(@circle.right()).toEqual(data.right)

      describe 'its bounds method', ->
        it 'should returns the circle bounds', ->
          expect(@circle.bounds()).toEqual(data.bounds)

      # Others
      describe 'its equals method', ->
        describe 'when called with an object equal to the current circle', ->
          it 'should return true', ->
            target = circle.apply global, args
            expect(@circle.equals target).toBeTruthy()

        describe 'when called with an object different than the circle', ->
          it 'should return false', ->
            target = circle 5, 1, 3
            expect(@circle.equals target).toBeFalsy()

