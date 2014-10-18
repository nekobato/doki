(function() {
  window.dokiAudio = function(audioElm, options, callback) {
    var AudioContext, audio, context, flag, keyFrames, monitor, onFrame, source;
    options = options || {};
    AudioContext = window.AudioContext || window.webkitAudioContext;
    context = new AudioContext();
    audio = audioElm;
    audio.autoplay = false;
    audio.onended = clearInterval(monitor);
    source = context.createMediaElementSource(audio);
    source.connect(context.destination);
    monitor = null;
    keyFrames = [];
    flag = 0;
    (function() {
      options.debug || (options.debug = false);
      options.interval || (options.interval = 40);
      if (callback) {
        return callback();
      }
    });
    onFrame = function(time) {
      if (options.debug) {
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
          return onFrame(audio.currentTime);
        }, this.interval);
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
