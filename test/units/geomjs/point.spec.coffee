require '../../test_helper'

Point = require '../../../lib/geomjs/point'

describe 'Point', ->
  beforeEach -> addPointMatchers this

  describe 'after being instanciated', ->
    describe 'with two numbers as arguments', ->
      it 'should create the new instance', ->
        expect(new Point 3, 8).toBePoint(3, 8)

    describe 'with two strings as arguments', ->
      it 'should create the new instance', ->
        expect(new Point '3', '8').toBePoint(3, 8)

    describe 'with no arguments', ->
      it 'should create the new instance with default coordinates of 0', ->
        expect(new Point).toBePoint()

    describe 'with another point-like object as argument', ->
      it 'should create the new instance with the values of the object', ->
        expect(new Point x: 10, y: 23).toBePoint(10, 23)

    describe 'with an incomplete point-like object as argument', ->
      it 'should create the new instance with the value of the object', ->
        expect(new Point x: 10).toBePoint(10, 0)


  describe '::add called', ->
    describe 'with another point-like object', ->
      it 'should return a new point corresponding to the addition product', ->
        expect(new Point().add x: 10, y: 20).toBePoint(10, 20)
        expect(new Point().add x: '10', y: '20').toBePoint(10, 20)

    describe 'with two numbers as arguments', ->
      it 'should return a new point corresponding to the addition product', ->
        expect(new Point().add 3, 8).toBePoint(3, 8)

    describe 'with two string as arguments', ->
      it 'should return a new point corresponding to the addition product', ->
        expect(new Point().add '10', '20').toBePoint(10, 20)

    describe 'with no argument', ->
      it 'should return a new point equal to the source', ->
        expect(new Point().add()).toBePoint(0,0)

    describe 'with an object that is not fully point-like', ->
      it 'should throw an error', ->
        expect(-> new Point().add x: 10).toThrow()

    describe 'with an empty object', ->
      it 'should throw an error', ->
        expect(-> new Point().add {}).toThrow()

    describe 'with a null argument', ->
      it 'should throw an error', ->
        expect(-> new Point().add null).toThrow()


  describe '::subtract called', ->
    describe 'with another point-like object', ->
      it 'should return a new point corresponding
          to the subtraction product'.squeeze(), ->
        expect(new Point().subtract x: 10, y: 20).toBePoint(-10, -20)
        expect(new Point().subtract x: '10', y: '20').toBePoint(-10, -20)

    describe 'with two numbers as arguments', ->
      it 'should return a new point corresponding
          to the subtraction product'.squeeze(), ->
        expect(new Point().subtract 3, 8).toBePoint(-3, -8)

    describe 'with two string as arguments', ->
      it 'should return a new point corresponding
          to the subtraction product'.squeeze(), ->
        expect(new Point().subtract '10', '20').toBePoint(-10, -20)

    describe 'with no argument', ->
      it 'should return a new point equal to the source', ->
        expect(new Point().subtract()).toBePoint(0,0)

    describe 'with an object that is not fully point-like', ->
      it 'should throw an error', ->
        expect(-> new Point().subtract x: 10).toThrow()

    describe 'with an empty object', ->
      it 'should throw an error', ->
        expect(-> new Point().subtract {}).toThrow()

    describe 'with a null argument', ->
      it 'should throw an error', ->
        expect(-> new Point().subtract null).toThrow()
