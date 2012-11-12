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






