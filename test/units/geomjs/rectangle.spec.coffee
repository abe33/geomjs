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

      pointOf('rectangle', 'topLeft').shouldBe(1,2)
      pointOf('rectangle', 'topRight').shouldBe(4,2)
      pointOf('rectangle', 'bottomLeft').shouldBe(1,6)
      pointOf('rectangle', 'bottomRight').shouldBe(4,6)

      pointOf('rectangle', 'topEdge').shouldBe(3,0)
      pointOf('rectangle', 'bottomEdge').shouldBe(-3,0)
      pointOf('rectangle', 'leftEdge').shouldBe(0,-4)
      pointOf('rectangle', 'rightEdge').shouldBe(0,4)
