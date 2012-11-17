Mixin = require './mixin'

Sourcable = (name, signature...) ->
  class extends Mixin
    toSource: ->
      args = (@[arg] for arg in signature).map (o) ->
        if o.toSource then o.toSource() else o

      "new #{name}(#{args.join ','})"

module.exports = Sourcable
