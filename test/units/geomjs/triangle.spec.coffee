require '../../test_helper'

describe 'Triangle', ->
  beforeEach ->
    addPointMatchers this
    addRectangleMatchers this

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

      [
        'ab','ac','ba', 'bc', 'ca', 'cb',
        'abCenter', 'acCenter', 'bcCenter'
      ].forEach (k) ->
        describe "its '#{k}' method", ->
          it "should return #{data[k]}", ->
            expect(@triangle[k]()).toBeSamePoint(data[k])

      ['abc', 'bac', 'acb'].forEach (k) ->
        describe "its '#{k}' method", ->
          it "should return #{data[k]}", ->
            expect(@triangle[k]()).toBeClose(data[k])

      describe 'its center method', ->
        it 'should return the triangle center', ->
          expect(@triangle.center()).toBeSamePoint(data.center)

      # Surface API
      acreageOf(source).shouldBe(data.acreage)

      # Path API
      lengthOf(source).shouldBe(data.length)

      describe 'its points method', ->
        it 'should return four points', ->
          points = @triangle.points()
          expect(points.length).toBe(4)
          expect(points[0]).toBeSamePoint(data.a)
          expect(points[1]).toBeSamePoint(data.b)
          expect(points[2]).toBeSamePoint(data.c)
          expect(points[3]).toBeSamePoint(data.a)

      # Geometry API
      shouldBeClosedGeometry(source)

      ['top', 'left', 'bottom', 'right'].forEach (k) ->
        describe "its #{k} method", ->
          it "should return #{data[k]}", ->
            expect(@triangle[k]()).toBe(data[k])

      describe 'its bounds method', ->
        it 'should return the bounds of the triangle', ->
          expect(@triangle.bounds()).toEqual(data.bounds)

      describe 'its boundingBox method', ->
        it 'should return the bounds of the triangle', ->
          expect(@triangle.boundingBox())
            .toBeRectangle(data.left,
                           data.top,
                           data.right - data.left
                           data.bottom - data.top)

      # Drawing API
      testDrawingOf(source)


  describe 'when instanciated with at least an invalid point', ->
    it 'should throw an error', ->
      expect(-> triangle point(4,5), point(5,7), 'notAPoint').toThrow()
