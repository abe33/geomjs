require '../../test_helper'

describe 'Ellipsis', ->
  beforeEach ->
    addPointMatchers this
    addRectangleMatchers this
    addEllipsisMatchers this

  ellipsisFactories.map (k,v) ->
    {args, test} = v
    [radius1, radius2, x, y, rotation, segments] = test
    source = 'ellipsis'
    data = ellipsisData.apply global, test

    describe "when instanciated with #{k} #{args}", ->
      beforeEach ->
        @ellipsis = ellipsis.apply global, args

      it 'should exist', ->
        expect(@ellipsis).toBeDefined()

      it 'should have defined the ad hoc properties', ->
        expect(@ellipsis)
          .toBeEllipsis(radius1, radius2, x, y, rotation, segments)

      describe 'its center method', ->
        it 'should return the ellipsis coordinates', ->
          expect(@ellipsis.center()).toBePoint(@ellipsis.x, @ellipsis.y)

      # Path API
      lengthOf(source).shouldBe(data.length)

      # Surface API
      acreageOf(source).shouldBe(data.acreage)

      describe 'its contains method', ->
        calledWithPoints(data.x, data.y)
          .where
            source: 'ellipsis'
            method: 'contains'
          .should 'return true', (res) ->
            expect(res).toBeTruthy()

        calledWithPoints(-100, -100)
          .where
            source: 'ellipsis'
            method: 'contains'
          .should 'return false', (res) ->
            expect(res).toBeFalsy()

      # Geometry API
      shouldBeClosedGeometry(source)

      # Drawing API
      testDrawingOf(source)

      # Others
      describe 'its equals method', ->
        describe 'when called with an object equal to the current ellipsis', ->
          it 'should return true', ->
            target = ellipsis.apply global, args
            expect(@ellipsis.equals target).toBeTruthy()

        describe 'when called with an object different than the ellipsis', ->
          it 'should return false', ->
            target = ellipsis 4, 5, 1, 3
            expect(@ellipsis.equals target).toBeFalsy()

      describe 'its clone method', ->
        it 'should return a copy of this ellipsis', ->
          expect(@ellipsis.clone())
            .toBeEllipsis(
              @ellipsis.radius1,
              @ellipsis.radius2,
              @ellipsis.x,
              @ellipsis.y,
              @ellipsis.rotation,
              @ellipsis.segments)


