require '../../test_helper'

Rectangle = require '../../../lib/geomjs/rectangle'

describe 'Rectangle', ->
  beforeEach ->
    addRectangleMatchers this
    addPointMatchers this

  tests =
    'with four numbers':
      args: [1,2,3,4]
      acreage: 12
      length: 14
      test: [1,2,3,4,0]
    'with five numbers':
      args: [4,5,6,7,8]
      acreage: 42
      length: 26
      test: [4,5,6,7,8]
    'without arguments':
      args: []
      acreage: 0
      length: 0
      test: [0,0,0,0,0]
    'with another rectangle':
      args: [rectangle(1,2,3,4,5)]
      acreage: 12
      length: 14
      test: [1,2,3,4,5]
    'with a partial rectangle like object':
      args: [x:1,width:3,height:4]
      acreage: 12
      length: 14
      test: [1,0,3,4,0]

  describe 'when instanciated', ->
    tests.map (msg, o) ->
      {args, acreage, test, length} = o
      [x,y,width,height,rotation] = test

      describe "#{msg} #{args}", ->
        beforeEach ->
          @rectangle = rectangle.apply global, args
          @data = rectangleData.apply global, test

        source = 'rectangle'

        it 'should have been set with the provided values', ->
          expect(@rectangle).toBeRectangle(x, y, width, height, rotation)

        # Rectangle API
        testRotatedRectangle source, x, y, width, height, rotation

        describe 'its setCenter method', ->
          calledWithPoints(1,3,-5,2,5,-8,0,0)
            .where
              source: source
              method: 'setCenter'
            .should 'have moved the rectangle and returned it', (res, tx,ty) ->
              {x,y} = @data.topLeft
              center = @data.center
              [x,y] = [
                x + (tx - center.x)
                y + (ty - center.y)
              ]
              expect(@rectangle.topLeft()).toBePoint(x,y)
              expect(res).toBe(@rectangle)

        describe 'its rotateAroundCenter method', ->
          beforeEach ->
            @rotation = 10
            @result = @rectangle.rotateAroundCenter @rotation

          it 'should rotate the rectangle around its center', ->
            target = point(@data.topLeft).rotateAround(@data.center, @rotation)
            expect(@rectangle.topLeft()).toBeSamePoint(target)

          it 'should preserve the rectangle center', ->
            expect(@rectangle.center()).toBeSamePoint(@data.center)

          it 'should return the rectangle', ->
            expect(@result).toBe(@rectangle)

        describe 'its scaleAroundCenter method', ->
          beforeEach ->
            @scale = 2
            @result = @rectangle.scaleAroundCenter @scale

          it 'should scale the rectangle around its center', ->
            dif = point(@data.topLeft).subtract(@data.center)
            dif = dif.scale(@scale)
            target = point(@data.topLeft).add(dif.scale(0.5))
            expect(@rectangle.topLeft()).toBeSamePoint(target)
            expect(@rectangle.width).toBe(width * @scale)
            expect(@rectangle.height).toBe(height * @scale)

          it 'should preserve the rectangle center', ->
            expect(@rectangle.center()).toBeSamePoint(@data.center)

          it 'should return the rectangle', ->
            expect(@result).toBe(@rectangle)

        describe 'its inflateAroundCenter method', ->
          calledWithPoints(1,3,-5,2,5,-8,0,0)
            .where
              source: source
              method: 'inflateAroundCenter'
            .should 'have inflate the rectangle and returned it', (res,x,y)->
              expect(@rectangle.width).toBe(width + x)
              expect(@rectangle.height).toBe(height + y)
              expect(@rectangle.center()).toBeSamePoint(@data.center)
              expect(res).toBe(@rectangle)

        describe 'its inflate method', ->
          calledWithPoints(1,3,-5,2,5,-8,0,0)
            .where
              source: source
              method: 'inflate'
            .should 'have inflate the rectangle and returned it', (res,x,y) ->
              expect(@rectangle.width).toBe(width + x)
              expect(@rectangle.height).toBe(height + y)
              expect(@rectangle.topLeft()).toBeSamePoint(@data.topLeft)
              expect(res).toBe(@rectangle)

        describe 'its inflateTopLeft method', ->
          calledWithPoints(1,3,-5,2,5,-8,0,0)
            .where
              source: source
              method: 'inflateTopLeft'
            .should 'have inflate the rectangle and returned it', (res,x,y) ->
              topEdge = point(@rectangle.topEdge()).normalize(-x)
              leftEdge = point(@rectangle.leftEdge()).normalize(-y)

              expect(@rectangle.width).toBe(width + x)
              expect(@rectangle.height).toBe(height + y)
              expect(@rectangle.topLeft())
                .toBeSamePoint(point(@data.topLeft).add(topEdge).add(leftEdge))
              expect(res).toBe(@rectangle)

        describe 'its inflateTopRight method', ->
          calledWithPoints(1,3,-5,2,5,-8,0,0)
            .where
              source: source
              method: 'inflateTopRight'
            .should 'have inflate the rectangle and returned it', (res,x,y) ->
              leftEdge = point(@rectangle.leftEdge()).normalize(-y)

              expect(@rectangle.width).toBe(width + x)
              expect(@rectangle.height).toBe(height + y)
              expect(@rectangle.topLeft())
                .toBeSamePoint(point(@data.topLeft).add(leftEdge))
              expect(res).toBe(@rectangle)

        describe 'its inflateBottomLeft method', ->
          calledWithPoints(1,3,-5,2,5,-8,0,0)
            .where
              source: source
              method: 'inflateBottomLeft'
            .should 'have inflate the rectangle and returned it', (res,x,y) ->
              topEdge = point(@rectangle.topEdge()).normalize(-x)

              expect(@rectangle.width).toBe(width + x)
              expect(@rectangle.height).toBe(height + y)
              expect(@rectangle.topLeft())
                .toBeSamePoint(point(@data.topLeft).add(topEdge))
              expect(res).toBe(@rectangle)

        describe 'its inflateBottomRight method', ->
          calledWithPoints(1,3,-5,2,5,-8,0,0)
            .where
              source: source
              method: 'inflateBottomRight'
            .should 'have inflate the rectangle and returned it', (res,x,y) ->
              expect(@rectangle.width).toBe(width + x)
              expect(@rectangle.height).toBe(height + y)
              expect(@rectangle.topLeft()).toBeSamePoint(@data.topLeft)
              expect(res).toBe(@rectangle)


        describe 'its inflateLeft method called', ->
          beforeEach ->
            @inflate = 2
            @result = @rectangle.inflateLeft @inflate

          it 'should inflate the rectangle to the left', ->
            @expect(@rectangle.width).toBe(width + @inflate)
            @expect(@rectangle.height).toBe(height)
            topEdge = point(@rectangle.topEdge()).normalize(-@inflate)
            @expect(@rectangle.topLeft())
              .toBeSamePoint(point(@data.topLeft).add(topEdge))

          it 'should return the rectangle', ->
            expect(@result).toBe(@rectangle)

        describe 'its inflateRight method called', ->
          beforeEach ->
            @inflate = 2
            @result = @rectangle.inflateRight @inflate

          it 'should inflate the rectangle to the right', ->
            @expect(@rectangle.width).toBe(width + @inflate)
            @expect(@rectangle.height).toBe(height)
            @expect(@rectangle.topLeft()).toBeSamePoint(@data.topLeft)

          it 'should return the rectangle', ->
            expect(@result).toBe(@rectangle)

        describe 'its inflateTop method called', ->
          beforeEach ->
            @inflate = 2
            @result = @rectangle.inflateTop @inflate

          it 'should inflate the rectangle to the top', ->
            @expect(@rectangle.width).toBe(width)
            @expect(@rectangle.height).toBe(height + @inflate)
            leftEdge = point(@rectangle.leftEdge()).normalize(-@inflate)
            @expect(@rectangle.topLeft())
              .toBeSamePoint(point(@data.topLeft).add(leftEdge))

          it 'should return the rectangle', ->
            expect(@result).toBe(@rectangle)

        describe 'its inflateBottom method called', ->
          beforeEach ->
            @inflate = 2
            @result = @rectangle.inflateBottom @inflate

          it 'should inflate the rectangle to the bottom', ->
            @expect(@rectangle.width).toBe(width)
            @expect(@rectangle.height).toBe(height + @inflate)
            @expect(@rectangle.topLeft()).toBeSamePoint(@data.topLeft)

          it 'should return the rectangle', ->
            expect(@result).toBe(@rectangle)

        # Surface API
        acreageOf(source).shouldBe(acreage)

        # Path API
        lengthOf(source).shouldBe(length)

        # Geometry API
        shouldBeClosedGeometry(source)

        # Drawing API
        testDrawingOf(source)

    tests.map (msg, o) ->
      {args, test} = o
      [x,y,width,height,rotation] = test

      describe "::paste called with #{msg} #{args}", ->
        it 'should copy the passed-in data in the rectangle', ->
          rect = rectangle()
          rect.paste.apply rect, args
          expect(rect).toBeRectangle(x,y,width,height,rotation)

      describe "::equals called", ->
        it 'should return true when rectangles are equals', ->
          rect1 = rectangle.apply global, args
          rect2 = rectangle.apply global, args
          expect(rect1.equals rect2).toBeTruthy()

        it 'should return false when rectangles are different', ->
          rect1 = rectangle.apply global, args
          rect2 = rectangle -1, -1, 10, 10, 100
          expect(rect1.equals rect2).toBeFalsy()

        it 'should return false when passed null', ->
          rect = rectangle.apply global, args
          expect(rect.equals null).toBeFalsy()

      describe '::points called', ->
        it 'should returns an array with the corners of the rectangle', ->
          rect = rectangle.apply global, args
          data = rectangleData.apply global, test

          points = rect.points()
          testPoints = [
            data.topLeft
            data.topRight
            data.bottomRight
            data.bottomLeft
            data.topLeft
          ]

          expect(points.length).toBe(5)
          points.forEach (pt, i) -> expect(pt).toBeSamePoint(testPoints[i])

  describe '::clone called', ->
    it 'should the copy of the rectangle', ->
      expect(rectangle(4,5,6,7,8).clone()).toBeRectangle(4,5,6,7,8)
