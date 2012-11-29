
global.proxyable = (source) ->
  shouldDefine: (methods) ->
    asProxyable: ->
      methods.map (method, type) ->
        describe "its #{method} method", ->
          it "should be proxyable as #{type}", ->
            meth = this[source][method].proxyable
            expect(meth).toBe(type)


