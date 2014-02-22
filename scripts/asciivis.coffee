require([
  '$api/models'
  '$api/audio'
], (models, audio) ->
  'use strict'

  width = 128
  height = 14

  render = (wave) ->
    screen = for x in [0..width]
      for y in [0..height]
        ' '
    for index in [0..width]
      prev = height/2
      if index > 0
        prev = wave[index - 1]
      current = wave[index]
      next = height/2
      if index < wave.length - 1
        next = wave[index + 1]

      # l = low
      # m = medium
      # h = high
      
      # mmm
      if prev == current && current == next
        char = '-'
      # hlh
      else if prev < current && next < current
        char = 'v'
      # lhl
      else if prev > current && next > current
        char = '^'
      # hlm
      else if prev < current && next == current
        char = '`'
      # lhm
      else if prev > current && next == current
        char = ','
      # mml
      else if prev == current && next > current
        char = '.'
      # mmh
      else if prev == current && next < current
        char = '\''
      # lmh
      else if prev > current && next < current
        char = '/'
      # hml
      else if prev < current && next > current
        char = '\\'
      else
        console.log index + '/' + wave.length + ' '  + prev + ' ' + current + ' ' + next

      screen[index][current] = char

    output = ''
    for y in [0..height]
      for x in [0..width]
        output += screen[x][y]
      output += '\n'
    document.getElementById('asciiVis').innerHTML=output

  doAsciiVis = () ->
    waveWidth = 1024
    def = for x in [0..width]
      height / 2
    render def

    analyzer = audio.RealtimeAnalyzer.forPlayer(models.player)
    analyzer.addEventListener 'audio', (data) ->
      segWidth = waveWidth / width
      wave = []
      for index in [0..width]
        avg = 0
        for n in data.audio.wave.left[segWidth * index..segWidth * index + segWidth]
          avg += n
        avg /= segWidth
        position = Math.floor((height / 2) + ((height/2) * avg))
        wave.push position

      render wave


  exports.doAsciiVis = doAsciiVis
)
