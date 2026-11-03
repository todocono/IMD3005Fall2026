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


  // the spectrum

  for (int i = 0; i < bands; i++) {
    fill(125, 255, 125);
    // Draw the rectangles, adjust their height using the scale factor
    // I used this line from the Sound example of FFTspectrum
    rect(i*binHz, height, binHz, constrain(-spectrum[i]*500,-100,0));
  }


  //  // Plot signals for clarity of the example
  //  float plotT = map(millis()%SPEED_GRAPH, 0, SPEED_GRAPH, 0, width);
  //  noStroke();
  //  fill(0);
  //  rect(plotT, 0, 10, 200);
  //  strokeWeight(2);
  //  stroke(0, 255, 0);
  //  point(plotT, 100+(speed_X * 15));
  //  noStroke();
  //  fill(0);
  //  rect((width/2)-100, 0, 200, 40);
  //  fill(255);
  //  if (speed_X >  MOVING_SPEED)  text("RAW moving RIGHT", width/2, 15);
  //  if (speed_X < -MOVING_SPEED)  text("RAW moving LEFT", width/2, 15);


  //  //I smooth the speed to accurately represent the intention of the user
  //  //Instead of the same as ex1, using smooth_speed_X += (speed_X - smooth_speed_X) * easing;
  //  //I use a filter which changes with the keyPressed
  //  smooth_speed_X = smoothing(speed_X);

  //  //Now I rinse and repeat the plotting but for the smooth speed
  //  strokeWeight(2);
  //  stroke(255, 0, 125);
  //  point(plotT, 100+(smooth_speed_X * 15));
  //  fill(255);
  //  if (smooth_speed_X > MOVING_SPEED)  text("moving RIGHT", width/2, 30);
  //  if (smooth_speed_X < -MOVING_SPEED)  text("moving LEFT", width/2, 30);

  //  // Smoothly interpolate current position toward the mouse position
  //  // I left it here from the previous example, just FYI
  //  fill(50);
  //  noStroke();
  //  rect(0, 200, width, height);  //clear the screen
  //  //float targetX = mouseX;
  //  //x += (targetX - x) * easing; //which is equivalent to filteredX = (alpha * mouseX) + ((1.0 - alpha) * filteredX);

  //  fill(125, 20, 255);  // Draw in purple
  //  float raw_x = map(speed_X, -4, 4, 0, width);
  //  circle(raw_x, 200+ (height/6), 20); //raw signal
  //  // Draw a circle at the filtered position
  //  noStroke();
  //  fill(0, 200, 255);  //cyan
  //  float smoothX = map(smooth_speed_X, -4, 4, 0, width);
  //  circle(smoothX, 200+ (height/3), 33);  //filtered in position
}

// the smoothing changes the way to calm it down
//float smoothing(float raw) {
//  if (filter == 0) {
//    return raw;                                               // no filter
//  } else if (filter == 1) {
//    return smooth_speed_X + (raw - smooth_speed_X) * easing;  // easing (exponential low-pass)
//  } else if (filter == 2) {
//    float sum = 0;                                            // moving average
//    for (int i = 0; i < SAMPLES; i++) {
//      sum += history[i];
//    }
//    return sum / SAMPLES;
//  } else if (filter == 3) {
//    float[] sorted = sort(history);         // this is another way to smooth, with the median (great to avoid spikes)
//    return sorted[SAMPLES / 2];             // median: the one in the middle
//  } else if (filter == 4) {
//    // a 2nd order low pass should be to apply twice a smoothing
//    // in real applications, a biquad Butterworth is more common
//    stage1 += (raw - stage1) * easing;                        // 1st easing
//    return smooth_speed_X + (stage1 - smooth_speed_X) * easing;  // 2nd easing, on top of the 1st
//  } else
//    return raw;
//}

void keyPressed() {
  if (key >= '0' && key <= '4') {
    filter = key - '0';
  }
  println(filter);
}
