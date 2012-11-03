
global.shouldBeClosedGeometry= (source) ->
  it 'should be a closed geometry', ->
    expect(@[source].closedGeometry()).toBeTruthy()

global.shouldBeOpenGeometry= (source) ->
  it 'should be an open geometry', ->
    expect(@[source].closedGeometry()).toBeFalsy()

global.testDrawingOf = (source) ->
  describe "with drawing api", ->
    beforeEach ->
      @context =
        fill: => @fillCalled = true
        stroke: => @strokeCalled = true
        beginPath: => @beginPathCalled = true
        closePath: => @closePathCalled = true
        moveTo: => @moveToCalled = true
        lineTo: => @lineToCalled = true

    describe "the #{source} stroke method", ->
      beforeEach ->
        @color = "#ffffff"
        @[source].stroke @context, @color

      it 'should set the stroke style on the context object', ->
        expect(@context.strokeStyle).toBe(@color)
      it 'should call the stroke method of the context object', ->
        expect(@strokeCalled).toBeTruthy()

    describe "the #{source} fill method", ->
      beforeEach ->
        @color = "#ffffff"
        @[source].fill @context, @color

      it 'should set the fill style on the context object', ->
        expect(@context.fillStyle).toBe(@color)
      it 'should call the fill method of the context object', ->
        expect(@fillCalled).toBeTruthy()
