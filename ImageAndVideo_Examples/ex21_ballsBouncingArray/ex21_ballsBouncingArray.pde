// Coded in class 
// Interaction Lab 2021 Fall
// Rudi's section
// 2021 - 10 - 11

int numberOfInstances = 100;

float[] xPositions = new float[numberOfInstances];
float[] yPositions = new float[numberOfInstances];
color[] cValues = new color[numberOfInstances];
int[] sValues = new int[numberOfInstances];
float[] xSpeeds = new float[numberOfInstances];
float[] ySpeeds = new float[numberOfInstances];

void setup() {
  size(640, 480);
  noStroke();
  colorMode(HSB, 360, 100, 100);
  for (int index = 0; index < numberOfInstances; index++) {
    //You should changes the equations on the right side of the equals sign
    xPositions[index] = random(0, width);
    yPositions[index] = random(-100, -10); //we start the rain
    cValues[index] = color(random(0, 255), random(0, 255), random(0, 255));
    sValues[index] = int(random(1, 25));
    xSpeeds[index] = random(-3, 3);
    ySpeeds[index] = random(1, 10);
  }
}

void draw() {
  background(0);
  for (int index = 0; index < numberOfInstances; index++) {
    display(xPositions[index], yPositions[index], cValues[index], sValues[index]);

    if ((xPositions[index] < sValues[index]/2) || (xPositions[index] > width - sValues[index]/2)) {
      xSpeeds[index] *= -1;
    }
    if ( (yPositions[index] > height - sValues[index]/2)) { //we dont do (yPositions[index] < sValues[index]/2)  because we want the rain to fall 
      yPositions[index] = random(-100, -10);
    }
    xPositions[index] += xSpeeds[index];
    yPositions[index] += ySpeeds[index];
  }
}

void display(float x, float y, color c, int s) {
  fill(c);
  ellipse(x, y, s, s);
}
