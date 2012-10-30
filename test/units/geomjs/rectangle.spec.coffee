require '../../test_helper'

Rectangle = require '../../../lib/geomjs/rectangle'

describe 'Rectangle', ->
  beforeEach ->
    addRectangleMatchers this

  describe 'when instanciated', ->
    describe 'with four numbers 1, 2, 3, 4', ->
      beforeEach ->
        @rectangle = rectangle 1, 2, 3, 4

      it 'should create an instance with the provided values', ->
        expect(@rectangle).toBeRectangle(1,2,3,4)

      acreageOf('rectangle').shouldBe(12)

      testRotatedRectangle 'rectangle', 1, 2, 3, 4, 0

    describe 'with five numbers 1, 2, 3, 4, 5', ->
      describe 'where the last arguments is a rotation of 5°', ->
        beforeEach ->
          @rectangle = rectangle 1, 2, 3, 4, 5

        it 'should create an instance with the provided values', ->
          expect(@rectangle).toBeRectangle(1,2,3,4)

        acreageOf('rectangle').shouldBe(12)

        testRotatedRectangle 'rectangle', 1, 2, 3, 4, 5

    describe 'without arguments', ->
      beforeEach ->
        @rectangle = rectangle()

      it 'should create an instance with the provided values', ->
        expect(@rectangle).toBeRectangle(0,0,0,0)

      acreageOf('rectangle').shouldBe(0)

      testRotatedRectangle 'rectangle', 0, 0, 0, 0, 0

