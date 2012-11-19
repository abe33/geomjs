# @toc
Mixin = require './mixin'

## Equatable

#
Equatable = (properties...) ->
  #
  class ConcretEquatable extends Mixin
    ##### Equatable.attachTo
    #
    # See
    # [Mixin.attachTo](src_geomjs_mixins_mixin.html#mixinattachto)

    ##### Equatable::equals
    #
    equals: (o) -> o? and properties.every (p) =>
      if @[p].equals? then @[p].equals o[p] else o[p] is @[p]

module.exports = Equatable
