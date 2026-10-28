// Interaction Lab 2021 Fall
// Background substraction used to react to 
// an array of balls falling as rain
// 2021 - 11 - 23

import processing.video.*;

int numPixels;
color[] backgroundPixels;
Capture video;
int TSCAN = 100;  //time used to scan the differences
int THR = 20;    //threshold of difference for the background substraction

int numberOfInstances = 10;

float[] xPositions = new float[numberOfInstances];
float[] yPositions = new float[numberOfInstances];
color[] cValues = new color[numberOfInstances];
int[] sValues = new int[numberOfInstances];
float[] xSpeeds = new float[numberOfInstances];
float[] ySpeeds = new float[numberOfInstances];


void setup() {
  size(640, 480); // fullScreen();
  noStroke();
  video = new Capture(this, 640, 480);       // example if it creates an error

  video.start();
  numPixels = video.width * video.height;
  backgroundPixels = new color[numPixels];   // Create array to store the background image

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
  if (video.available()) {
    loadPixels();
    video.read(); // Read a new video frame
    video.loadPixels(); // Make the pixels of video available

    //for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        int i = x + y * width;
        float diff = abs(brightness(video.pixels[i]) - brightness(backgroundPixels[i]));

        if ( diff  > THR) {    // I check only pixels that changed in brightness

          pixels[i] = 0;   // you can also use to paint them in black color 0xFF000000;
          //we check if there are collisions of any of the balls in the array
          for (int index = 0; index < numberOfInstances; index++) {
            if ((xPositions[index] > x - sValues[index]/2)
              && (xPositions[index] < x + sValues[index]/2)
              && (yPositions[index] > y - sValues[index]/2)
              && (yPositions[index] < y + sValues[index]/2)) {
              xSpeeds[index] *= -1;
              ySpeeds[index] *= -1;
            }
          }
        } else {
          pixels[i] =  video.pixels[i];
        }
      }
    }
    updatePixels(); // Notify that the pixels[] array has changed
    // println(presenceSum); // Print out the total amount of movement
  }
  //once in a while, we capture the current background
  if ( (millis() % TSCAN) < 50) {
    arrayCopy(video.pixels, backgroundPixels);
  }

  //we display the rain
  for (int index = 0; index < numberOfInstances; index++) {
    fill( cValues[index]);
    ellipse(xPositions[index], yPositions[index], sValues[index], sValues[index]);

    if ((xPositions[index] < sValues[index]/2) || (xPositions[index] > width - sValues[index]/2)) {
      xSpeeds[index] *= -1;
    }
    if ( (yPositions[index] > height - sValues[index]/2) || (yPositions[index] < - 200 ) ) {
      yPositions[index] = random(-100, -10);
      ySpeeds[index] = random(1, 10);
    }
    xPositions[index] += xSpeeds[index];
    yPositions[index] += ySpeeds[index];
  }
}
