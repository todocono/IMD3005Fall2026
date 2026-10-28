import processing.video.*;

Movie myMovie;

void setup() {
  size(512, 288);
  myMovie = new Movie(this, "Jing'an.mp4");
  myMovie.loop();
}

void draw() {
  if (mousePressed) {
    if (myMovie.available()) {
      myMovie.read();
    }
  }
  image(myMovie, 0, 0);
}
