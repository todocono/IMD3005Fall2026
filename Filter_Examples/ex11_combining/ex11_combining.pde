/*
 * Filtering the speed of movement of the mouse
 * IMD3005 · Fall 2026
 *
 * filter how FAST the mouse moves instead of where it is
 *
 * Uses ideas from https://forum.processing.org/one/topic/using-the-mouse-speed.html
 * It uses an exponential easing (1), moving average(2), median (3), 2nd order LP(4)
 * read about Butterworth at https://en.wikipedia.org/wiki/Stephen_Butterworth
 * and more general information on filters (check the GOOD and BAD responses) https://www.analog.com/media/en/technical-documentation/dsp-book/dsp_book_Ch14.pdf
 */

import processing.sound.*;

AudioIn microphone;     // only ONE mic
FFT fft;                // and only ONE analysis
int bands = 512;        // how many small bands the FFT makes
float[] spectrum = new float[bands];
float binHz;            // how many Hz each small band covers

int filter = 0;  //start with no filter
int LOW = 850;   //the limits of the bands, in Hz
int HIGH = 1500;
float energyAll, energyBand;

//these are the new variables and const I used, compared to ex10
float whistleSmooth, pauseSmooth, whistleMeter;
int whistling, lastWhistle;
float EASING_SIGNAL = 0.1;
float EASING_EVENT = 0.01;
float TRIGGER = 0.6;
int MIN_PAUSE = 100;
float QUIET_LEVEL = 0.01;



void setup() {
  size(640, 480);
  noStroke();
  textAlign(CENTER);

  microphone = new AudioIn(this, 0); // create object and select mic input stream
  microphone.start(); // start the mic input
  fft = new FFT(this, bands);
  fft.input(microphone); // analyze the microphone
  binHz = Sound.sampleRate() / 2.0 / bands; // the FFT covers 0 Hz to half the sample rate
}

void draw() {
  background(50);
  fft.analyze(spectrum);


  float total_energy = 0;
  for (int i = 1; i < bands; i++) {   // I skip band 0, it is not a sound (DC offset)
    total_energy += spectrum[i];
  }

  // I can use the lowPass to detect if there has been a loud low noise, and reset signal
  //float lowPass_energy = 0;
  //for (int i = 1; i < LOW/binHz; i++) {   // I skip band 0, it is not a sound (DC offset)
  //  lowPass_energy += spectrum[i];
  //}

  float highPass_energy = 0;
  for (int i = (int)(HIGH/binHz); i < bands; i++) {   // I skip band 0, it is not a sound (DC offset)
    highPass_energy += spectrum[i];
  }
  fill(125);
  //println(total_energy + " _ " + lowPass_energy + " _ " + highPass_energy);
  float x_e = map(total_energy, 0, 0.1, 0, width);
  rect(0, 0, x_e, (height-100)/3);
  fill(255);
  text("TOTAL e", width/2, (height-100)/3-50);
  fill(150, 0, 255);
  x_e = map(highPass_energy, 0, 0.1, 0, width);
  rect(0, (height-100)/3, x_e, (height-100)/3);
  fill(255);
  text("HIGH PASS e with "+LOW+" Hz", width/2, 2*(height-100)/3-50);



  // 1. smoothing the signal of whistle
  float whistleNow = 0;
  if (total_energy > QUIET_LEVEL) { //only if it's not silent
    whistleNow = highPass_energy / total_energy; //I check the ratio - there are better ways to do this
  }
  whistleSmooth += (whistleNow - whistleSmooth) * EASING_SIGNAL;

  fill(255, 0, 150);
  x_e = map(whistleSmooth, 0, 1, 0, width);
  rect(0, 2*(height-100)/3, x_e, (height-100)/3);
  fill(255);
  text("smoothed e at HIGH PASS with "+HIGH+" Hz", width/2, (height-100)-50);



  // 2. detect
  if (whistleSmooth > TRIGGER) {
    lastWhistle = millis();        // still hearing it
    if (whistling == 0) {          // 3. lock in: count once per whistle
      whistling = 1;
      whistleMeter++;
    }
  } else {
    if (whistling == 1 && millis() - lastWhistle > MIN_PAUSE) {
      whistling = 0;                 // 4. a long enough pause unlocks it
    }
    whistleMeter *= (1 - EASING_EVENT);   // old whistles fade (leaky counter)
  }

  fill(255);
  text("whistles: " + whistleMeter, width/2, height-130);
  if (whistling == 1) text("WHISTLING", width/2, height-110);

  fill(255, 0, 0);
  if (whistleMeter > 3) text("3 WHISTLES!", width/2, height-50);
}
