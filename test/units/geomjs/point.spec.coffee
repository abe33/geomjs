require '../../test_helper'

Point = require '../../../lib/geomjs/point'

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

  describe '::length called', ->
    describe 'with a zero length point', ->
      it 'should return 0', ->
        expect(point().length()).toBeClose(0)

    describe 'with a point such (0,5)', ->
      it 'should return 5', ->
        expect(point(0, 5).length()).toBeClose(5)

    length = Math.sqrt 7*7 + 5*5

    describe 'with a point such (7,5)', ->
      it "should return #{length}", ->
        expect(point(7, 5).length()).toBeClose(length)

    describe 'with a point such (-7,-5)', ->
      it "should return #{length}", ->
        expect(point(-7, -5).length()).toBeClose(length)

  pointOperator('add')
    .with(2,3).and(4,5)
    .where
      emptyArguments: 'copy'
      emptyObject: 'copy'
      partialObject: (result) -> expect(result).toBePoint(6,3)
      nullArgument: 'copy'
    .should 'return a new point corresponding
             to the addition product'.squeeze(), (result) ->
      expect(result).toBePoint(6,8)

  pointOperator('subtract')
    .with(6,8).and(4,5)
    .where
      emptyArguments: 'copy'
      emptyObject: 'copy'
      partialObject: (result) -> expect(result).toBePoint(2,8)
      nullArgument: 'copy'
    .should 'return a new point corresponding
             to the subtract product'.squeeze(), (result) ->
      expect(result).toBePoint(2,3)

  pointOperator('dot')
    .with(7,3).and(4,2)
    .where
      emptyArguments: 'throws'
      emptyObject: 'throws'
      partialObject: 'throws'
      nullArgument: 'throws'
    .should 'return the dot product of the current
             point and the point argument'.squeeze(), (result) ->
      expect(result).toBeClose(7*4 + 3*2)

  pointOperator('distance')
    .with(7,3).and(4,2)
    .where
      emptyArguments: 'throws'
      emptyObject: 'throws'
      partialObject: 'throws'
      nullArgument: 'throws'
    .should 'return the distance between the two points', (result) ->
      expect(result).toBeClose(point(3,1).length())

  describe '::normalize called', ->
    describe 'on a point with a length of 0', ->
      it 'should return a new point of length 0', ->
        expect(point(0,0).normalize().length()).toBeClose(0)

    describe 'without arguments', ->
      beforeEach ->
        @point1 = point(5,6)
        @point2 = @point1.normalize()

      it 'should return a new point of length 1', ->
        expect(@point2.length()).toBeClose(1)

      it 'should return a new point with the same direction', ->
        expect(@point2.x / @point2.y).toBeClose(@point1.x / @point1.y)

    describe 'with null', ->
      it 'should return a new point of length 1', ->
        expect(point(5,6).normalize(null).length()).toBeClose(1)


    describe 'with a number', ->
      describe 'that is positive', ->
        beforeEach ->
          @normalizedLength = 10.5
          @point1 = point(5,6)
          @point2 = @point1.normalize(@normalizedLength)

        it 'should return a new point with length equal to the number', ->
          expect(@point2.length()).toBeClose(@normalizedLength)

        it 'should return a new point with the same direction', ->
          expect(@point2.x / @point2.y).toBeClose(@point1.x / @point1.y)

      describe 'that is negative', ->
        beforeEach ->
          @normalizedLength = -10.5
          @point1 = point(5,6)
          @point2 = @point1.normalize(@normalizedLength)

        it 'should return a new point with length equal to the number', ->
          expect(@point2.length()).toBeClose(Math.abs @normalizedLength)

        it 'should return a new point with the same direction', ->
          expect(@point2.x / @point2.y).toBeClose(@point1.x / @point1.y)

      describe 'that is 0', ->
        it 'should return a new point with length equal to 0', ->
          expect(point(5,6).normalize(0).length()).toBeClose(0)

    describe 'with a string', ->
      describe 'containing a number', ->
        beforeEach ->
          @normalizedLength = '10.5'
          @point1 = point(5,6)
          @point2 = @point1.normalize(@normalizedLength)

        it 'should return a new point with length equal to the number', ->
          expect(@point2.length()).toBeClose(parseFloat @normalizedLength)

      describe 'containing anything but a number', ->
        it 'should throw an error', ->
          expect(-> point(5,6).normalize('foo')).toThrow()

    describe 'with an object', ->
      it 'should throw an error', ->
        expect(-> point(5,6).normalize({})).toThrow()


