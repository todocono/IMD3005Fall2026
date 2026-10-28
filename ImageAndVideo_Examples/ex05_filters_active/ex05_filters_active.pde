PImage photo;

void setup() {
 size(600, 600);
 photo = loadImage("yao.gif");

}

void  draw() {
   image(photo, 0, 0);
   filter(THRESHOLD, map(mouseX, 0.0, width, 0,1));
}
