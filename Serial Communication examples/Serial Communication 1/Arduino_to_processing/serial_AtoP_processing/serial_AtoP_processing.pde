import processing.serial.*;

Serial serialPort;

int NUM_OF_VALUES_FROM_ARDUINO = 2;  /* CHANGE THIS ACCORDING TO YOUR PROJECT */

/* This array stores values from Arduino */
int arduino_values[] = new int[NUM_OF_VALUES_FROM_ARDUINO];


void setup() {
  size(500, 500);
  background(0);

  printArray(Serial.list());
  // put the name of the serial port your Arduino is connected
  // to in the line below - this should be the same as you're
  // using in the "Port" menu in the Arduino IDE
  serialPort = new Serial(this, "/dev/cu.usbmodem1101", 9600);
}

void draw() {
  background(0);
  stroke(255);
  fill(255);

  // receive the values from Arduino
  getSerialData();

  // use the values like this:
  float x = map(arduino_values[0], 0, 1023, 0, width);
  float y = map(arduino_values[1], 0, 1023, 0, height);

  rectMode(CENTER);
  rect(width/2, height/2, x, y);
}


// the helper function below receives the values from Arduino
// in the "arduino_values" array from a connected Arduino
// running the "serial_AtoP_arduino" sketch
// (You won't need to change this code.)

void getSerialData() {
  while (serialPort.available() > 0) {
    String in = serialPort.readStringUntil( 10 );  // 10 = '\n'  Linefeed in ASCII
    if (in != null) {
      print("From Arduino: " + in);
      String[] serialInArray = split(trim(in), ",");
      if (serialInArray.length == NUM_OF_VALUES_FROM_ARDUINO) {
        for (int i=0; i<serialInArray.length; i++) {
          arduino_values[i] = int(serialInArray[i]);
        }
      }
    }
  }
}
