// ===== Steps 6-9: music, FFT, microphone and digital filters =====
// 10_final adds the stretch goals:
//   - filters set by time constants, so they behave the same at any frame rate
//   - loudness smoothed over a few frames, so one tap on the desk is ignored
//   - a DEE only counts if it lasts long enough, so claps don't call the birds
//   - the colour follows the loudest band between 200 and 4000 Hz, not the bass

final int BANDS = 512;
float binHz;                         // width of one FFT band in Hz

// ---------- Step 6: music drives the shooting stars ----------
SoundFile song;
Amplitude musicAmp;
boolean starsFromMusic = false;      // GUI toggle
final float STAR_THRESHOLD = 0.25;   // loudness that launches a star
final int STAR_COOLDOWN_MS = 180;    // stops one beat from launching 20 stars
int lastStarMs = 0;

// ---------- Step 7: FFT colours the stars ----------
FFT musicFFT;
float[] musicSpectrum = new float[BANDS];
boolean colourFromPitch = false;     // GUI toggle
float starHue = 140;

// ---------- Step 8: microphone, loudness, moving average ----------
AudioIn mic;
Amplitude micAmp;
Waveform micWave;
boolean listening = false;
int listenStartMs = 0;                // when the mic was switched on
float scareLevel = 0.3;              // GUI slider
int avgWindow = 8;                   // GUI slider: samples in the moving average
float[] filteredWave = new float[BANDS];
final int LOUD_WINDOW = 4;           // frames of loudness to average before scaring
float[] loudHistory = new float[LOUD_WINDOW];
int loudIndex = 0;                   // ring buffer position
int calmUntilMs = 0;                 // after a call, ignore loud noises for a moment

// ---------- Step 9: recursive filters to hear a repeated "DEE DEE DEE" ----------
FFT micFFT;
float[] micSpectrum = new float[BANDS];
float smoothBand = 0;                // y = a*y + (1-a)*x, fast
float background = 0.0001;           // same filter, very slow = room noise
float callMeter = 0;                 // leaky integrator of whistle onsets
boolean toneOn = false;
int toneStartMs = 0;
final float CALL_LOW_HZ = 500, CALL_HIGH_HZ = 4000;
final float TONE_ON_RATIO = 4, TONE_OFF_RATIO = 2;   // hysteresis (Schmitt trigger)
final float CALL_TARGET = 1.8;       // three DEEs about half a second apart
final int MIN_TONE_MS = 120;         // a clap is shorter than this, a DEE is longer
final float SMOOTH_TAU_MS = 33;      // time constants: a = exp(-dt / tau)
final float BACKGROUND_TAU_MS = 3300;
final float CALL_KEEP_PER_SEC = 0.3; // the meter keeps 30% of its value each second

void setupAudio() {
  binHz = Sound.sampleRate() / 2.0 / BANDS;

  song = new SoundFile(this, "music.mp3");
  musicAmp = new Amplitude(this);
  musicAmp.input(song);
  musicFFT = new FFT(this, BANDS);
  musicFFT.input(song);

  mic = new AudioIn(this, 0);
  micAmp = new Amplitude(this);
  micWave = new Waveform(this, BANDS);
  micFFT = new FFT(this, BANDS);
  mic.start();
  listenStartMs = millis();
  micAmp.input(mic);
  micWave.input(mic);
  micFFT.input(mic);
}

// GUI button
void playMusic() {
  if (!guiReady) return;
  if (song.isPlaying()) {
    song.pause();
  } else {
    song.loop();
  }
}

void updateMusic() {
  if (!song.isPlaying() || !isNight()) return;

  // Step 6: loud moments launch stars, with a cooldown
  float level = musicAmp.analyze();
  if (starsFromMusic && level > STAR_THRESHOLD && millis() - lastStarMs > STAR_COOLDOWN_MS) {
    stars.add(new ShootingStar());
    lastStarMs = millis();
  }

  // Step 7: the band with the most energy sets the colour
  if (colourFromPitch) {
    musicFFT.analyze(musicSpectrum);
    int from = round(200 / binHz);                 // skip the bass and kick drum
    int to = round(4000 / binHz);
    int peak = from;
    for (int i = from + 1; i <= to; i++) {
      if (musicSpectrum[i] > musicSpectrum[peak]) {
        peak = i;
      }
    }
    float peakHz = constrain(peak * binHz, 80, 4000);
    // pitch is heard logarithmically, so map log(Hz); stop at 200 so red does not wrap
    float targetHue = map(log(peakHz), log(80), log(4000), 0, 200);
    starHue = lerp(starHue, targetHue, 0.1);       // lerp is already a low-pass filter
  }
}

