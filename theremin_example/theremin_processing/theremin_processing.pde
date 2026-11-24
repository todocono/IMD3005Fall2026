//IMD3005 - Example for Theremin
//2026/11/24

//Processing Code

import processing.serial.*;

import processing.sound.*;

SinOsc sine;

Serial serialPort;

int NUM_OF_VALUES_FROM_ARDUINO = 2;  /* CHANGE THIS ACCORDING TO YOUR PROJECT */

/* This array stores values from Arduino */
int arduino_values[] = new int[NUM_OF_VALUES_FROM_ARDUINO];


float pitch, volume;

void setup() {
  size(500, 500);
  background(0);

  printArray(Serial.list());
  // put the name of the serial port your Arduino is connected
  // to in the line below - this should be the same as you're
  // using in the "Port" menu in the Arduino IDE
  serialPort = new Serial(this, "/dev/cu.usbmodem3101", 9600);

  // create and start the sine oscillator.
  sine = new SinOsc(this);
  sine.play();
}

void draw() {
  background(0);
  stroke(255);
  fill(255);

  // receive the values from Arduino
  getSerialData();

  int p = constrain (arduino_values[0], 0, 30);
  int v = constrain (arduino_values[1], 0, 30);
  // use the values like this:
  pitch = lerp (pitch, p, 0.1);
  volume = lerp (volume, v, 0.01);
  

  rectMode(CORNERS);
  fill (255, 0, 125);
  rect(0, height, width/2, map(pitch, 30, 0, 0, height));
  fill (125, 0, 255);
  rect(width/2, height, width, map(volume, 30, 0, 0,height) );
  
  //I copied this code from the Sound/Examples/SineWave example
  
   // Map mouseY from 0.0 to 1.0 for amplitude
  float amplitude = map(volume, 0, 30, 1.0, 0.0);
  sine.amp(amplitude);

  // Map mouseX from 20Hz to 1000Hz for frequency  
  float frequency = map(pitch, 0, 30, 80.0, 1000.0);
  sine.freq(frequency);
}


// the helper function below receives the values from Arduino
// in the "arduino_values" array from a connected Arduino
// running the "serial_AtoP_arduino" sketch
// (You won't need to change this code.)

void getSerialData() {
  while (serialPort.available() > 0) {
    String in = serialPort.readStringUntil( 10 );  // 10 = '\n'  Linefeed in ASCII
    if (in != null) {
      //print("From Arduino: " + in);
      String[] serialInArray = split(trim(in), ",");
      if (serialInArray.length == NUM_OF_VALUES_FROM_ARDUINO) {
        for (int i=0; i<serialInArray.length; i++) {
          arduino_values[i] = int(serialInArray[i]);
        }
      }
    }
  }
}
