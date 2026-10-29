// ===== Step 4: birds =====

class Bird {
  float x, y;
  float vx, vy;
  float flapOffset;    // so the flock does not flap in sync
  boolean fleeing = false;

  Bird() {
    x = random(-80, -20);
    y = random(horizonY * 0.15, horizonY * 0.6);
    vx = random(1.5, 3);
    vy = 0;
    flapOffset = random(TWO_PI);
  }

  void update() {
    x += vx;
    y += vy;
    if (!fleeing) {
      y += sin(millis() * 0.003 + flapOffset) * 0.4;   // gentle bobbing
    }
  }

  void scare() {
    if (!fleeing) {
      fleeing = true;
      vx *= 2.5;
      vy = -random(2, 4);
    }
  }

  void display() {
    float speed = fleeing ? 0.04 : 0.015;
    float wing = sin(millis() * speed + flapOffset) * 8;
    pushMatrix();
    translate(x, y);
    stroke(20);
    strokeWeight(2);
    noFill();
    line(-10, wing, 0, 0);
    line(0, 0, 10, wing);
    popMatrix();
  }

  boolean isOffscreen() {
    return x > width + 30 || y < -30;
  }
}

void updateAndDrawBirds() {
  // new birds arrive in daytime, unless they were scared away
  if (!isNight() && !birdsScared && birds.size() < 12 && random(1) < 0.02) {
    birds.add(new Bird());
  }
  for (int i = birds.size() - 1; i >= 0; i--) {
    Bird b = birds.get(i);
    b.update();
    b.display();
    if (b.isOffscreen()) {
      birds.remove(i);
    }
  }
}

void scareBirds() {
  birdsScared = true;
  for (Bird b : birds) {
    b.scare();
  }
}

void callBirds() {
  birdsScared = false;
  for (int i = 0; i < 6; i++) {
    birds.add(new Bird());
  }
}
