require '../../test_helper'

describe 'Diamond', ->
  beforeEach -> addDiamondMatchers this

  diamondFactories.map (k,v) ->
    {args, test} = v
    [top, right, bottom, left, x, y, rotation] = test

    describe "when instanciated #{k} #{args}", ->
      beforeEach ->
        @diamond = diamond.apply global, args
      it 'should have set the ad hoc properties', ->
        expect(@diamond).toBeDiamond(top, right, bottom, left, x, y, rotation)

      describe 'its clone method', ->
        it 'should return a copy of the diamond', ->
          expect(@diamond.clone()).toEqual(@diamond)

      describe 'its equals method', ->
        describe 'with an object equals to the diamond', ->
          it 'should return true', ->
            expect(@diamond.clone().equals(@diamond)).toBeTruthy()

        describe 'with an object not equals to the diamond', ->
          it 'should return false', ->
            expect(diamond(0,0,0,0,0,0,0).equals(@diamond)).toBeFalsy()

