require '../../test_helper'

LinearSpline = require '../../../lib/geomjs/linear_spline'

describe 'LinearSpline', ->
  describe 'when instanciated with one point', ->
    it 'should throw an error', ->
      expect(-> new LinearSpline [point()] ).toThrow()

  describe 'when instanciated with four points', ->
    beforeEach ->
      addPointMatchers this
      @spline = new LinearSpline [ point(0,3), point(3,3),
                                   point(3,0), point(6,0) ]
    it 'should exist', ->
      expect(@spline).toBeDefined()

    describe 'its bias property', ->
      it 'should be the default', ->
        expect(@spline.bias).toBe(20)

    it 'should have registered the points as its vertices', ->
      expect(@spline.vertices.length).toBe(4)
      expect(@spline.vertices[0]).toBePoint(0,3)
      expect(@spline.vertices[1]).toBePoint(3,3)
      expect(@spline.vertices[2]).toBePoint(3,0)
      expect(@spline.vertices[3]).toBePoint(6,0)

    describe 'its segments method', ->
      it 'should return 3', ->
        expect(@spline.segments()).toBe(3)

    describe 'its segmentSize method', ->
      it 'should return 1', ->
        expect(@spline.segmentSize()).toBe(1)

    describe 'its points method', ->
      it 'should return the vertices', ->
        expect(@spline.points()).toEqual(@spline.vertices)

    describe 'its length method', ->
      it 'should return 12', ->
        expect(@spline.length()).toBeClose(9)

    describe 'its pathPointAt method', ->
      describe 'called with 0', ->
        it 'should return the first vertice', ->
          expect(@spline.pathPointAt 0)
            .toBeSamePoint(@spline.vertices[0])

      describe 'called with 1', ->
        it 'should return the last vertice', ->
          expect(@spline.pathPointAt 1)
            .toBeSamePoint(@spline.vertices[@spline.vertices.length - 1])

      describe 'called with 0.5', ->
        it 'should return the middle of the second segment', ->
          expect(@spline.pathPointAt 0.5).toBePoint(3, 1.5)
          expect(@spline.pathPointAt 0.5, false).toBePoint(3, 1.5)

