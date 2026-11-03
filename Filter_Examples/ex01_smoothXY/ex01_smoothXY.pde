/*
 * Filtering the movement of the mouse
 * IMD3005 · Fall 2026 
 *
 * This example uses the code from https://processing.org/examples/easing.html
 * Read basic info about smoothing at https://en.wikipedia.org/wiki/Smoothing
 */


float x = 0.0;
float y = 0.0;
float easing = 0.05; // Lower values = smoother/slower lag; higher values = faster

void setup() {
  size(640, 360);

  background(50);
}

void draw() {
  // Smoothly interpolate current position toward the mouse position
  float targetX = mouseX;
  x += (targetX - x) * easing; //which is equivalent to filteredX = (alpha * mouseX) + ((1.0 - alpha) * filteredX);


  float targetY = mouseY;
  y += (targetY - y) * easing;

  // Draw a continuous line where the mouse goes
  stroke(125, 20, 255);
  strokeWeight(5);
  line(pmouseX, pmouseY, mouseX, mouseY); //raw signal
  // Draw a circle at the filtered position
  noStroke();
  fill(0, 200, 255, 15);  //cyan with alpha
  ellipse(x, y, 33, 33);  //filtered
}

//any key erases the canvas
void keyPressed() {
  background(50);
}
