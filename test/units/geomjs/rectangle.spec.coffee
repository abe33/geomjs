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

