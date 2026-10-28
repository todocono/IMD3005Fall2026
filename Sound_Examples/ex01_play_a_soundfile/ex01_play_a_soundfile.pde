import processing.sound.*;

// declare a SoundFile object
SoundFile sound;

void setup() {
  size(640, 480);
  
  // create the SoundFile instance and 
  // load the audio file in from the data folder
  sound = new SoundFile(this, "Submarine.aiff");
  
  // play the sound on loop
  sound.loop();
}

void draw() {
  background(0);
}
