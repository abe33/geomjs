require '../../test_helper'

Rectangle = require '../../../lib/geomjs/rectangle'

describe 'Rectangle', ->
  beforeEach ->
    addRectangleMatchers this
    addPointMatchers this

  describe 'when instanciated', ->
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

    tests.map (msg, o) ->
      {args, acreage, test, length} = o
      [x,y,width,height,rotation] = test

      describe "#{msg} #{args}", ->
        beforeEach ->
          @rectangle = rectangle.apply global, args
          @data = rectangleData.apply global, args

        source = 'rectangle'

        it 'should have been set with the provided values', ->
          expect(@rectangle).toBeRectangle(x, y, width, height, rotation)

        # Rectangle API
        testRotatedRectangle source, x, y, width, height, rotation

        describe 'its setCenter method', ->
          calledWithPoint(10, 20)
            .where
              source: source
              method: 'setCenter'
            .should 'have moved the rectangle and returned it', (res) ->
              {x,y} = @data.topLeft
              center = @data.center
              [x,y] = [
                x + (10 - center.x)
                y + (20 - center.y)
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
          calledWithPoint(2, 4)
            .where
              source: source
              method: 'inflateAroundCenter'
            .should 'have inflate the rectangle and returned it', (res) ->
              expect(@rectangle.width).toBe(width + 2)
              expect(@rectangle.height).toBe(height + 4)
              expect(@rectangle.center()).toBeSamePoint(@data.center)
              expect(res).toBe(@rectangle)

        describe 'its inflate method', ->
          calledWithPoint(2, 4)
            .where
              source: source
              method: 'inflate'
            .should 'have inflate the rectangle and returned it', (res) ->
              expect(@rectangle.width).toBe(width + 2)
              expect(@rectangle.height).toBe(height + 4)
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

        # Drawing API
        testDrawingOf(source)

