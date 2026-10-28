// Background substraction using 
// code from https://github.com/processing/processing-video/blob/master/examples/Capture/BackgroundSubtraction/BackgroundSubtraction.pde

/**
 * Background Subtraction 
 * by Golan Levin. 
 *
 * Detect the presence of people and objects in the frame using a simple
 * background-subtraction technique. To initialize the background, press a key.
 */

import processing.video.*;
String[] cameras = Capture.list();

int numPixels;
int[] backgroundPixels;
Capture video;
int TSCAN = 100;  //time used to scan the differences
int THR = 100;    //threshold of difference for the background substraction

void setup() {
  //fullScreen();
  size(640, 480);

  // This the default video input, see the GettingStartedCapture
  // example if it creates an error
  //video = new Capture(this, 160, 120);
  video = new Capture(this, cameras[0]);

  // Start capturing the images from the camera
  video.start();

  numPixels = video.width * video.height;
  // Create array to store the background image
  backgroundPixels = new int[numPixels];
  // Make the pixels[] array available for direct manipulation
  loadPixels();
}

void draw() {
  if (video.available()) {
    video.read(); // Read a new video frame
    video.loadPixels(); // Make the pixels of video available
    // Difference between the current frame and the stored background
    //float presenceSum = 0;
    for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
      // Fetch the current color in that location, and also the color
      // of the background in that spot
      color currColor = video.pixels[i];
      color bkgdColor = backgroundPixels[i];
      // Extract the red, green, and blue components of the current pixel's color
      float currR = red(currColor);//(currColor >> 16) & 0xFF;
      float currG = green(currColor);// >> 8) & 0xFF;
      float currB = blue(currColor);// & 0xFF;
      // Extract the red, green, and blue components of the background pixel's color
      float bkgdR = red(bkgdColor);// >> 16) & 0xFF;
      float bkgdG = green(bkgdColor);// >> 8) & 0xFF;
      float bkgdB = blue(bkgdColor);// & 0xFF;
      // Compute the difference of the red, green, and blue values
      float diffR = abs(currR - bkgdR);
      float diffG = abs(currG - bkgdG);
      float diffB = abs(currB - bkgdB);
      // Add these differences to the running tally
      // presenceSum += diffR + diffG + diffB;
      // Render the difference image to the screen
      if ((diffR > THR) || (diffG > THR) || (diffB > THR) ) {
        pixels[i] = color(diffR, diffG, diffB);
      }else{
        pixels[i] = color(currR, currG, currB);
      }
      // pixels[i] = color(diffR, diffG, diffB);
      // The following line does the same thing much faster, but is more technical
      // pixels[i] = 0xFF000000 | (diffR << 16) | (diffG << 8) | diffB;
    }
    updatePixels(); // Notify that the pixels[] array has changed
    // println(presenceSum); // Print out the total amount of movement
  }
  //once in a while, we capture the current background
  if ( (millis() % TSCAN) < 50) {
    arrayCopy(video.pixels, backgroundPixels);
  }
}

// When a key is pressed, capture the background image into the backgroundPixels
// buffer, by copying each of the current frame's pixels into it.
void keyPressed() {
  video.loadPixels();
  arrayCopy(video.pixels, backgroundPixels);
}
