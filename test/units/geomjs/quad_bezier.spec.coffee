require '../../test_helper'

QuadBezier = require '../../../lib/geomjs/quad_bezier'

describe 'QuadBezier', ->
  describe 'when called with four vertices', ->
    source = 'curve'

    beforeEach ->
      addPointMatchers this
      @curve = new QuadBezier([
        point(0,0)
        point(2,2)
        point(4,0)
      ], 20)

    spline(source).shouldBe.cloneable()
    spline(source).shouldBe.formattable('QuadBezier')
    spline(source).shouldBe.sourcable('geomjs.QuadBezier')

    spline(source).shouldHave(3).vertices()
    spline(source).shouldHave(1).segments()
    spline(source).shouldHave(21).points()

    spline(source).segmentSize.shouldBe(2)
    spline(source).bias.shouldBe(20)

    spline(source).shouldValidateWith(3).vertices()

  testPathMethodsOf(QuadBezier)
  testIntersectionsMethodsOf(QuadBezier)

