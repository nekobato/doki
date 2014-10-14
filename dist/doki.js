(function() {
  window.dokiAudio = function(url, options, callback) {
    var analyser, audio, context, debug, flag, interval, keyFrames, monitor, onFrame, source;
    context = new (webkitAudioContext || AudioContext)();
    analyser = context.createAnalyser();
    audio = new Audio();
    audio.src = url;
    audio.controls = true;
    audio.autoplay = false;
    audio.onended = function() {
      return clearInterval(monitor);
    };
    source = context.createMediaElementSource(audio);
    source.connect(context.destination);
    debug = false;
    monitor = null;
    interval = 40;
    flag = 0;
    keyFrames = [];
    if (options && options.debug) {
      debug = true;
    }
    onFrame = function(time) {
      if (debug) {
        console.log(time);
      }
      if (keyFrames[flag] && keyFrames[flag].time < time) {
        keyFrames[flag].action();
        return flag++;
      }
    };
    return {
      play: function(offset) {
        if (!audio.paused) {
          clearInterval(monitor);
          audio.pause();
          return this;
        }
        audio.play();
        monitor = setInterval(function() {
          return onFrame(source.mediaElement.currentTime);
        }, interval);
        return this;
      },
      on: function(time, action) {
        keyFrames.push({
          time: time,
          action: action
        });
        return this;
      }
    };
  };

}).call(this);

//# sourceMappingURL=doki.js.map
