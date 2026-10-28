// ===== Step 1: sky, sun and moon (clock updated in Step 5) =====

color NIGHT_TOP = color(8, 10, 35);
color NIGHT_BOTTOM = color(30, 25, 70);
color DAY_TOP = color(70, 150, 230);
color DAY_BOTTOM = color(190, 225, 250);
color SUNSET = color(250, 120, 60);

// Advances the clock by the real time that passed and returns it in ms.
// Since Step 5 the clock adds time instead of reading millis() % length,
// so the GUI can stop it or move it without making it jump.
float updateClock() {
  int now = millis();
  float dt = now - lastMillis;
  lastMillis = now;
  if (autoCycle) {
    timeOfDay = (timeOfDay + dt / DAY_LENGTH_MS) % 1.0;
  }
  // -cos gives 0 at midnight (timeOfDay 0) and 1 at noon (timeOfDay 0.5)
  daylight = (1 - cos(timeOfDay * TWO_PI)) / 2;
  return dt;
}

void drawSky() {
  color top = lerpColor(NIGHT_TOP, DAY_TOP, daylight);
  color bottom = lerpColor(NIGHT_BOTTOM, DAY_BOTTOM, daylight);
  // strongest orange when the sun sits on the horizon (daylight = 0.5)
  float sunset = constrain(1 - abs(daylight - 0.5) * 4, 0, 1);
  bottom = lerpColor(bottom, SUNSET, sunset * 0.7);

  for (int y = 0; y < horizonY; y++) {
    float t = y / horizonY;           // local: only needed for this row
    stroke(lerpColor(top, bottom, t));
    line(0, y, width, y);
  }
}

void drawSunAndMoon() {
  float radius = height * 0.62;
  pushMatrix();
  translate(width / 2, horizonY);     // pivot on the horizon
  rotate(timeOfDay * TWO_PI);         // one turn per day
  noStroke();
  // the sun hangs below the pivot, so at timeOfDay 0 (midnight) it is underground
  fill(255, 220, 90);
  circle(0, radius, 70);
  // the moon is on the opposite side of the same arm
  fill(235, 235, 255);
  circle(0, -radius, 45);
  fill(lerpColor(NIGHT_TOP, DAY_TOP, daylight));
  circle(12, -radius - 6, 40);        // a second circle bites the crescent
  popMatrix();
}

void drawGround() {
  noStroke();
  fill(lerpColor(color(10, 15, 12), color(60, 90, 50), daylight));
  rect(0, horizonY, width, height - horizonY);
}
