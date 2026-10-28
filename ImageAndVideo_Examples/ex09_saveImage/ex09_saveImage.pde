// IMA @ NYU Shanghai
void setup() {
  size(500,600);
  background(255);
}

void draw() {
  if (mousePressed) {
    strokeWeight(10);
    line(pmouseX, pmouseY, mouseX, mouseY);
  }
}
void mouseReleased() {
  saveFrame("frame.jpg");
}
