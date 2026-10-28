import processing.sound.*;

SoundFile sound;

// declare an Amplitude analysis object to detect the volume of sounds
Amplitude analysis;

void setup() {
  size(640, 480);

  // load and play a sound file in a loop
  sound = new SoundFile(this, "beat.aiff");
  sound.loop();

  // create the Amplitude analysis object
  analysis = new Amplitude(this);
  // use the soundfile as the input for the analysis
  analysis.input(sound);
}

void draw() {
  println(analysis.analyze());
  background(0);

  // analyze the audio for its volume level
  float volume = analysis.analyze();
  // map the volume value to a useful scale
  float diameter = map(volume, 0, 1, 0, width);
  // draw a circle based on the soundfile's amplitude (volume)
  circle(width/2, height/2, diameter);
}
