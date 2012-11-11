Mixin = require './mixin'

Equatable = (properties...) ->
  class extends Mixin
    equals: (o) -> o? and properties.every (p) =>
      if @[p].equals? then @[p].equals o[p] else o[p] is @[p]

module.exports = Equatable
