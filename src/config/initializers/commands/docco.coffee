Neat = require 'neat'
{findSync} = Neat.require "utils/files"

module.exports = (config) ->

  dirs = [
    'src/geomjs'
  ]

  sources = []
  sources = sources.concat findSync('coffee', d)?.sort() for d in dirs

  config.docco.paths.sources = sources.compact()
