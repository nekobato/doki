window.doki = (url, options, callback) ->

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

  monitor = null
  interval = 40 # 25fps
  flag = 0
  keyFrames = []

  onFrame = (time) ->
    if keyFrames[flag] and keyFrames[flag].time < time
      keyFrames[flag].action()
      flag++

 
  play: (offset) ->
    flag = 0
    audio.play()
    # BGM Doki
    monitor = setInterval () ->
      onFrame(source.context.currentTime)
    , @interval

  on: (time, action) ->
    keyFrames.push
      time: time
      action: action

