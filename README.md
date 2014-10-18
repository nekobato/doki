Doki
====

Play Web Audio as Flash's Streaming Sound

## Usage

```
<script src="../dist/doki.js">

<audio id="doki">
  <source src="play.mp3" />
  <source src="play.ogg" />
</audio>

<script>
doki = new dokiAudio(document.getElementById("doki"), {debug: true});

doki.on(30, function() {
  console.log('30 sec');
});

doki.play();
</script>
```
