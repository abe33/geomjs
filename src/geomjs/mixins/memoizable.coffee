Mixin = require './mixin'

class Memoizable extends Mixin

  memoized: (prop) ->
    if @memoizationKey() is @__memoizationKey__
      @__cache__?[prop]?
    else
      @__cache__ = {}
      false

  memoFor: (prop) -> @__cache__[prop]

  memoize: (prop, value) ->
    @__cache__ ||= {}
    @__memoizationKey__ = @memoizationKey()
    @__cache__[prop] = value

  memoizationKey: -> @toString()

module.exports = Memoizable
