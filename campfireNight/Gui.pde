// ===== Step 5: controlP5 panel =====
// controlP5 links a controller to the global (or function) with the same name.

ControlP5 cp5;
Slider timeSlider;
boolean guiReady = false;   // buttons fire once while being created; ignore that call

void setupGui() {
  cp5 = new ControlP5(this);
  int x = 20;

  timeSlider = cp5.addSlider("timeOfDay").setPosition(x, 20).setSize(200, 15)
    .setRange(0, 1).setValue(timeOfDay);
  cp5.addToggle("autoCycle").setPosition(x, 45).setSize(15, 15).setValue(autoCycle);

  // Steps 6-7
  cp5.addButton("playMusic").setPosition(x, 90).setSize(90, 20);
  cp5.addToggle("starsFromMusic").setPosition(x, 120).setSize(15, 15).setValue(starsFromMusic);
  cp5.addToggle("colourFromPitch").setPosition(x + 100, 120).setSize(15, 15).setValue(colourFromPitch);

  // Steps 8-9
  cp5.addButton("listen").setPosition(x, 165).setSize(90, 20);
  cp5.addSlider("scareLevel").setPosition(x, 195).setSize(150, 15).setRange(0.05, 0.6).setValue(scareLevel);
  cp5.addSlider("avgWindow").setPosition(x, 215).setSize(150, 15).setRange(1, 48).setValue(avgWindow);

  guiReady = true;
}

void toggleGui() {
  if (cp5.isVisible()) {
    cp5.hide();
  } else {
    cp5.show();
  }
}

// while the clock runs on its own, move the slider without re-triggering it
void syncGui() {
  if (autoCycle) {
    timeSlider.setBroadcast(false);
    timeSlider.setValue(timeOfDay);
    timeSlider.setBroadcast(true);
  }
}
