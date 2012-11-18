Mixin = require './mixin'

Sourcable = (name, signature...) ->
  class extends Mixin
    toSource: ->
      args = (@[arg] for arg in signature).map (o) ->
        if typeof o is 'object'
          if o.toSource? then o.toSource() else o
        else
          o

      "new #{name}(#{args.join ','})"

module.exports = Sourcable
