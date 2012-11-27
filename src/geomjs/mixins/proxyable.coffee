Mixin = require './mixin'

class Proxyable extends Mixin
  @included: (klass) ->
    klass.proxyable = (type, target) ->
      for k,v of target
        v.proxyable = type
        klass::[k] = v
      target

module.exports = Proxyable
