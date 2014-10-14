(function() {
  window.doki = function(url, options, callback) {
    var analyser, audio, context, flag, interval, keyFrames, monitor, onFrame, source;
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
    monitor = null;
    interval = 40;
    flag = 0;
    keyFrames = [];
    onFrame = function(time) {
      if (keyFrames[flag] && keyFrames[flag].time < time) {
        keyFrames[flag].action();
        return flag++;
      }
    };
    return {
      play: function(offset) {
        flag = 0;
        audio.play();
        return monitor = setInterval(function() {
          return onFrame(source.context.currentTime);
        }, this.interval);
      },
      on: function(time, action) {
        return keyFrames.push({
          time: time,
          action: action
        });
      }
    };
  };

}).call(this);

//# sourceMappingURL=doki.js.map
