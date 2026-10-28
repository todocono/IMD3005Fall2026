import processing.sound.*;

// declare an AudioIn object
AudioIn microphone;
// declare an Amplitude analysis object to detect the volume of sounds
Amplitude analysis;

void setup() {
  size(640, 480);
  // create the AudioIn object and select the mic as the input stream
  microphone = new AudioIn(this, 0);
  // start the mic input without routing it to the speakers
  microphone.start();
  // create the Amplitude analysis object
  analysis = new Amplitude(this);
  // use the microphone as the input for the analysis
  analysis.input(microphone);
}

void draw() {
  println(analysis.analyze());
  background(0);

  // analyze the audio for its volume level
  float volume = analysis.analyze();
  // map the volume value to a useful scale
  float diameter = map(volume, 0, 1, 0, width);
  // draw a circle based on the microphone amplitude (volume)
  circle(width/2, height/2, diameter);
}
