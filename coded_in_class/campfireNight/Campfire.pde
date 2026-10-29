// ===== Step 2: campfire =====

void feedFire() {
  if (fireLevel < 0.05) {
    fireLevel = 0.35;                         // first press lights it
  } else {
    logs = min(logs + 1, MAX_LOGS);           // every other press adds a log
    fireLevel = min(fireLevel + 0.15, 1);
  }
}

void updateFire(float dt) {
  if (!keyPressed) {
    fireLevel -= FIRE_DECAY_PER_SEC * dt / 1000.0;   // dies slowly in real time
  }
  fireLevel = constrain(fireLevel, 0, 1);
  logs = min(logs, ceil(fireLevel * MAX_LOGS));      // logs burn away with the fire
}

void drawCampfire() {
  float cx = width * 0.5;
  float cy = horizonY + 55;

  // warm light on the ground
  noStroke();
  fill(255, 140, 40, 90 * fireLevel);
  ellipse(cx, cy, 500 * fireLevel, 90 * fireLevel);

  // extra logs, crossed under the flames (each one rotated around the fire's centre)
  shapeMode(CENTER);
  for (int i = 0; i < logs; i++) {
    float tilt = (i % 2 == 0) ? 12 + i * 5 : -12 - i * 5;
    pushMatrix();
    translate(cx, cy - 8 - i * 4);
    rotate(radians(tilt));
    shape(logSvg, 0, 0, 130, 20);
    popMatrix();
  }

  // the video: black is invisible with ADD, so only the flames show
  if (fireLevel > 0.01 && fireMovie.width > 0) {
    float h = map(fireLevel, 0, 1, 60, 260);
    float w = h * fireMovie.width / fireMovie.height;
    blendMode(ADD);
    tint(255, 255 * fireLevel);
    imageMode(CENTER);
    image(fireMovie, cx, cy - h / 2 + 10, w, h);
    noTint();
    imageMode(CORNER);
    blendMode(BLEND);
  }

  shape(campfireSvg, cx, cy, 220, 80);       // stones and base logs cover the video's edge
  shapeMode(CORNER);
}

void movieEvent(Movie m) {
  m.read();
}
