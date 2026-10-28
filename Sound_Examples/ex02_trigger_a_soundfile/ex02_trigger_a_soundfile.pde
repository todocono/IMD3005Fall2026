import processing.sound.*;

// declare a SoundFile object
SoundFile sound;

void setup() {
  size(640, 480);
  // create the instance and load the file
  sound = new SoundFile(this, "cello-f2.aif");
}

void draw() {
  background(0);
}

void mouseClicked() {
  // when the mouse is clicked, play the sound once
  sound.play();
}
