require '../../test_helper'

Point = require '../../../lib/geomjs/point'

point = (x,y) -> new Point x, y
pointLike = (x,y) -> {x,y}

describe 'Point', ->
  beforeEach -> addPointMatchers this

  describe 'after being instanciated', ->
    describe 'with two numbers as arguments', ->
      it 'should create the new instance', ->
        expect(point 3, 8).toBePoint(3, 8)

    describe 'with two strings as arguments', ->
      it 'should create the new instance', ->
        expect(point '3', '8').toBePoint(3, 8)

    describe 'with no arguments', ->
      it 'should create the new instance with default coordinates of 0', ->
        expect(point()).toBePoint()

    describe 'with another point-like object as argument', ->
      it 'should create the new instance with the values of the object', ->
        expect(point x: 10, y: 23).toBePoint(10, 23)

    describe 'with an incomplete point-like object as argument', ->
      it 'should create the new instance with the value of the object', ->
        expect(point x: 10).toBePoint(10, 0)


  describe '::add called', ->
    describe 'with another point-like object', ->
      it 'should return a new point corresponding to the addition product', ->
        expect(point().add pointLike 10, 20).toBePoint(10, 20)

      describe 'containing strings', ->
        it 'should return a new point corresponding
            to the addition product'.squeeze(), ->
          expect(point().add pointLike '10', '20').toBePoint(10, 20)

    describe 'with two numbers as arguments', ->
      it 'should return a new point corresponding to the addition product', ->
        expect(point().add 3, 8).toBePoint(3, 8)

    describe 'with two string as arguments', ->
      it 'should return a new point corresponding to the addition product', ->
        expect(point().add '10', '20').toBePoint(10, 20)

    describe 'with no argument', ->
      it 'should return a new point equal to the source', ->
        expect(point().add()).toBePoint(0,0)

    describe 'with an object that is not fully point-like', ->
      it 'should throw an error', ->
        expect(-> point().add x: 10).toThrow()

    describe 'with an empty object', ->
      it 'should throw an error', ->
        expect(-> point().add {}).toThrow()

    describe 'with a null argument', ->
      it 'should throw an error', ->
        expect(-> point().add null).toThrow()


  describe '::subtract called', ->
    describe 'with another point-like object', ->
      it 'should return a new point corresponding
          to the subtraction product'.squeeze(), ->
        expect(point().subtract pointLike 10, 20).toBePoint(-10, -20)

      describe 'containing strings', ->
        it 'should return a new point corresponding
            to the subtraction product'.squeeze(), ->
          expect(point().subtract pointLike '10', '20').toBePoint(-10, -20)

    describe 'with two numbers as arguments', ->
      it 'should return a new point corresponding
          to the subtraction product'.squeeze(), ->
        expect(point().subtract 3, 8).toBePoint(-3, -8)

    describe 'with two string as arguments', ->
      it 'should return a new point corresponding
          to the subtraction product'.squeeze(), ->
        expect(point().subtract '10', '20').toBePoint(-10, -20)

    describe 'with no argument', ->
      it 'should return a new point equal to the source', ->
        expect(point().subtract()).toBePoint(0,0)

    describe 'with an object that is not fully point-like', ->
      it 'should throw an error', ->
        expect(-> point().subtract x: 10).toThrow()

    describe 'with an empty object', ->
      it 'should throw an error', ->
        expect(-> point().subtract {}).toThrow()

    describe 'with a null argument', ->
      it 'should throw an error', ->
        expect(-> point().subtract null).toThrow()

  describe '::length called', ->
    describe 'with a zero length point', ->
      it 'should return 0', ->
        expect(point().length()).toBe(0)

    describe 'with a point such (0,5)', ->
      it 'should return 5', ->
        expect(point(0, 5).length()).toBe(5)

    length = Math.sqrt 7*7 + 5*5

    describe 'with a point such (7,5)', ->
      it "should return #{length}", ->
        expect(point(7, 5).length()).toBe(length)

    describe 'with a point such (-7,-5)', ->
      it "should return #{length}", ->
        expect(point(-7, -5).length()).toBe(length)

