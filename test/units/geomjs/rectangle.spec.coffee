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
        test: [1,2,3,4,0]
      'with five numbers':
        args: [4,5,6,7,8]
        acreage: 42
        test: [4,5,6,7,8]
      'without arguments':
        args: []
        acreage: 0
        test: [0,0,0,0,0]

    tests.map (msg, o) ->
      {args, acreage, test} = o
      [x,y,width,height,rotation] = test

      describe "#{msg} #{args}", ->
        beforeEach ->
          @rectangle = rectangle.apply global, args

        it 'should create an instance with the provided values', ->
          expect(@rectangle).toBeRectangle(x, y, width, height)

        acreageOf('rectangle').shouldBe(acreage)
        testRotatedRectangle 'rectangle', x, y, width, height, rotation
