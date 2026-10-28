import processing.sound.*;

// declare an AudioIn object
AudioIn microphone;
// declare an Frequency analysis object to detect the frequencies in a sound
FFT freqAnalysis;
// declare a variable for the amount of frequencies to analyze
// should be a multiple of 64 for best results
int frequencies = 1024;
// Define the frequencies wanted for our visualization.  Above that treshold frequencies are rarely atteigned and stay flat.
int freqWanted = 128;
// declare an array to store the frequency anlysis results in
float[] spectrum = new float[freqWanted];
// Declare a drawing variable for calculating the width of the
float circleWidth;

void setup() {
  size(512, 480);
  // Calculate the width of the circles depending on how the bands we want to display.
  circleWidth = width/float(freqWanted);
  // create the AudioIn object and select the mic as the input stream
  microphone = new AudioIn(this, 0);
  // start the mic input without routing it to the speakers
  microphone.start();
  // create the Frequency analysis object and tell it how many frequencies to analyze
  freqAnalysis = new FFT(this, frequencies);
  // use the microphone as the input for the analysis
  freqAnalysis.input(microphone);
}

void draw() {
  // analyze the frequency spectrum and store it in the array
  freqAnalysis.analyze(spectrum);
  printArray(spectrum);
  background(0);
  fill(200, 0, 100, 150);
  noStroke();

  // draw circles based on the values stored in the spectrum array
  // adjust the scale variable as needed
  float scale = 4000;
  for (int i=0; i<freqWanted; i++) {
    circle(i*circleWidth, height/2, spectrum[i]*scale);
  }
}
