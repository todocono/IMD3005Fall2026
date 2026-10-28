import processing.sound.*;

// declare a SoundFile object
SoundFile sound;

void setup() {
  size(640, 480);
  // create the instance and load the file
  sound = new SoundFile(this, "isthatyou.aiff");
}

void draw() {
  // every four seconds
  if (millis() % 4000 < 50) {
    // check if the file is already playing
    if (sound.isPlaying() == false) {
      // if it is not playing, play it
      sound.play();
    }
  }

  background(0);
  textAlign(RIGHT);
  textSize(30);
  text("millis(): " + millis(), width-200, height/2-50);
  text("millis() % 4000: " + millis()%4000, width-200, height/2+50);
}
