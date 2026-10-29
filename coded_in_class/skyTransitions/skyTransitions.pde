/*
 * Example coded live IMD3005 - Fall 2026
 * Algonquin College
 *
 * Transient of sky colors
 */

color[] skyColor = {color(10, 10, 40), color(60, 150, 230)};
color currentColor;
float DAY_LENGTH = 10000;     // one full day in milliseconds
float time;
float weightAlpha = 0;


void setup() {
  //colorMode(HSB, 360, 100, 100);
  size(600, 800);
  background(skyColor[0]);
}

void draw() {
  time = ( millis() % DAY_LENGTH ) / DAY_LENGTH;
  sky(time);
  sunMoon(time);
}


void sky(float t) {
  noStroke();
  currentColor = lerpColor(currentColor, skyColor[floor(t*2)], 0.05);
  // paint the sky
  background(currentColor);


  weightAlpha = 150 * (1 + sin(t * TWO_PI)) / 2;   // 150 at midnight, 0 at noon
  for (int j = 0; j < height; j += 10) {
    float alpha = map(j, 0, height, weightAlpha, 50);   // darkest at the top
    fill(0, alpha);
    rect(0, j, width, 10);
  }

  fill(255);
  text("uses colour set: "+floor(t*2), 10, 10);
  text("and shadow of: "+ nf(weightAlpha, 0, 2), 10, 30);
}

void keyPressed() {
  if (key == '+') {
    weightAlpha ++;
  } else if (key == '-') {
    weightAlpha --;
  }
}

void sunMoon(float t) {
  float r = height * 0.6;           // length of the arm
  push();
  translate(width / 2, height);     // pivot at the bottom centre
  rotate(t * 2 * PI);               // one full turn per day
  noStroke();
  fill(240, 240, 255);  //white-ish
  circle(-r, 0, 60);                // moon highest at t = 0.25 
  fill(255, 210, 60);  //yellow from colour-picker
  circle(r, 0, 90);                 // sun
  pop();
}
