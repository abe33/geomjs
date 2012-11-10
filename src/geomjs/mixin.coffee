## Mixin
class Mixin

  ##### Mixin.attachTo
  #
  @attachTo: (klass) -> klass::[k] = v for k,v of this.prototype

module.exports = Mixin
