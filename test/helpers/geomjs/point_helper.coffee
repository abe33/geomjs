Point = require '../../../lib/geomjs/point'

global.addPointMatchers = (scope) ->
  scope.addMatchers
    notText: -> notText = if @isNot then " not" else ""



    toBePoint: (x=0, y=0) ->
      @message = ->
        "Expected #{@actual}#{@notText()} to be a point with x=#{x} and y=#{y}"

      @actual.x is x and @actual.y is y

    toBeSamePoint: (pt) ->
      @message = ->
        "Expected #{@actual}#{@notText()} to be a point equivalent to #{pt}"

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

      if options.nullArgument?
        describe 'with null', ->
          operatorOption options.nullArgument,
                         operatorActions,
                         -> @point[operator] null
