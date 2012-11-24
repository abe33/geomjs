require '../../test_helper'

CubicBezier = require '../../../lib/geomjs/cubic_bezier'

describe 'CubicBezier', ->
  describe 'when called with four vertices', ->
    source = 'curve'

    beforeEach ->
      addPointMatchers this
      @curve = new CubicBezier([
        point(0,0)
        point(4,0)
        point(4,4)
        point(0,4)
      ], 20)

    spline(source).shouldBe.cloneable()
    spline(source).shouldBe.formattable('CubicBezier')
    spline(source).shouldBe.sourcable('geomjs.CubicBezier')

    spline(source).shouldHave(4).vertices()
    spline(source).shouldHave(1).segments()
    spline(source).shouldHave(21).points()

    spline(source).segmentSize.shouldBe(3)
    spline(source).bias.shouldBe(20)

    spline(source).shouldValidateWith(4).vertices()

  testPathMethodsOf(CubicBezier)
