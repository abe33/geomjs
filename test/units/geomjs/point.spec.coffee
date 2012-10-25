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
      expect(result).toBe(7*4 + 3*2)

