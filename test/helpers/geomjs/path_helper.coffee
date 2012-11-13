
global.lengthOf = (source) ->
  shouldBe: (length) ->
    it "should have a length of #{length}", ->
      expect(@[source].length()).toBeClose(length)
