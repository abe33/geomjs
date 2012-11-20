# @toc
Mixin = require './mixin'

## Sourcable

# A `Sourcable` object is an object that can return the source code
# to re-create it by code.
#
#     class Dummy
#       Sourcable('geomjs.Dummy', 'p1', 'p2').attachTo Dummy
#
#       constructor: (@p1, @p2) ->
#
#     dummy = new Dummy(10,'foo')
#     dummy.toSource() # "new geomjs.Dummy(10,'foo')"
Sourcable = (name, signature...) ->

  # A concrete class is generated and returned by `Sourcable`.
  # This class extends `Mixin` and can be attached as any other
  # mixin with the `attachTo` method.
  class ConcretSourcable extends Mixin
    ##### Sourcable.attachTo
    #
    # See [Mixin.attachTo](src_geomjs_mixins_mixin.html#mixinattachto)

    ##### Sourcable::toSource
    #
    # Return the source code corresponding to the current instance.
    toSource: ->
      args = (@[arg] for arg in signature).map (o) ->
        switch typeof o
          when 'object'
            isArray = Object::toString.call(o).indexOf('Array') isnt -1
            if o.toSource?
              o.toSource()
            else
              if isArray
                "[#{o.map (el) -> if el.toSource? then el.toSource() else el}]"
              else
                o
          when 'string'
            if o.toSource? then o.toSource() else "'#{o.replace "'", "\\'"}'"
          else o

      "new #{name}(#{args.join ','})"

module.exports = Sourcable
