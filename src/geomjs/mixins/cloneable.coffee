# @toc
Mixin = require './mixin'

## Cloneable

# A `Cloneable` object has two caracteristics, it can return a copy
# of itself with the method `clone`, and it can initialize itself
# with an object passed to its constructor (a copy constructor).
#
# The `Cloneable` mixin provides the `clone` method implementation,
# the copy constructor have to be implemented by the class willing
# to implement `Cloneable` interface.
#
#     class Dummy
#       Cloneable.attachTo Dummy
#
#       constructor: (@p1, @p2) ->
#         if typeof @p1 is 'object'
#           {@p1, @p2} = @p1
#         # ...
class Cloneable extends Mixin
  ##### Cloneable.attachTo
  #
  # See [Mixin.attachTo](src_geomjs_mixins_mixin.html#mixinattachto)

  ##### Cloneable.included
  #
  # Defines on the passed-in class prototype a `clone` method
  # that will return a copy of the current object when called.
  #
  #     dummy1 = new Dummy(5,6)
  #     dummy2 = dummy1.clone() # [Dummy(p1=5,p2=6)]
  @included: (klass) -> klass::clone = -> new klass this


module.exports = Cloneable
