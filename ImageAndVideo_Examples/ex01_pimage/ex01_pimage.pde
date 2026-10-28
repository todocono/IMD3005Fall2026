//
//image source https://shanghai.nyu.edu/is/its-here-nyu-shanghais-very-own-qilin-mascot-has-landed-wechat-sticker-store

PImage photo;

void setup() {
  size(933, 531);
  photo = loadImage("qilin.png");
}

void draw() {
  image(photo, 0, 0);
}
