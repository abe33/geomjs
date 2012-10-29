Point = require '../../../lib/geomjs/point'

equalEnough = (a, b) -> Math.abs(a - b) < 1 / 10000000000

global.addPointMatchers = (scope) ->
  scope.addMatchers
    notText: -> if @isNot then " not" else ""

    toBeClose: (value) ->
      @message = ->
        "Expected #{@actual}
         #{if @isNot then " not" else ""}
         to be equal to #{value}
         with a precision of 1e-10".squeeze()

      equalEnough(@actual, value)

    toBePoint: (x=0, y=0) ->
      @message = ->
        "Expected #{@actual}
         #{if @isNot then " not" else ""}
         to be a point with x=#{x} and y=#{y}".squeeze()

      equalEnough(@actual.x, x) and equalEnough(@actual.y, y)

    toBeSamePoint: (pt) ->
      @message = ->
        "Expected #{@actual}
         #{if @isNot then " not" else ""}
         to be a point equivalent to #{pt}".squeeze()

      @actual.x is pt.x and @actual.y is pt.y

global.point = (x,y) -> new Point x, y
global.pointLike = (x,y) -> {x,y}

global.pointOperator = (operator) ->

  operatorActions =
    copy: (expectation) ->
      it "should return a copy of the point", ->
        expect(expectation.call this).toBeSamePoint(@point)
    throws: (expectation) ->
      it 'should throw an error', ->
        expect(=> expectation.call this).toThrow()
    null: (expectation) ->
      it 'should return null', ->
        expect(expectation.call this).toBeNull()
    nan: (expectation) ->
      it 'should return nan', ->
        expect(expectation.call this).toBe(NaN)

  operatorOption = (value, actions={}, expectation=null) ->
    switch typeof value
      when 'function'
        it '', ->
          value.call this, expectation?.call this
      when 'string'
        actions[value]? expectation

  with: (@x1, @y1) -> this
  and: (@x2, @y2) -> this
  where: (@options) -> this
  should: (message, block) ->
    {x1, x2, y1, y2, options} = this
    describe "::#{operator} called", ->
      beforeEach ->
        @point = new Point x1, y1

      describe 'with another point', ->
        it "should #{message}", ->
          block.call this, @point[operator] point x2, y2

      describe 'with a point-like object', ->
        it "should #{message}", ->
          block.call this, @point[operator] pointLike x2, y2

        describe 'containing strings', ->
          it "should #{message}", ->
            block.call this, @point[operator] pointLike "#{x2}","#{y2}"

      describe 'with two numbers as arguments', ->
        it "should #{message}", ->
          block.call this, @point[operator] x2, y2

      describe 'with two string as arguments', ->
        it "should #{message}", ->
          block.call this, @point[operator] "#{x2}", "#{y2}"

      if options.emptyArguments?
        describe 'with no argument', ->
          operatorOption options.emptyArguments,
                         operatorActions,
                         -> @point[operator]()

      if options.emptyObject?
        describe 'with an empty object', ->
          operatorOption options.emptyObject,
                         operatorActions,
                         -> @point[operator] {}

      if options.partialObject?
        describe 'with a partial object', ->
          operatorOption options.partialObject,
                         operatorActions,
                         -> @point[operator] x: x2

      if options.singleNumber?
        describe 'with only one number', ->
          operatorOption options.singleNumber,
                         operatorActions,
                         -> @point[operator] x2

      if options.nullArgument?
        describe 'with null', ->
          operatorOption options.nullArgument,
                         operatorActions,
                         -> @point[operator] null

global.calledWithPoint = (x,y) ->
  where: (@options) -> this
  should: (message, block) ->
    {options} = this

    describe "called with point (#{x},#{y})", ->
      it "should #{message}", ->
        block.call this, @[options.source][options.method] point x, y

    describe 'called with a point-like object', ->
      it "should #{message}", ->
        block.call this, @[options.source][options.method] pointLike x, y

      describe "containing strings '#{x}' and '#{y}'", ->
        it "should #{message}", ->
          block.call this, @[options.source][options.method] pointLike "#{x}",
                                                                       "#{y}"

    describe "called with numbers #{x} and #{y}", ->
      it "should #{message}", ->
        block.call this, @[options.source][options.method] x, y

    describe "called with strings '#{x}' and '#{y}'", ->
      it "should #{message}", ->
        block.call this, @[options.source][options.method] "#{x}", "#{y}"

global.pointOf = (source, method, args...) ->
  shouldBe: (x, y) ->
    beforeEach -> addPointMatchers this

    it "should return a point equal to (#{x},#{y})", ->
      source = @[source]
      expect(source[method].apply source, args).toBePoint(x, y)
