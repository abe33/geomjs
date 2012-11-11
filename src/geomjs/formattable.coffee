Mixin = require './mixin'

Formattable = (classname, properties...) ->
  class extends Mixin
    toString: ->
      formattedProperties = ("#{p}=#{@[p]}" for p in properties)
      "[#{classname}(#{formattedProperties.join ', '})]"

    classname: -> classname

module.exports = Formattable
