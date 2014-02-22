require([
  '$api/models'
  '$api/audio'
  'scripts/asciivis'
  'scripts/playlist-example'
], (models, audio, asciivis, playlistExample) ->
  'use strict'

  asciivis.doAsciiVis()
  playlistExample.doPlaylistForAlbum()
)
