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
    data = polygonData.call global, test()

    describe "called #{k}", ->
      beforeEach ->
        @polygon = polygon.apply global, args()

      it 'should exist', ->
        expect(@polygon).toBeDefined()

      it 'should have its vertices defined', ->
        expect(@polygon.vertices).toEqual(test())

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

      describe 'its translate method', ->
        it 'should move the polygon', ->
          @polygon.translate 2, 2
          for vertex,i in @polygon.vertices
            expect(vertex).toBePoint(data.vertices[i].x + 2,
                                     data.vertices[i].y + 2)

      describe 'its rotateAroundCenter method', ->
        it 'should rotate the polygon', ->
          center = @polygon.center()
          @polygon.rotateAroundCenter(10)
          for vertex,i in @polygon.vertices
            expect(vertex)
              .toBeSamePoint(data.vertices[i].rotateAround(center,10))

      describe 'its scaleAroundCenter method', ->
        it 'should scale the polygon', ->
          center = @polygon.center()
          @polygon.scaleAroundCenter(2)
          for vertex,i in @polygon.vertices
            pt = center.add data.vertices[i].subtract(center).scale(2)
            expect(vertex).toBeSamePoint(pt)


      acreageOf('polygon').shouldBe(16)
      lengthOf('polygon').shouldBe(16)

