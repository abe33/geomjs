Mixin = require './mixin'

Parameterizable = (method, parameters, allowPartial=false) ->
  class extends Mixin
    @included: (klass) ->
      f = (args..., strict)->
        (args.push(strict); strict = false) if typeof strict is 'number'
        output = {}

        o = arguments[0]
        if o? and typeof o is 'object'
          output[k] = parseFloat o[k] for k of parameters
        else
          n = 0
          output[k] = parseFloat arguments[n++] for k,v of parameters

        for k,v of parameters
          if isNaN output[k]
            if strict
              keys = (k for k in parameters).join ', '
              throw new Error "#{output} doesn't match pattern {#{keys}}"
            if allowPartial then delete output[k] else output[k] = v

        output

      klass[method] = f
      klass::[method] = f

module.exports = Parameterizable
