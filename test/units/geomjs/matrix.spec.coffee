require '../../test_helper'

Matrix = require '../../../lib/geomjs/matrix'
Point = require '../../../lib/geomjs/point'

describe 'Matrix', ->
  beforeEach ->
    addMatrixMatchers this
    addPointMatchers this

  describe 'when instanciated', ->
    describe 'without arguments', ->
      it 'should initialize an identity matrix', ->
        expect(matrix.identity()).toBeIdentity()

    describe 'with another matrix', ->
      it 'should initialize the matrix in the same state as the arguments', ->
        m1 = matrix.transformed()
        m2 = matrix m1

        expect(m2).toBeSameMatrix(m1)

    describe 'with an object that is not a matrix', ->
      it 'should throw an error', ->
        expect(-> matrix {}).toThrow()

    describe 'with null', ->
      it 'should initialize an identity matrix', ->
        expect(matrix null).toBeIdentity()

  describe '::clone called', ->
    it 'should return a copy of the matrix', ->
      expect(matrix.transformed().clone()).toBeSameMatrix(matrix.transformed())

  describe '::equals called', ->
    describe 'with a matrix', ->
      describe 'equal to the current matrix', ->
        it 'should return true', ->
          expect(matrix().equals(matrix())).toBeTruthy()

      describe 'not equal to the current matrix', ->
        it 'should return false', ->
          expect(matrix().equals(matrix.transformed())).toBeFalsy()


  describe '::inverse called', ->
    beforeEach ->
      @m1 = matrix.transformed()
      @m2 = @m1.inverse()
      @m3 = matrix.inverted()
    it 'should inverse the matrix transformation', ->
      expect(@m1).toBeSameMatrix(@m3)
    it 'should return this instance', ->
      expect(@m1).toBe(@m2)

  describe '::identity called', ->
    beforeEach ->
      @m1 = matrix.transformed()
      @m2 = @m1.identity()
    it 'should reset the matrix to an identity matrix', ->
      expect(@m1).toBeIdentity()
    it 'should return this instance', ->
      expect(@m1).toBe(@m2)

  describe '::translate', ->
    beforeEach ->
      @matrix = matrix.transformed()
      @translated = matrix.translated()

    calledWithPoints(-2,2)
    .where
      source: 'matrix'
      method: 'translate'
    .should 'translate the matrix', (result) ->
      expect(result).toBeSameMatrix(@translated)

    describe 'without arguments', ->
      it 'should not modify the matrix', ->
        expect(matrix.identity().translate()).toBeIdentity()

  describe '::scale called', ->
    beforeEach ->
      @matrix = matrix.transformed()
      @scaled = matrix.scaled()

    calledWithPoints(0.5,2)
    .where
      source: 'matrix'
      method: 'scale'
    .should 'scale the matrix', (result) ->
      expect(result).toBeSameMatrix(@scaled)

    describe 'without arguments', ->
      it 'should not modify the matrix', ->
        expect(matrix.identity().scale()).toBeIdentity()

  describe '::rotate called', ->
    beforeEach ->
      @m1 = matrix.transformed()
      @m2 = @m1.rotate(72)
      @m3 = matrix.rotated()

    it 'should rotate the matrix', ->
      expect(@m1).toBeSameMatrix(@m3)
    it 'should return this instance', ->
      expect(@m1).toBe(@m2)

    describe 'without arguments', ->
      it 'should not modify the matrix', ->
        expect(matrix.identity().rotate()).toBeIdentity()

  describe '::append called', ->
    beforeEach ->
      @m1 = matrix.transformed()
      @m2 = @m1.append(6, 5, 4, 3, 2, 1)
      @m3 = matrix.appended()

    it 'should append the matrix', ->
      expect(@m1).toBeSameMatrix(@m3)
    it 'should return this instance', ->
      expect(@m1).toBe(@m2)

    describe 'without arguments', ->
      it 'should not modify the matrix', ->
        expect(matrix.identity().append()).toBeIdentity()

    describe 'with a matrix', ->
      it 'should append the matrix', ->
        expect(matrix.transformed().append(matrix 6, 5, 4, 3, 2, 1))
          .toBeSameMatrix(matrix.appended())

  describe '::prepend called', ->
    beforeEach ->
      @m1 = matrix.transformed()
      @m2 = @m1.prepend(6, 5, 4, 3, 2, 1)
      @m3 = matrix.prepended()

    it 'should prepend the matrix', ->
      expect(@m1).toBeSameMatrix(@m3)
    it 'should return this instance', ->
      expect(@m1).toBe(@m2)

    describe 'without arguments', ->
      it 'should not modify the matrix', ->
        expect(matrix.identity().prepend()).toBeIdentity()

    describe 'with a matrix', ->
      it 'should prepend the matrix', ->
        expect(matrix.transformed().prepend(matrix 6, 5, 4, 3, 2, 1))
          .toBeSameMatrix(matrix.prepended())

    describe 'with an identity matrix', ->
      it 'should not modify the matrix', ->
        expect(matrix.transformed().prepend(matrix.identity()))
          .toBeSameMatrix(matrix.transformed())

  describe '::skew called', ->
    beforeEach ->
      @matrix = matrix.transformed()
      @skewed = matrix.skewed()

    calledWithPoints(-2,2)
    .where
      source: 'matrix'
      method: 'skew'
    .should 'skew the matrix', (result) ->
      expect(result).toBeSameMatrix(@skewed)

    describe 'without arguments', ->
      it 'should not modify the matrix', ->
        expect(matrix.transformed().skew())
          .toBeSameMatrix(matrix.transformed())

  describe '::transformPoint called', ->
    beforeEach ->
      @matrix = matrix()
      @matrix.scale(2,2)
      @matrix.rotate(Math.PI / 2)

    describe 'with a point', ->
      it 'should return a new point resulting
          of the matrix transformations'.squeeze(), ->
        origin = point 10, 0
        transformed = @matrix.transformPoint origin
        expect(transformed).toBePoint(0, 20)

    describe 'with two numbers', ->
      it 'should return a new point resulting
          of the matrix transformations'.squeeze(), ->
        transformed = @matrix.transformPoint 10, 0
        expect(transformed).toBePoint(0, 20)

    describe 'with one number', ->
      it 'should throw an error', ->
        expect(=> @matrix.transformPoint 10).toThrow()

    describe 'without arguments', ->
      it 'should throw an error', ->
        expect(=> @matrix.transformPoint()).toThrow()

    describe 'with an incomplete point', ->
      it 'should throw an error', ->
        expect(=> @matrix.transformPoint x: 0).toThrow()
