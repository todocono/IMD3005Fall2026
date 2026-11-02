/*
 * Filtering the speed of movement of the mouse
 * IMD3005 · Fall 2026
 *
 * filter how FAST the mouse moves instead of where it is
 *   velocity = mouseX - pmouseX   (pixels per frame, + to the right, - to the left)
 * Uses ideas from https://forum.processing.org/one/topic/using-the-mouse-speed.html
 */

int SPEED_GRAPH = 5000; //constant for the plot
int TRIGGER = 5;
float easing_signal = 0.05; // Lower values = smoother/slower lag; higher values = faster
float easing_event = 0.02;

long  last_time;
float speed_X, smooth_speed_X, shakeMeter;
float MOVING_SPEED = 0.1; //constant for the speed;
int   direction;


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
  speed_X = (mouseX - pmouseX) / (float)(time_ellapsed); //I need to make sure I use float division (and not int)

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
  if (speed_X > MOVING_SPEED)  text("RAW moving RIGHT", width/2, 15);
  if (speed_X < -MOVING_SPEED)  text("RAW moving LEFT", width/2, 15);
  //I smooth the speed to accurately represent the intention of the user
  smooth_speed_X += (speed_X - smooth_speed_X) * easing_signal;

  fill(255);
  int newDirection = 0;
  if (smooth_speed_X > MOVING_SPEED) {
    text("moving RIGHT", width/2, 30);
    newDirection = 1;
  }
  if (smooth_speed_X < -MOVING_SPEED) {
    text("moving LEFT", width/2, 30);
    newDirection = -1;
  }

  //if the direction is different from before
  if (newDirection != direction) {
    shakeMeter += 1;    //I add 1 per event
    direction = newDirection;  //I lock in, so that it's only once per event
  }
  shakeMeter *= (1-easing_event); //I add a leak to make it a low pass (AKA leaky counter)

  // Now I rinse and repeat the plotting
  // but I also add the smooth speed
  strokeWeight(2);
  stroke(255, 0, 125);
  point(plotT, 100+(smooth_speed_X * 15));

  // Smoothly interpolate current position toward the mouse position
  // I left it here from the previous example, just FYI
  noStroke();
  rect(0, 200, width, height);  //clear the screen
  fill(125, 20, 255);  // Draw in purple
  float raw_x = map(speed_X, -4, 4, 0, width);
  circle(raw_x, 200+ (height/6), 20); //raw signal
  // Draw a circle at the filtered position
  noStroke();
  fill(0, 200, 255);  //cyan
  float smoothX = map(smooth_speed_X, -4, 4, 0, width);
  circle(smoothX, 200+ (height/3), 33);  //filtered in position
  fill(0);

  text("Shake meter " + nf(shakeMeter, 0, 2) + " px/ms ", width/2, height-40);
  if (shakeMeter > TRIGGER) {         // e.g. 3
    fill(255, 0, 0);
    text("SHAKING ACTIVATED!", width/2, height-20);
  }
}

//any key erases the canvas
void keyPressed() {
  background(50);
  fill(0);
  noStroke();
  rect(0, 0, width, 100);
}
