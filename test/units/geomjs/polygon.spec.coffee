require '../../test_helper'

describe 'Polygon', ->
  beforeEach -> addPointMatchers this

  describe 'called without argument', ->
    it 'should throw an error', ->
      expect(-> polygon()).toThrow()

  describe 'with less than three points', ->
    it 'should throw an error', ->
      expect(-> polygon([point(), point()])).toThrow()

  polygonFactories.map (k,v) ->
    {args, test} = v
    data = polygonData.call global, test

    describe "called #{k}", ->
      beforeEach ->
        @polygon = polygon.apply global, args

      it 'should exist', ->
        expect(@polygon).toBeDefined()

      it 'should have its vertices defined', ->
        expect(@polygon.vertices).toEqual(test)

      describe 'its clone method', ->
        it 'should return a copy of the polygon', ->
          expect(@polygon.clone()).toEqual(@polygon)

      describe 'its toSource method', ->
        it 'should return the code source of the polygon', ->
          expect(@polygon.toSource()).toBe(data.source)

      describe 'its points method', ->
        it 'should return the vertices with the first being copy at last', ->
          expect(@polygon.points())
            .toEqual(@polygon.vertices.concat @polygon.vertices[0])

      describe 'its triangles method', ->
        it 'should return two triangles', ->
          expect(@polygon.triangles().length).toBe(2)

      describe 'its contains method', ->
        describe 'with a point in the geometry', ->
          it 'should return true', ->
            expect(@polygon.contains 1, 2).toBeTruthy()

        describe 'with a point off the geometry', ->
          it 'should return false', ->
            expect(@polygon.contains -10, -10).toBeFalsy()

      describe 'its acreage method', ->
        it 'should return 16', ->
          expect(@polygon.acreage()).toBeClose(16)

