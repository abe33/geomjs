Mixin = require './mixin'

## Memoizable
class Memoizable extends Mixin

  ##### Memoizable::memoized
  #
  memoized: (prop) ->
    if @memoizationKey() is @__memoizationKey__
      @__cache__?[prop]?
    else
      @__cache__ = {}
      false

  ##### Memoizable::memoFor
  #
  memoFor: (prop) -> @__cache__[prop]

  ##### Memoizable::memoize
  #
  memoize: (prop, value) ->
    @__cache__ ||= {}
    @__memoizationKey__ = @memoizationKey()
    @__cache__[prop] = value

  ##### Memoizable::memoizationKey
  #
  memoizationKey: -> @toString()

module.exports = Memoizable
