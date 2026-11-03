/*
 * Filtering with a simple moving average filter
 * IMD3005 · Fall 2026 · Lesson 7
 *
 * For more info, check https://www.analog.com/media/en/technical-documentation/dsp-book/dsp_book_Ch15.pdf
 * Kudos to the Arduino team, https://docs.arduino.cc/built-in-examples/analog/Smoothing/
 */

import processing.sound.*;

AudioIn microphone; // declare an AudioIn object
Amplitude analysis; // declare an Amplitude analysis object

int samples = 100;
int index;
float[] volume = new float[samples];

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
  
  // this example has the same effect than smoothing in Arduino
  // but the implementation is radically different because of the for loop
  volume[index] =  volumeNow;
  //increment the index for next sample
  if (index++ >= samples-1) index = 0;
  
  //calculate the average of the last N samples
  float volumeAvg = 0;
  for (int i=0; i < samples; i++) {
    volumeAvg += volume[i];
  }
  volumeAvg = volumeAvg/samples;

  // map the volume value to a useful scale for drawing
  // (I am using 0.5 as the range for volume)
  float hNow = map(volumeNow, 0, 0.5, 0, width);
  float hAvg =  map(volumeAvg, 0, 0.5, 0, width);
  
  //draw them in the format of horizontal bars
  fill(#20BF55);
  rect(0, 0, hNow, height/2);
  fill(#01BAEF);
  rect(0, height/2, hAvg, height);
  
  //labels
  fill(255);
  textSize(30);
  text("Sampled now", (width/2)-100, height/4);
  text("Average with "+samples+" samples", (width/2)-150, 3*height/4);
}
