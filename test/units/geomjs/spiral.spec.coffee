require '../../test_helper'

Spiral = require '../../../lib/geomjs/spiral'

describe 'Spiral', ->
  spiralFactories.map (k,v) ->
    {args, test} = v
    [radius1, radius2, twirl, x, y, rotation, segments] = test
    data = spiralData radius1, radius2, twirl, x, y, rotation, segments
    source = 'spiral'

    describe "when instanciated #{k}", ->
      beforeEach ->
        addSpiralMatchers this
        addPointMatchers this
        @spiral = spiral.apply global, args

      it 'should exist', ->
        expect(@spiral).toBeDefined()

      describe 'its toSource method', ->
        it 'should return the source code of the spiral', ->
          expect(@spiral.toSource()).toBe(data.source)

      it 'should have been filled with the passed-in arguments', ->
        expect(@spiral)
        .toBeSpiral(radius1, radius2, twirl, x, y, rotation, segments)

      describe 'its points method', ->
        it 'should return a array', ->
          points = @spiral.points()
          expect(points.length).toBe(segments + 1)

      # Others
      describe 'its equals method', ->
        describe 'when called with an object equal to the current spiral', ->
          it 'should return true', ->
            target = spiral.apply global, args
            expect(@spiral.equals target).toBeTruthy()

        describe 'when called with an object different than the spiral', ->
          it 'should return false', ->
            target = spiral 4, 5, 1, 3
            expect(@spiral.equals target).toBeFalsy()

      describe 'its clone method', ->
        it 'should return a copy of this spiral', ->
          expect(@spiral.clone())
          .toBeSpiral(
            @spiral.radius1,
            @spiral.radius2,
            @spiral.twirl,
            @spiral.x,
            @spiral.y,
            @spiral.rotation,
            @spiral.segments)

      # Geometry API
      geometry(source).shouldBe.openGeometry()
      geometry(source).shouldBe.translatable()
      geometry(source).shouldBe.rotatable()
      geometry(source).shouldBe.scalable()


