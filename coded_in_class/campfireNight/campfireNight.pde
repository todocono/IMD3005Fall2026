/*
 * Campfire Night · 10_final
 * IMD3005 · Fall 2026 · Lesson 6
 * Used Claude for most of the graphics/filtering
 *
 * Libraries (Sketch > Import Library > Manage Libraries): Video, Sound, controlP5
 * data/ must contain: fire.mp4 (fire on black, H.264), campfire.svg, log.svg, music.mp3
 *
 * Keys: SPACE light the fire / add a log · S add a shooting star · B scare the birds (test) · H show or hide the GUI
 */

import processing.video.*;
import processing.sound.*;
import controlP5.*;

// ---------- Step 1: clock and sky ----------
final float DAY_LENGTH_MS = 40000;  // one full day-night cycle in real time
float timeOfDay = 0.30;             // 0 = midnight, 0.25 = sunrise, 0.5 = noon (GUI slider)
boolean autoCycle = true;           // when false, the slider drives the clock (GUI toggle)
float daylight;                     // 0 = darkest night, 1 = noon; recomputed each frame
int lastMillis;                     // to measure how long the last frame took
float horizonY;                     // where the ground starts

// ---------- Step 2: campfire ----------
Movie fireMovie;
PShape campfireSvg, logSvg;
float fireLevel = 0;                // 0 = out, 1 = roaring
int logs = 0;                       // how many extra logs are on the fire
final int MAX_LOGS = 5;
final float FIRE_DECAY_PER_SEC = 0.06;

// ---------- Step 4: objects ----------
ArrayList<ShootingStar> stars = new ArrayList<ShootingStar>();
ArrayList<Bird> birds = new ArrayList<Bird>();
boolean birdsScared = false;        // true after a loud noise, until the birds are called back

void setup() {
  size(960, 540);
  horizonY = height * 0.78;
  lastMillis = millis();

  fireMovie = new Movie(this, "fire.mp4");
  fireMovie.loop();
  fireMovie.volume(0);
  campfireSvg = loadShape("campfire.svg");
  logSvg = loadShape("log.svg");

  setupAudio();
  setupGui();
}

void draw() {
  float dt = updateClock();         // milliseconds since last frame

  drawSky();
  drawSunAndMoon();
  drawGround();

  updateMusic();                    // Steps 6-7: may add stars, changes their colour
  updateAndDrawStars();
  updateAndDrawBirds();

  updateFire(dt);
  drawCampfire();

  if (listening) {                  // Steps 8-9
    updateMic(dt);
    drawAudioHud();
  }
  syncGui();
}

void keyPressed() {
  if (key == ' ') {
    feedFire();
  } else if (key == 's' || key == 'S') {
    stars.add(new ShootingStar());
  } else if (key == 'b' || key == 'B') {
    scareBirds();
  } else if (key == 'h' || key == 'H') {
    toggleGui();
  }
}

// helper used by several tabs
boolean isNight() {
  return daylight < 0.35;
}
