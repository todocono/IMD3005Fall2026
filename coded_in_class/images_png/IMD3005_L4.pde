

PImage img;
PImage img2;

void setup() {
  size(640, 480);

  img = loadImage("forest.jpg");
  img2 = loadImage("mario.png");
}

void draw() {
  image(img,0,0);
  image(img2,mouseX,mouseY,91,155);
}
