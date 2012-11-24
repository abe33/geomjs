require '../../test_helper'

LinearSpline = require '../../../lib/geomjs/linear_spline'

describe 'LinearSpline', ->
  describe 'when instanciated with one point', ->
    it 'should throw an error', ->
      expect(-> new LinearSpline [point()] ).toThrow()

  describe 'when instanciated with four points', ->
    source = 'spline'

    beforeEach ->
      addPointMatchers this
      @spline = new LinearSpline [ point(0,3), point(3,3),
                                   point(3,0), point(6,0) ]

    it 'should have registered the points as its vertices', ->
      expect(@spline.vertices[0]).toBePoint(0,3)
      expect(@spline.vertices[1]).toBePoint(3,3)
      expect(@spline.vertices[2]).toBePoint(3,0)
      expect(@spline.vertices[3]).toBePoint(6,0)

    spline(source).shouldBe.cloneable()
    spline(source).shouldBe.formattable('LinearSpline')
    spline(source).shouldBe.sourcable('geomjs.LinearSpline')

    spline(source).shouldHave(4).vertices()
    spline(source).shouldHave(3).segments()
    spline(source).shouldHave(4).points()

    spline(source).segmentSize.shouldBe(1)
    spline(source).bias.shouldBe(20)

    spline(source).shouldValidateWith(2).vertices()

    lengthOf(source).shouldBe(9)

  testPathMethodsOf(LinearSpline)
  testIntersectionsMethodsOf(LinearSpline)
