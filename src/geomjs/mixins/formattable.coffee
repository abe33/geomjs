# @toc
Mixin = require './mixin'

## Formattable

#
Formattable = (classname, properties...) ->
  #
  class ConcretFormattable extends Mixin
    ##### Formattable.attachTo
    #
    # See
    # [Mixin.attachTo](src_geomjs_mixins_mixin.html#mixinattachto)

    ##### Formattable::toString
    toString: ->
      formattedProperties = ("#{p}=#{@[p]}" for p in properties)
      "[#{classname}(#{formattedProperties.join ', '})]"

    ##### Formattable::classname
    #
    classname: -> classname

module.exports = Formattable