// GUI button
void listen() {
  if (!guiReady) return;
  listening = !listening;
  //if (listening) {
  //  mic.start();
  //  listenStartMs = millis();
  //  micAmp.input(mic);
  //  micWave.input(mic);
  //  micFFT.input(mic);
  //} else {
  //  mic.stop();
  //}
}

void updateMic(float dt) {
  if (listening) {
    // Step 8a: a loud noise scares the birds
    loudHistory[loudIndex] = micAmp.analyze();
    loudIndex = (loudIndex + 1) % LOUD_WINDOW;
    float level = 0;
    for (int i = 0; i < LOUD_WINDOW; i++) {
      level += loudHistory[i] / LOUD_WINDOW;          // moving average of loudness
    }
    if (level > scareLevel && millis() > calmUntilMs) {
      scareBirds();
    }

    // Step 8b: moving average of the raw samples = low-pass filter
    micWave.analyze();
    filteredWave = movingAverage(micWave.data, avgWindow);

    // Step 9: hear a repeated high "DEE DEE DEE" or whistle
    micFFT.analyze(micSpectrum);
    float x = bandEnergy(micSpectrum, CALL_LOW_HZ, CALL_HIGH_HZ);
    float a = exp(-dt / SMOOTH_TAU_MS);                     // about 0.6 at 60 fps
    smoothBand = a * smoothBand + (1 - a) * x;              // recursive low-pass: removes flicker
    if (millis() - listenStartMs < 1000) {                 // first second: just learn the room
      background = smoothBand;
      return;
    }
    // very slow low-pass = the room's level; ten times slower while a tone is on,
    // so a long DEE doesn't become "normal", but the meter can never get stuck
    float tau = toneOn ? BACKGROUND_TAU_MS * 10 : BACKGROUND_TAU_MS;
    float b = exp(-dt / tau);                               // about 0.995 at 60 fps
    background = b * background + (1 - b) * smoothBand;
    float ratio = smoothBand / (background + 0.00001);     // how far above the room we are

    if (!toneOn && ratio > TONE_ON_RATIO) {               // a tone starts
      toneOn = true;
      toneStartMs = millis();
    } else if (toneOn && ratio < TONE_OFF_RATIO) {        // it ends: was it long enough?
      toneOn = false;
      if (millis() - toneStartMs >= MIN_TONE_MS) {
        callMeter += 1;                                    // one "DEE"
      }
    }
    callMeter *= pow(CALL_KEEP_PER_SEC, dt / 1000.0);      // leaky integrator, in real time

    if (birdsScared && callMeter > CALL_TARGET) {
      callBirds();
      callMeter = 0;
      calmUntilMs = millis() + 3000;
    }
  }
}

// FIR filter: each output is the average of the last `window` inputs
float[] movingAverage(float[] input, int window) {
  float[] output = new float[input.length];
  float sum = 0;
  for (int i = 0; i < input.length; i++) {
    sum += input[i];
    if (i >= window) {
      sum -= input[i - window];
    }
    output[i] = sum / min(i + 1, window);
  }
  return output;
}

float bandEnergy(float[] spectrum, float lowHz, float highHz) {
  int from = max(1, round(lowHz / binHz));
  int to = min(spectrum.length - 1, round(highHz / binHz));
  float sum = 0;
  for (int i = from; i <= to; i++) {
    sum += spectrum[i];
  }
  return sum;
}

// oscilloscope (raw vs filtered) and meters, bottom right
void drawAudioHud() {
  float px = width - 340, py = height - 150, pw = 320, ph = 120;
  pushStyle();
  noStroke();
  fill(0, 160);
  rect(px, py, pw, ph);
  noFill();
  strokeWeight(1);
  stroke(180);
  drawWave(micWave.data, px, py, pw, ph);
  stroke(255, 150, 40);
  strokeWeight(2);
  drawWave(filteredWave, px, py, pw, ph);

  // call meter
  noStroke();
  fill(toneOn ? color(120, 255, 120) : color(120));
  rect(px, py - 14, pw * constrain(callMeter / CALL_TARGET, 0, 1), 8);
  fill(255);
  textSize(11);
  text("raw (grey) vs moving average of " + avgWindow + " samples (orange)", px + 6, py + 14);
  text("call meter", px + pw - 60, py - 18);
  popStyle();
}

void drawWave(float[] wave, float px, float py, float pw, float ph) {
  beginShape();
  for (int i = 0; i < wave.length; i++) {
    float x = map(i, 0, wave.length - 1, px, px + pw);
    float y = py + ph / 2 + wave[i] * ph * 2;
    vertex(x, constrain(y, py, py + ph));
  }
  endShape();
}
