/*
 * Filtering with a recursive filter
 * IMD3005 · Fall 2026 · Lesson 7
 *
 * For more info, check https://hankyukim.com/average-filter/
 * and https://read.nxtbook.com/ieee/signal_processing/signal_processing_nov_2023/implementing_moving_average_f.html
 */

import processing.sound.*;

AudioIn microphone; // declare an AudioIn object
Amplitude analysis; // declare an Amplitude analysis object

float volumeAvg;
float DAMPENING = 0.01;

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

  // analyze the audio for its volume level
  float volumeNow = analysis.analyze();
  // do a simple averaging with the signal
  volumeAvg =  (1-DAMPENING) * volumeAvg  + DAMPENING * volumeNow;

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
