import processing.video.*;

Movie myMovie;

void setup() {
  size(1024, 576);
  myMovie = new Movie(this, "jing'an.mp4");
  myMovie.loop();
}

void draw() {
  background(255);
  if (myMovie.available()) {
    myMovie.read();
  }
  pushMatrix();
  translate(mouseX, mouseY);
  rotate(radians(map(mouseY, 0, height, 0, 360)));
  //imageMode(CENTER);
  image(myMovie, 0, 0, width/3, height/3);
  popMatrix();
}
