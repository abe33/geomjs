require '../../test_helper'

describe 'Triangle', ->
  beforeEach ->
    addPointMatchers this

  factories = [
    triangle
    triangle.equilateral
    triangle.isosceles
    triangle.rectangle
    triangle.withPointLike
  ]
  dataFactories = [
    triangleData
    triangleData.equilateral
    triangleData.isosceles
    triangleData.rectangle
    triangleData
  ]

  factories.forEach (factory, i) ->
    data = dataFactories[i]()
    source = 'triangle'

    describe 'when instanciated with three valid points', ->
      beforeEach ->
        @triangle = factory()

      it 'should create a valid triangle instance', ->
        expect(@triangle).toBeDefined()

      ['a','b','c'].forEach (k) ->
        describe "its '#{k}' property", ->
          it "should have been filled with #{data[k]}", ->
            expect(@triangle[k]).toBeSamePoint(data[k])

      ['ab','ac','ba', 'bc', 'ca', 'cb'].forEach (k) ->
        describe "its '#{k}' method", ->
          it "should return #{data[k]}", ->
            expect(@triangle[k]()).toBeSamePoint(data[k])

      ['abc', 'bac', 'acb'].forEach (k) ->
        describe "its '#{k}' method", ->
          it "should return #{data[k]}", ->
            expect(@triangle[k]()).toBeClose(data[k])

      acreageOf(source).shouldBe(data.acreage)

      lengthOf(source).shouldBe(data.length)

      shouldBeClosedGeometry(source)

      # Drawing API
      testDrawingOf(source)


  describe 'when instanciated with at least an invalid point', ->
    it 'should throw an error', ->
      expect(-> triangle point(4,5), point(5,7), 'notAPoint').toThrow()
