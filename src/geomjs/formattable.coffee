Mixin = require './mixin'

Formattable = (properties...) ->
  class Formattable extends Mixin
    toString: ->
      className = @constructor.name
      formattedProperties = ("#{p}=#{@[p]}" for p in properties)
      "[#{className}(#{formattedProperties.join ', '})]"

module.exports = Formattable
