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
            .should 'have moved the rectangle', ->
              {x,y} = @data.topLeft
              center = @data.center
              [x,y] = [
                x + (10 - center.x)
                y + (20 - center.y)
              ]
              expect(@rectangle.topLeft()).toBePoint(x,y)

        # Surface API
        acreageOf(source).shouldBe(acreage)

        # Path API
        lengthOf(source).shouldBe(length)

        # Drawing API
        testDrawingOf(source)

