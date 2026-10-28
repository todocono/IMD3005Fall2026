import processing.video.*;
Movie myMovie;

void setup() {
  size(512, 288);
  myMovie = new Movie(this, "Jing'An.mp4");
  myMovie.loop();
}

void draw() {
  if (myMovie.available()) {
    myMovie.read();
  }

  image(myMovie, 0, 0);
}

void keyPressed() {
  myMovie.jump(0);
  //myMovie.jump(myMovie.duration()/2);
  //myMovie.jump(random(myMovie.duration()));
}
