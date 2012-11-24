
Point = require '../../../lib/geomjs/point'

BUILDS = (
  new Function( "return new arguments[0](#{
    ("arguments[1][#{j-1}]" for j in [0..i] when j isnt 0 ).join ","
  });") for i in [0..24]
)

construct = (klass, args) ->
  f = BUILDS[if args? then args.length else 0]
  f klass, args

testMethod = (method, source, expected) ->
  describe "its #{method} method", ->
    it "should return #{expected}", ->
      expect(this[source][method]()).toBeClose(expected)

testLength = (method, source, expected) ->
  describe "its #{method} method", ->
    it "should return an array of length #{expected}", ->
      expect(this[source][method]().length).toBeClose(expected)

testProperty = (property, source, expected) ->
  describe "its #{property} property", ->
    it "should be #{expected}", ->
      expect(this[source][property]).toBeClose(expected)

testPropertyLength = (property, source, expected) ->
  describe "its #{property} property", ->
    it "should have #{expected} elements", ->
      expect(this[source][property].length).toBeClose(expected)

global.testIntersectionsMethodsOf = (klass) ->
  vertices = (point(i,0) for i in [0..3])
  describe "when instanciated with #{vertices}", ->
    beforeEach ->
      addPointMatchers this
      @spline = construct klass, [vertices]

    describe 'its intersects method', ->
      describe 'called with a simple line crossing it in the middle', ->
        it 'should return true', ->
          expect(@spline.intersects points: -> [point(1.5,-1),point(1.5,1)])
          .toBeTruthy()

      describe 'called with a simple line not crossing it', ->
        it 'should return false', ->
          expect(@spline.intersects points: -> [point(-2,-1),point(-2,1)])
          .toBeFalsy()

    describe 'its intersections method', ->
      describe 'called with a simple line crossing it in the middle', ->
        it 'should return true', ->
          intersections = @spline.intersections points: -> [ point(1.5,-1),
                                                             point(1.5,1) ]
          expect(intersections.length).toBe(1)
          expect(intersections[0]).toBePoint(1.5,0)

      describe 'called with a simple line not crossing it', ->
        it 'should return false', ->
          intersections = @spline.intersections points: -> [ point(-2,-1),
                                                             point(-2,1) ]
          expect(intersections).toBeNull()

global.testPathMethodsOf = (klass) ->
  hpoints = (point(i,0) for i in [0..3])
  vpoints = (point(0,i) for i in [0..3])
  [hpoints, vpoints].forEach (vertices) ->
    describe "when instanciated with #{vertices}", ->
      beforeEach ->
        addPointMatchers this
        @spline = construct klass, [vertices]

      describe 'its pathPointAt method', ->
        describe 'called with 0', ->
          it 'should return the first vertice', ->
            expect(@spline.pathPointAt 0)
            .toBeSamePoint(vertices[0])

        describe 'called with 0.5', ->
          it 'should return the first vertice', ->
            expect(@spline.pathPointAt 0.5)
            .toBeSamePoint(vertices[0].add vertices[3].scale(0.5))

        describe 'called with 1', ->
          it 'should return the last vertice', ->
            expect(@spline.pathPointAt 1)
            .toBeSamePoint(vertices[3])

global.spline = (source) ->
  shouldBe:
    cloneable: ->
      describe 'its clone method', ->
        beforeEach ->
          @target = this[source]
          @copy = @target.clone()
        it 'should return a copy of the spline', ->
          expect(@copy).toBeDefined()
          expect(@copy.vertices).toEqual(@target.vertices)

        it 'should return a simple reference to the original vertices', ->
          expect(@copy.vertices).not.toBe(@target.vertices)
          for vertex,i in @copy.vertices
            expect(vertex).not.toBe(@target.vertices[i])

    formattable: (classname) ->
      describe 'its classname method', ->
        it 'should return its class name', ->
          expect(this[source].classname()).toBe(classname)

      describe 'its toString method', ->
        it 'should return the classname in a formatted string', ->
          expect(this[source].toString().indexOf classname).not.toBe(-1)

    sourcable: (pkg) ->
      describe 'its toSource method', ->
        it 'should return the code to create the spline again', ->
          target = this[source]
          result = target.toSource()
          verticesSource = target.vertices.map (p) -> p.toSource()
          expect(result)
          .toBe("new #{pkg}([#{verticesSource.join ','}],#{target.bias})")

  shouldHave: (expected) ->
    segments: -> testMethod 'segments', source, expected
    points: -> testLength 'points', source, expected
    vertices: -> testPropertyLength 'vertices', source, expected

  shouldValidateWith: (expected) ->
    vertices: ->
      describe "its validateVertices method", ->
        failingAmount = expected - 1

        describe "called with #{failingAmount} vertices", ->
          it 'should return false', ->
            vertices = (point() for n in [0..failingAmount-1])
            res = this[source].validateVertices vertices
            expect(res).toBeFalsy()

        describe "called with #{expected} vertices", ->
          it 'should return true', ->
            vertices = (point() for n in [0..expected-1])
            res = this[source].validateVertices vertices
            expect(res).toBeTruthy()

  segmentSize:
    shouldBe: (expected) -> testMethod 'segmentSize', source, expected
  bias:
    shouldBe: (expected) -> testProperty 'bias', source, expected
