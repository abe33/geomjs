require '../../test_helper'

describe 'Diamond', ->
  beforeEach -> addDiamondMatchers this

  diamondFactories.map (k,v) ->
    {args, test} = v
    [topLength, rightLength, bottomLength, leftLength, x, y, rotation] = test
    data = diamondData.apply global, test
    source = 'diamond'

    describe "when instanciated #{k} #{args}", ->
      beforeEach ->
        @diamond = diamond.apply global, args

      it 'should have set the ad hoc properties', ->
        expect(@diamond).toBeDiamond(topLength,
                                     rightLength,
                                     bottomLength,
                                     leftLength,
                                     x,
                                     y,
                                     rotation)

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

      pointOf(source, 'center').shouldBe(data.center)
      pointOf(source, 'topCorner').shouldBe(data.topCorner)
      pointOf(source, 'bottomCorner').shouldBe(data.bottomCorner)
      pointOf(source, 'leftCorner').shouldBe(data.leftCorner)
      pointOf(source, 'rightCorner').shouldBe(data.rightCorner)
      pointOf(source, 'topLeftEdge').shouldBe(data.topLeftEdge)
      pointOf(source, 'topRightEdge').shouldBe(data.topRightEdge)
      pointOf(source, 'bottomRightEdge').shouldBe(data.bottomRightEdge)
      pointOf(source, 'bottomLeftEdge').shouldBe(data.bottomLeftEdge)
