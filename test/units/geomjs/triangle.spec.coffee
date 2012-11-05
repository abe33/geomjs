require '../../test_helper'

describe 'Triangle', ->
  beforeEach ->
    addPointMatchers this
    addRectangleMatchers this

  factories = [
    triangle
    triangle.equilateral
    triangle.isosceles
    triangle.rectangle
    triangle.withPointLike
  ]
  dataFactories = [
    triangleData
    triangleData.equilateral
    triangleData.isosceles
    triangleData.rectangle
    triangleData
  ]

  factories.forEach (factory, i) ->
    data = dataFactories[i]()
    source = 'triangle'

    describe 'when instanciated with three valid points', ->
      beforeEach ->
        @triangle = factory()

      it 'should create a valid triangle instance', ->
        expect(@triangle).toBeDefined()

      ['a','b','c'].forEach (k) ->
        describe "its '#{k}' property", ->
          it "should have been filled with #{data[k]}", ->
            expect(@triangle[k]).toBeSamePoint(data[k])

      [
        'ab','ac','ba', 'bc', 'ca', 'cb',
        'abCenter', 'acCenter', 'bcCenter'
      ].forEach (k) ->
        describe "its '#{k}' method", ->
          it "should return #{data[k]}", ->
            expect(@triangle[k]()).toBeSamePoint(data[k])

      ['abc', 'bac', 'acb'].forEach (k) ->
        describe "its '#{k}' method", ->
          it "should return #{data[k]}", ->
            expect(@triangle[k]()).toBeClose(data[k])

      describe 'its center method', ->
        it 'should return the triangle center', ->
          expect(@triangle.center()).toBeSamePoint(data.center)

      describe 'its rotateAroundCenter method', ->
        beforeEach ->
          @rotation = 10
          @result = @triangle.rotateAroundCenter @rotation

        it 'should rotate the triangle around its center', ->
          a = data.a.rotateAround(data.center, @rotation)
          b = data.b.rotateAround(data.center, @rotation)
          c = data.c.rotateAround(data.center, @rotation)

          expect(@triangle.a).toBeSamePoint(a)
          expect(@triangle.b).toBeSamePoint(b)
          expect(@triangle.c).toBeSamePoint(c)

        it 'should preserve the triangle center', ->
          expect(@triangle.center()).toBeSamePoint(data.center)

        it 'should return the triangle', ->
          expect(@result).toBe(@triangle)

      describe 'its scaleAroundCenter method', ->
        beforeEach ->
          @scale = 2
          @result = @triangle.scaleAroundCenter @scale

        it 'should rotate the triangle around its center', ->
          center = point(data.center)
          a = center.add data.a.subtract(center).scale(@scale)
          b = center.add data.b.subtract(center).scale(@scale)
          c = center.add data.c.subtract(center).scale(@scale)

          expect(@triangle.a).toBeSamePoint(a)
          expect(@triangle.b).toBeSamePoint(b)
          expect(@triangle.c).toBeSamePoint(c)

        it 'should preserve the triangle center', ->
          expect(@triangle.center()).toBeSamePoint(data.center)

        it 'should return the triangle', ->
          expect(@result).toBe(@triangle)

      # Drawing API
      testDrawingOf(source)


      # Surface API
      acreageOf(source).shouldBe(data.acreage)

      calledWithPoints(data.center.x, data.center.y)
        .where
          source: source
          method: 'contains'
        .should 'return true for points inside the triangle', (res) ->
          expect(res).toBeTruthy()

      calledWithPoints(100,100)
        .where
          source: source
          method: 'contains'
        .should 'return false for points outside the triangle', (res) ->
          expect(res).toBeFalsy()

      # Path API
      lengthOf(source).shouldBe(data.length)

      describe 'its pathPointAt method', ->
        describe 'called with 0', ->
          it 'should return a', ->
            expect(@triangle.pathPointAt 0).toBeSamePoint(@triangle.a)

        describe 'called with 1', ->
          it 'should return a', ->
            expect(@triangle.pathPointAt 1).toBeSamePoint(@triangle.a)

        describe 'called with 1/3 and false', ->
          it 'should return b', ->
            expect(@triangle.pathPointAt 1 / 3, false)
              .toBeSamePoint(@triangle.b)

        describe 'called with 2/3 and false', ->
          it 'should return c', ->
            expect(@triangle.pathPointAt 2 / 3, false)
              .toBeSamePoint(@triangle.c)

      describe 'its pathOrientationAt method', ->
        describe 'called with 0', ->
          it 'should return ab angle', ->
            expect(@triangle.pathOrientationAt 0)
              .toBeClose(data.ab.angle())

        describe 'called with 1', ->
          it 'should return ca angle', ->
            expect(@triangle.pathOrientationAt 1)
              .toBeClose(data.ca.angle())

        describe 'called with 1/3 and false', ->
          it 'should return bc angle', ->
            expect(@triangle.pathOrientationAt 1 / 3, false)
              .toBeClose(data.bc.angle())

        describe 'called with 2/3 and false', ->
          it 'should return ca angle', ->
            expect(@triangle.pathOrientationAt 2 / 3, false)
              .toBeClose(data.ca.angle())

      # Geometry API
      describe 'its points method', ->
        it 'should return four points', ->
          points = @triangle.points()
          expect(points.length).toBe(4)
          expect(points[0]).toBeSamePoint(data.a)
          expect(points[1]).toBeSamePoint(data.b)
          expect(points[2]).toBeSamePoint(data.c)
          expect(points[3]).toBeSamePoint(data.a)

      shouldBeClosedGeometry(source)

      ['top', 'left', 'bottom', 'right'].forEach (k) ->
        describe "its #{k} method", ->
          it "should return #{data[k]}", ->
            expect(@triangle[k]()).toBe(data[k])


      describe 'its bounds method', ->
        it 'should return the bounds of the triangle', ->
          expect(@triangle.bounds()).toEqual(data.bounds)

      describe 'its boundingBox method', ->
        it 'should return the bounds of the triangle', ->
          expect(@triangle.boundingBox())
            .toBeRectangle(data.left,
                           data.top,
                           data.right - data.left
                           data.bottom - data.top)

  describe 'when instanciated with at least an invalid point', ->
    it 'should throw an error', ->
      expect(-> triangle point(4,5), point(5,7), 'notAPoint').toThrow()
