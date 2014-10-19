(function() {
  window.dokiAudio = function(targetAudio, options, callback) {
    var audio, flag, keyFrames, monitor, onFrame;
    options = options || {};
    if (typeof targetAudio === "string") {
      audio = document.body.appendChild(new Audio(targetAudio));
    } else {
      audio = targetAudio;
    }
    audio.autoplay = false;
    audio.onended = clearInterval(monitor);
    keyFrames = [];
    monitor = null;
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
        var event, i, keyFrame, _i, _len;
        event = {
          time: time,
          action: action
        };
        if (!keyFrames.length) {
          keyFrames.push(event);
          return this;
        }
        for (i = _i = 0, _len = keyFrames.length; _i < _len; i = ++_i) {
          keyFrame = keyFrames[i];
          if (keyFrame.time > time) {
            keyFrames.splice(i, 0, event);
            return this;
          }
        }
        keyFrames.push(event);
        return this;
      }
    };
  };

}).call(this);

//# sourceMappingURL=doki.js.map
