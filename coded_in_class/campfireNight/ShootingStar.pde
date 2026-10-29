// ===== Step 4: shooting stars =====

class ShootingStar {
  float x, y;        // head position
  float vx, vy;      // pixels per frame
  float len;         // tail length

  ShootingStar() {
    x = random(-100, width * 0.6);
    y = random(-20, horizonY * 0.4);
    vx = random(6, 12);
    vy = random(2, 5);
    len = random(40, 110);
  }

  void update() {
    x += vx;
    y += vy;
  }

  void display(float hue, boolean coloured) {
    pushMatrix();
    pushStyle();
    translate(x, y);
    rotate(atan2(vy, vx));            // point the tail along the direction of travel
    colorMode(HSB, 255);
    if (coloured) {
      stroke(hue, 170, 255);
    } else {
      stroke(0, 0, 255);
    }
    strokeWeight(2);
    line(-len, 0, 0, 0);
    noStroke();
    fill(0, 0, 255);
    circle(0, 0, 5);
    popStyle();
    popMatrix();
  }

  boolean isOffscreen() {
    return x - len > width || y - len > horizonY;
  }
}

void updateAndDrawStars() {
  // backwards, so removing an item does not skip the next one
  for (int i = stars.size() - 1; i >= 0; i--) {
    ShootingStar s = stars.get(i);
    s.update();
    s.display(starHue, colourFromPitch);
    if (s.isOffscreen()) {
      stars.remove(i);
    }
  }
}
