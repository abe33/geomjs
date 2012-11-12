require '../../test_helper'

describe 'Intersections between', ->
  beforeEach -> addPointMatchers this

  describe 'Rectangle and Rectangle', ->
    it 'should return two points', ->
      rect1 = rectangle 0, 0, 4, 4
      rect2 = rectangle 2, 2, 4, 4
      intersections = rect1.intersections rect2

      expect(intersections.length).toBe(2)
      expect(intersections[0]).toBePoint(4, 2)
      expect(intersections[1]).toBePoint(2, 4)

  describe 'Rectangle and Circle', ->
    beforeEach ->
      @rect = rectangle 0, 0, 4, 4
      @circ = circle 2, 0, 0

    it 'should return two points', ->
      intersections = @rect.intersections @circ

      expect(intersections.length).toBe(2)
      expect(intersections[0]).toBePoint(2, 0)
      expect(intersections[1]).toBePoint(0, 2)

    it 'should return two points', ->
      intersections = @circ.intersections @rect

      expect(intersections.length).toBe(2)
      expect(intersections[0]).toBePoint(2, 0)
      expect(intersections[1]).toBePoint(0, 2)

  describe 'Circle and Circle', ->
    describe 'that are spaced by the sum of their radii', ->
      it 'should return one point', ->
        circ1 = circle 4, 0, 0
        circ2 = circle 6, 10, 0

        intersections = circ1.intersections circ2
        expect(intersections.length).toBe(1)
        expect(intersections[0]).toBePoint(4,0)

    describe 'that are spaced by less than the sum of their radii', ->
      it 'should return two points', ->
        circ1 = circle 4, 0, 0
        circ2 = circle 6, 8, 0

        intersections = circ1.intersections circ2
        expect(intersections.length).toBe(2)
        h = 2.9047375096555625
        expect(intersections[0]).toBePoint(2.75,-h)
        expect(intersections[1]).toBePoint(2.75, h)

    describe 'that are equals', ->
      it 'should return the geometry points', ->
        circ1 = circle 4, 0, 0
        circ2 = circle 4, 0, 0

        intersections = circ1.intersections circ2
        expect(intersections.length).toBe(circ1.points().length)
        expect(intersections).toEqual(circ1.points())

    describe 'that does not intersects', ->
      it 'should return null', ->
        circ1 = circle 4, 0, 0
        circ2 = circle 4, 10, 0

        intersections = circ1.intersections circ2
        expect(intersections).toBeNull()






