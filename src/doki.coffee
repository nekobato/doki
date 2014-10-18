window.dokiAudio = (targetAudio, options, callback) ->

  options = options || {}
  
  if typeof targetAudio is "string" # URL
    audio = document.body.appendChild new Audio(targetAudio)
  else # AudioTag
    audio = targetAudio

  audio.autoplay = false
  audio.onended  = clearInterval(monitor)

  AudioContext = window.AudioContext || window.webkitAudioContext
  context = new AudioContext()

  source = context.createMediaElementSource(audio)
  source.connect(context.destination)

  keyFrames = []
  monitor = null
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
    event =
      time: time
      action: action
    
    if not keyFrames.length
      keyFrames.push event
      return @

    for keyFrame, i in keyFrames
      if keyFrame.time > time
        keyFrames.splice i, 0, event
        return @

    keyFrames.push event
    return @

