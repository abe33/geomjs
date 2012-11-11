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
