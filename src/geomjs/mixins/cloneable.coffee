# @toc
Mixin = require './mixin'

## Cloneable
class Cloneable extends Mixin
  ##### Cloneable.attachTo
  #
  # See
  # [Mixin.attachTo](src_geomjs_mixins_mixin.html#mixinattachto)

  #### Cloneable::clone
  #
  @included: (klass) -> klass::clone = -> new klass this

module.exports = Cloneable
