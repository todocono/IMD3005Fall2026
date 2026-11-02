/*
 * Filtering with a lerp as a low pass filter
 * IMD3005 · Fall 2026 · Lesson 7
 *
 * For more info, check https://hankyukim.com/average-filter/
 */

import processing.sound.*;


AudioIn microphone; // declare an AudioIn object
Amplitude analysis; // declare an Amplitude analysis object

float volumeAvg;
float DAMPENING = 0.1;
float x,y;

void setup() {
  size(640, 480);
  // create the AudioIn object and select the mic as the input stream
  microphone = new AudioIn(this, 0);
  // start the mic input without routing it to the speakers
  microphone.start();
  // create the Amplitude analysis object
  analysis = new Amplitude(this);
  // use the microphone as the input for the analysis
  analysis.input(microphone);
  noStroke();
}

void draw() {
  background(0);
  
  // tiny visualization to see what lerp is doing
  fill(125);
  x = lerp(x,mouseX,DAMPENING);
  y = lerp(y,mouseY,DAMPENING);
  circle(x,y,50);

  // analyze the audio for its volume level
  float volumeNow = analysis.analyze();
  // use lerp as an averaging for the signal
  volumeAvg =  lerp(volumeAvg, volumeNow, DAMPENING);

  // map the volume value to a useful scale
  float hNow =  map(volumeNow, 0, 0.5, 0, width);
  float hAvg = map(volumeAvg, 0, 0.5, 0, width);
  // draw a circle based on the microphone amplitude (volume)
  fill(#20BF55);
  rect(0, 0, hNow, height/2);
  fill(#01BAEF);
  rect(0, height/2, hAvg, height);
  //labels
  fill(255);
  textSize(30);
  text("Sampled now", (width/2)-100, height/4);
  text("Recursive filter with dampening of: "+DAMPENING, (width/2)-250, 3*height/4);
}
