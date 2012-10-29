
global.acreageOf = (source) ->
  shouldBe: (acreage) ->
    it "should have an acreage of #{acreage}", ->
      expect(@[source].acreage()).toBe(acreage)
