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

int SPEED_GRAPH = 5000; //constant for the plot

//float x = 0.0;
float easing = 0.05; // Lower values = smoother/slower lag; higher values = faster
long last_time;
float speed_X, smooth_speed_X;
float MOVING_SPEED = 0.1; //constant for the speed;

int filter = 0;  //start with no filter
int SAMPLES = 10;          // how many readings the average and the median look at
float[] history = new float[SAMPLES];
int index = 0;
float stage1 = 0;

void setup() {
  size(640, 480);
  background(50);
  fill(0);
  rect(0, 0, width, 200);
  textAlign(CENTER);
}

void draw() {

  // calculate time ellapsed and the delta
  // not totally necessary to divide by time (if FPS rate is constant)
  long now = millis();
  long time_ellapsed = now - last_time;
  last_time =  now;
  if (time_ellapsed > 0) { //I avoid div/0 errors
    speed_X = (mouseX - pmouseX) / (float)(time_ellapsed); //I need to make sure I use float division (and not int)
  }

  // keep the last SAMPLES readings for the average and the median
  history[index] = speed_X;
  index = (index + 1) % SAMPLES; //another way of cycling over index

  // Plot signals for clarity of the example
  float plotT = map(millis()%SPEED_GRAPH, 0, SPEED_GRAPH, 0, width);
  noStroke();
  fill(0);
  rect(plotT, 0, 10, 200);
  strokeWeight(2);
  stroke(0, 255, 0);
  point(plotT, 100+(speed_X * 15));
  noStroke();
  fill(0);
  rect((width/2)-100, 0, 200, 40);
  fill(255);
  if (speed_X >  MOVING_SPEED)  text("RAW moving RIGHT", width/2, 15);
  if (speed_X < -MOVING_SPEED)  text("RAW moving LEFT", width/2, 15);


  //I smooth the speed to accurately represent the intention of the user
  //Instead of the same as ex1, using smooth_speed_X += (speed_X - smooth_speed_X) * easing;
  //I use a filter which changes with the keyPressed
  smooth_speed_X = smoothing(speed_X);

  //Now I rinse and repeat the plotting but for the smooth speed
  strokeWeight(2);
  stroke(255, 0, 125);
  point(plotT, 100+(smooth_speed_X * 15));
  fill(255);
  if (smooth_speed_X > MOVING_SPEED)  text("moving RIGHT", width/2, 30);
  if (smooth_speed_X < -MOVING_SPEED)  text("moving LEFT", width/2, 30);

  // Smoothly interpolate current position toward the mouse position
  // I left it here from the previous example, just FYI
  fill(50);
  noStroke();
  rect(0, 200, width, height);  //clear the screen
  //float targetX = mouseX;
  //x += (targetX - x) * easing; //which is equivalent to filteredX = (alpha * mouseX) + ((1.0 - alpha) * filteredX);

  fill(125, 20, 255);  // Draw in purple
  float raw_x = map(speed_X, -4, 4, 0, width);
  circle(raw_x, 200+ (height/6), 20); //raw signal
  // Draw a circle at the filtered position
  noStroke();
  fill(0, 200, 255);  //cyan
  float smoothX = map(smooth_speed_X, -4, 4, 0, width);
  circle(smoothX, 200+ (height/3), 33);  //filtered in position
}

// the smoothing changes the way to calm it down
float smoothing(float raw) {
  if (filter == 0) {
    return raw;                                               // no filter
  } else if (filter == 1) {
    return smooth_speed_X + (raw - smooth_speed_X) * easing;  // easing (exponential low-pass)
  } else if (filter == 2) {
    float sum = 0;                                            // moving average
    for (int i = 0; i < SAMPLES; i++) {
      sum += history[i];
    }
    return sum / SAMPLES;
  } else if (filter == 3) {
    float[] sorted = sort(history);         // this is another way to smooth, with the median (great to avoid spikes)                   
    return sorted[SAMPLES / 2];             // median: the one in the middle
  } else if (filter == 4) {
    // a 2nd order low pass should be to apply twice a smoothing
    // in real applications, a biquad Butterworth is more common
    stage1 += (raw - stage1) * easing;                        // 1st easing
    return smooth_speed_X + (stage1 - smooth_speed_X) * easing;  // 2nd easing, on top of the 1st
  } else
    return raw;
}

void keyPressed() {
  if (key >= '0' && key <= '4') {
    filter = key - '0';
  }
  println(filter);
}


// this is a textbook Butterworth (from the "Audio EQ Cookbook", Q = 0.707)
// https://www.w3.org/TR/audio-eq-cookbook/#formulae
void butterworth(float cutoff, float sampleRate) {
  //float w = TWO_PI * cutoff / sampleRate;
  //float alpha = sin(w) / (2 * 0.7071);
  //float a0 = 1 + alpha;
  //float b0 = (1 - cos(w)) / 2 / a0;
  //float b1 = (1 - cos(w)) / a0;
  //float b2 = b0;
  //float a1 = -2 * cos(w) / a0;
  //float a2 = (1 - alpha) / a0;
  // Butterworth: new output = mix of the last 3 inputs and the last 2 outputs
  //float y = b0 * raw + b1 * x1 + b2 * x2 - a1 * y1 - a2 * y2;
  //x2 = x1;
  //x1 = raw;
  //y2 = y1;
  //y1 = y;
}
