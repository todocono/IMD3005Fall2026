/*
 * Filtering with a lerp as a low pass filter
 * IMD3005 · Fall 2026
 *
 * For more info on low pass: https://hankyukim.com/low-pass-filter/
 * and DSP in general: https://www.analog.com/en/resources/analog-dialogue/articles/dsp-101-part-1.html
 */

import processing.sound.*;


AudioIn microphone, microphone2; // declare an AudioIn object
Amplitude analysis, analysis2; // declare an Amplitude analysis object
BandPass bandPass;    // declare a filter

float volumeAvg;
float DAMPENING = 0.1;
float x, y;

void setup() {
  size(640, 480);

  microphone = new AudioIn(this, 0); // create object and select mic input stream
  microphone.start(); // start the mic input

  microphone2 = new AudioIn(this, 0); // create object and select mic input stream
  microphone2.start(); // start the mic input

  analysis = new Amplitude(this);// create the Amplitude analysis object
  analysis.input(microphone); // analyze microphone input

  bandPass = new BandPass(this);
  bandPass.process(microphone2);
  analysis2 = new Amplitude(this);// create the Amplitude analysis object
  analysis2.input(microphone2); // analyze microphone input
  noStroke();
}

void draw() {
  background(0);

  //I used ToneGenerator for iOS https://apps.apple.com/ca/app/tone-generator-audio-sound-hz/id1206449238
  //for Android: https://play.google.com/store/apps/details?id=com.tmsoft.whitenoise.generator.tone&hl=en_CA
  //I found I stop hearing after 14kHz

  // Map the left/right mouse position to a cutoff frequency between 20 and 10000 Hz
  float freqCenter = map(mouseX, 0, width, 20, 20000);
  bandPass.freq(freqCenter);
  fill(255, 0, 150);
  rect(50, 0, mouseX, 50);

  float bandwidth = map(mouseY, 0, height, 1000, 100);
  bandPass.bw(bandwidth);
  fill(150, 0, 250);
  rect( 0, mouseY, 50, height);

  float volumeNow = analysis.analyze(); // analyze the raw audio
  // analyze the audio for its volume level after filtering:
  float volumeBP = analysis2.analyze();

  // map the volume value to a useful scale
  float hNow =  map(volumeNow, 0, 0.5, 0, width);
  float hLP = map(volumeBP, 0, 0.5, 0, width);
  // draw
  fill(#20BF55);
  rect(50, 50, hNow, height/2);
  fill(#01BAEF);
  rect(50, height/2+50, hLP, height);
  //labels
  fill(255);
  textSize(30);
  //trick to rotate the text, inspired by https://processing.org/examples/textrotation.html
  push();
  translate(30,2*width/3);
  rotate(-radians(90));
  text("Letting "+ nf(bandwidth, 0, 2) +
    " Hz pass", 0, 0);
  pop();
  text("Filter central freq: "+ nf(freqCenter, 0, 2) +
    " Hz", (width/2)-100, 30);
  text("Sampled volume now", (width/2)-100, height/4+50);
  text("Volume after band pass ", (width/2)-100, 3*height/4+50);
}
