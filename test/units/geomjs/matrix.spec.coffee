require '../../test_helper'

Matrix = require '../../../lib/geomjs/matrix'

describe 'Matrix', ->
  beforeEach ->
    addMatrixMatchers this
    @matrix = matrix()

  describe 'when instanciated', ->
    describe 'without arguments', ->
      it 'should initialize an identity matrix', ->
        expect(@matrix).toBeIdentity()

    describe 'with another matrix', ->
      it 'should initialize the matrix in the same state as the arguments', ->
        m1 = matrix 1, 2, 3, 4, 5, 6
        m2 = matrix m1

        expect(m2).toBeSameMatrix(m1)

    describe 'with an object that is not a matrix', ->
      it 'should throw an error', ->
        expect(-> matrix {}).toThrow()

    describe 'with null', ->
      it 'should initialize an identity matrix', ->
        expect(matrix null).toBeIdentity()

