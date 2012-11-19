Mixin = require './mixin'

Sourcable = (name, signature...) ->
  class ConcretSourcable extends Mixin
    toSource: ->
      args = (@[arg] for arg in signature).map (o) ->
        if typeof o is 'object'
          isArray = Object::toString.call(o).indexOf('Array') isnt -1
          if o.toSource?
            o.toSource()
          else
            if isArray
              "[#{o.map (el) -> if el.toSource? then el.toSource() else el}]"
            else
              o
        else
          o

      "new #{name}(#{args.join ','})"

module.exports = Sourcable
