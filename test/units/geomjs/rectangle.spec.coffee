require '../../test_helper'

Rectangle = require '../../../lib/geomjs/rectangle'

describe 'Rectangle', ->
  beforeEach ->
    addRectangleMatchers this

  describe 'when instanciated', ->
    describe 'with four numbers', ->
      it 'should create an instance with the provided values', ->
        rect = rectangle 1, 2, 3, 4
        expect(rect).toBeRectangle(1,2,3,4)
