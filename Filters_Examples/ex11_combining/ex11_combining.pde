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

int SPEED_GRAPH = 5000; //constant for the plot


AudioIn microphone;     // only ONE mic
FFT fft;                // and only ONE analysis
int bands = 512;        // how many small bands the FFT makes
float[] spectrum = new float[bands];
float binHz;            // how many Hz each small band covers

int filter = 0;  //start with no filter
int LOW = 850;   //the limits of the bands, in Hz
int HIGH = 1500;
float energyAll, energyBand;


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

  float lowPass_energy = 0;
  for (int i = 1; i < LOW/binHz; i++) {   // I skip band 0, it is not a sound (DC offset)
    lowPass_energy += spectrum[i];
  }

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
  x_e = map(lowPass_energy, 0, 0.1, 0, width);
  rect(0, (height-100)/3, x_e, (height-100)/3);
  fill(255);
  text("LOW PASS e with "+LOW+" Hz", width/2, 2*(height-100)/3-50);
  fill(255, 0, 150);
  x_e = map(highPass_energy, 0, 0.1, 0, width);
  rect(0, 2*(height-100)/3, x_e, (height-100)/3);
  fill(255);
  text("e at HIGH PASS with "+HIGH+" Hz", width/2, (height-100)-50);


  // draw the spectrum, just like the Sound example of FFTspectrum

  for (int i = 0; i < bands; i++) {
    fill(125, 255, 125);
    // Draw the rectangles, adjust their height using the scale factor
    rect(i*binHz, height, binHz, constrain(-spectrum[i]*500, -100, 0));
  }
}


void keyPressed() {
  if (key >= '0' && key <= '4') {
    filter = key - '0';
  }
  println(filter);
}
