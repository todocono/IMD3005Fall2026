import processing.sound.*;

// declare a SoundFile object
SoundFile sound;

float pitch, vol;

void setup() {
  size(640, 480);
  noStroke();
  // create the instance and load the file
  sound = new SoundFile(this, "cello-f2.aif");
}

void draw() {
  background(0);
  // use mouseX to determine the pitch
  // toward left is lower pitched, toward the right is higher pitched
  pitch = map(mouseX, 0, width, 0.1, 5);
  // use mouseY to determine the volume
  // toward the top is louder volume, toward the bottom is softer volume
  vol = map(mouseY, 0, height, 1, 0);

  fill(#305A9D);
  circle(width/2, mouseY, 20);

  fill(#92309D);
  circle(mouseX, height/2, 20);
}


void mouseClicked() {
  // when the mouse is clicked, we play the sound and we adjust the volume and pitch
  if (!sound.isPlaying()) {
    sound.play();
  }
  sound.amp(vol);
  sound.rate(pitch);
}
