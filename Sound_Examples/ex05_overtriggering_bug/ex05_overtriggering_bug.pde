import processing.sound.*;

// declare a SoundFile object
SoundFile sound;

int radius = 100;

void setup() {
  size(640, 480);
  // create the instance and load the file
  sound = new SoundFile(this, "isthatyou.aiff");
}

void draw() {
  background(0);
  circle(width/2, height/2, radius*2);

  // when the mouse is over the circle
  if (dist(width/2, height/2, mouseX, mouseY) < radius) {
    sound.play();
    fill(200, 0, 100);
  } else {
    fill(255);
  }
}
