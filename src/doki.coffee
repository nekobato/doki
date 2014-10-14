window.dokiAudio = (url, options, callback) ->

  context = new ( webkitAudioContext || AudioContext )()
  analyser = context.createAnalyser()

  audio = new Audio()
  audio.src = url
  audio.controls = true
  audio.autoplay = false
  audio.onended = () ->
    clearInterval monitor

  source = context.createMediaElementSource(audio)
  source.connect(context.destination)

  debug = false
  monitor = null
  interval = 40
  flag = 0
  keyFrames = []

  debug = true if options and options.debug

  onFrame = (time) ->
    console.log(time) if debug
    if keyFrames[flag] and keyFrames[flag].time < time
      keyFrames[flag].action()
      flag++

 
  play: (offset) ->
    if not audio.paused
      clearInterval monitor
      audio.pause()
      return @

    audio.play()
    # BGM Doki
    monitor = setInterval () ->
      onFrame(source.mediaElement.currentTime)
    , interval
    return @

  on: (time, action) ->
    keyFrames.push
      time: time
      action: action
    return @

