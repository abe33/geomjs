require '../../test_helper'

Rectangle = require '../../../lib/geomjs/rectangle'

describe 'Rectangle', ->
  beforeEach ->
    addRectangleMatchers this

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

        it 'should create an instance with the provided values', ->
          expect(@rectangle).toBeRectangle(x, y, width, height, rotation)

        testRotatedRectangle 'rectangle', x, y, width, height, rotation

        # Surface API
        acreageOf('rectangle').shouldBe(acreage)

        # Path API
        lengthOf('rectangle').shouldBe(length)

        # Drawing API
        testDrawingOf('rectangle')

