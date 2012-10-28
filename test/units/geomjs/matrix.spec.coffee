require '../../test_helper'

Matrix = require '../../../lib/geomjs/matrix'

describe 'Matrix', ->
  beforeEach ->
    addMatrixMatchers this

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

  describe '::translate called', ->
    beforeEach ->
      @m1 = matrix.transformed()
      @m2 = @m1.translate(-2, 2)
      @m3 = matrix.translated()
    it 'should translate the matrix', ->
      expect(@m1).toBeSameMatrix(@m3)
    it 'should return this instance', ->
      expect(@m1).toBe(@m2)

    describe 'without arguments', ->
      it 'should not modify the matrix', ->
        expect(matrix.identity().translate()).toBeIdentity()

  describe '::scale called', ->
    beforeEach ->
      @m1 = matrix.transformed()
      @m2 = @m1.scale(0.5, 2)
      @m3 = matrix.scaled()

    it 'should scale the matrix', ->
      expect(@m1).toBeSameMatrix(@m3)
    it 'should return this instance', ->
      expect(@m1).toBe(@m2)

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
      @m1 = matrix.transformed()
      @m2 = @m1.skew(-2, 2)
      @m3 = matrix.skewed()

    it 'should skew the matrix', ->
      expect(@m1).toBeSameMatrix(@m3)
    it 'should return this instance', ->
      expect(@m1).toBe(@m2)


