/*
 * Filtering with a lerp as a HIGH pass filter
 * IMD3005 · Fall 2026
 *
 * A live example for filters: https://adamdjellouli.com/tools/filters/
 */

import processing.sound.*;


AudioIn microphone, microphone2; // declare an AudioIn object
Amplitude analysis, analysis2; // declare an Amplitude analysis object
HighPass highPass;    // declare a filter


void setup() {
  size(640, 480);

  microphone = new AudioIn(this, 0); // create object and select mic input stream
  microphone.start(); // start the mic input

  microphone2 = new AudioIn(this, 0); // create object and select mic input stream
  microphone2.start(); // start the mic input

  analysis = new Amplitude(this);// create the Amplitude analysis object
  analysis.input(microphone); // analyze microphone input

  highPass = new HighPass(this);
  highPass.process(microphone2);
  analysis2 = new Amplitude(this);// create the Amplitude analysis object
  analysis2.input(microphone2); // analyze microphone input
  noStroke();
}

void draw() {
  background(0);
  //I found my whistle is higher than 1800Hz

  // Map the left/right mouse position to a cutoff frequency between 20 and 10000 Hz
  float cutoff = map(mouseX, 0, width, 20, 3000);
  highPass.freq(cutoff);
  fill(255, 0, 150);
  rect(0, 0, mouseX, 50);

  float volumeNow = analysis.analyze(); // analyze the raw audio
  // analyze the audio for its volume level after filtering:
  float volumeHP = analysis2.analyze();

  // map the volume value to a useful scale
  float hNow =  map(volumeNow, 0, 0.5, 0, width);
  float hHP = map(volumeHP, 0, 0.5, 0, width);
  // draw a circle based on the microphone amplitude (volume)
  fill(#20BF55);
  rect(0, 50, hNow, height/2);
  fill(#01BAEF);
  rect(0, height/2+50, hHP, height);
  //labels
  fill(255);
  textSize(30);
  text("Filter freq", (width/2)-100, 30);
  text("Sampled volume now", (width/2)-100, height/4+50);
  text("Volume after high pass with " +
    nf(cutoff, 0, 2) +
    " Hz cutoff", (width/2)-250, 3*height/4+50);
}
