import processing.sound.*;

// declare three SoundFile objects
SoundFile kick;
SoundFile snare;
SoundFile hihat;

void setup() {
  size(640, 480);
  // create the objects and load sounds into them
  kick = new SoundFile(this, "kick.wav");
  snare = new SoundFile(this, "snare.wav");
  hihat = new SoundFile(this, "hihat.aif");
}

void draw() {
  background(0);
}

void keyPressed() {
  if (key == 'k') {
    kick.play();
    background(255, 0, 0);
  } else if (key == 's') {
    snare.play();
    background(0, 255, 0);
  } else if (key == 'h') {
    hihat.play();
    background(0, 0, 255);
  }
}
