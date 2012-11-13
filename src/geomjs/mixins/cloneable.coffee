# @toc
Mixin = require './mixin'

## Cloneable
class Cloneable extends Mixin
  @included: (klass) -> klass::clone = -> new klass this

module.exports = Cloneable
