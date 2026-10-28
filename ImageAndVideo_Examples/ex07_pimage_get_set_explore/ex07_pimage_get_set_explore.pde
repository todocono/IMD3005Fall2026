PImage img1;
color mouseColor;
float mouseR, mouseG, mouseB;

void setup() {
  size(500, 413);
  img1 = loadImage("bob.jpg");
  image(img1, 0, 0, width, height);
  filter(GRAY);
}

void draw() {
  //image(img1,0,0,width,height);
  mouseColor = img1.get(mouseX, mouseY);
  mouseR = red(mouseColor);
  mouseG = green(mouseColor);
  mouseB = blue(mouseColor);
  //println(mouseR+" "+mouseG+" "+mouseB);
  //set(width/2,height/2,mouseColor);
  fill(mouseColor);
  noStroke();
  square(width/2, height/2, 50);
}

void mousePressed() {
  println(mouseX, mouseY);
}
