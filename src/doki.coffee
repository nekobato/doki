window.dokiAudio = (audioElm, options, callback) ->

  options = options || {}

  AudioContext = window.AudioContext || window.webkitAudioContext

  context = new AudioContext()
  audio = audioElm
  audio.autoplay = false
  audio.onended  = clearInterval(monitor)

  source = context.createMediaElementSource(audio)
  source.connect(context.destination)

  monitor = null
  keyFrames = []
  flag = 0

  # init
  ->
    options.debug    || = false
    options.interval || = 40 # 25fps
    callback() if callback

  onFrame = (time) ->
    console.log time if options.debug
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
      onFrame(audio.currentTime)
    , @interval
    return @

  on: (time, action) ->
    keyFrames.push
      time: time
      action: action
    return @
