# @toc

## Mixin
class Mixin

  ##### Mixin.attachTo
  #
  @attachTo: (klass) ->
    klass::[k] = v for k,v of this.prototype
    @included? klass

module.exports = Mixin
