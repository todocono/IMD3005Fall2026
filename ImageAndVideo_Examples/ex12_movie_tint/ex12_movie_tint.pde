import processing.video.*;

Movie myMovie;

void setup() {
  size(512, 288);
  myMovie = new Movie(this, "jing'an.mp4");
  myMovie.play();
}

void draw() {
  if (myMovie.available()) {
    myMovie.read();
  }
  tint(255, 0, 0);
  image(myMovie, 0, 0);
}
