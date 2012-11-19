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

    describe "when instanciated with #{k} #{args}", ->
      beforeEach ->
        @circle = circle.apply global, args

      it 'should exist', ->
        expect(@circle).toBeDefined()

      it 'should have defined the ad hoc properties', ->
        expect(@circle).toBeCircle(radius, x, y, segments)

      describe 'its center method', ->
        it 'should return the circle coordinates', ->
          expect(@circle.center()).toBePoint(@circle.x, @circle.y)
      # Path API
      lengthOf(source).shouldBe(data.length)

      describe 'its pathPointAt method', ->
        describe 'called with 0', ->
          it "should return #{data.right},#{data.y}", ->
            expect(@circle.pathPointAt 0).toBePoint(data.right, data.y)

        describe 'called with 1', ->
          it "should return #{data.right},#{data.y}", ->
            expect(@circle.pathPointAt 1).toBePoint(data.right, data.y)

        describe 'called with 0.25', ->
          it "should return #{data.x},#{data.bottom}", ->
            expect(@circle.pathPointAt 0.25).toBePoint(data.x, data.bottom)

        describe 'called with 0.5', ->
          it "should return #{data.left},#{data.y}", ->
            expect(@circle.pathPointAt 0.5).toBePoint(data.left, data.y)

        describe 'called with 0.75', ->
          it "should return #{data.x},#{data.top}", ->
            expect(@circle.pathPointAt 0.75).toBePoint(data.x, data.top)

      describe 'its pathOrientationAt method', ->
        describe 'called with 0', ->
          it 'should return 90', ->
            expect(@circle.pathOrientationAt 0).toBe(90)

        describe 'called with 1', ->
          it 'should return 90', ->
            expect(@circle.pathOrientationAt 1).toBe(90)

        describe 'called with 0.25', ->
          it 'should return 180', ->
            expect(@circle.pathOrientationAt 0.25).toBe(180)

        describe 'called with 0.5', ->
          it 'should return -90', ->
            expect(@circle.pathOrientationAt 0.5).toBe(-90)

        describe 'called with 0.75', ->
          it 'should return 0', ->
            expect(@circle.pathOrientationAt 0.75).toBe(0)

      # Surface API
      acreageOf(source).shouldBe(data.acreage)

      describe 'its contains method', ->
        calledWithPoints(data.x, data.y)
        .where
          source: source
          method: 'contains'
        .should 'return true', (res) ->
          expect(res).toBeTruthy()

        calledWithPoints(-100, -100)
        .where
          source: source
          method: 'contains'
        .should 'return false', (res) ->
          expect(res).toBeFalsy()

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

      shouldBeClosedGeometry(source)

      # Drawing API
      testDrawingOf(source)

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

      describe 'its clone method', ->
        it 'should return a copy of this circle', ->
          expect(@circle.clone())
          .toBeCircle(
            @circle.radius,
            @circle.x,
            @circle.y,
            @circle.segments)




