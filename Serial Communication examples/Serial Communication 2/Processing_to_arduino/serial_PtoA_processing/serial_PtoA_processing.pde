import processing.serial.*;

Serial serialPort;

int NUM_OF_VALUES_FROM_PROCESSING = 3;  /* CHANGE THIS ACCORDING TO YOUR PROJECT */

/* This array stores values you might want to send to Arduino */
int processing_values[] = new int[NUM_OF_VALUES_FROM_PROCESSING];


void setup() {
  size(1200, 800);
  background(0);

  printArray(Serial.list());
  // put the name of the serial port your Arduino is connected
  // to in the line below - this should be the same as you're
  // using in the "Port" menu in the Arduino IDE
  serialPort = new Serial(this, "/dev/cu.usbmodem1101", 9600);
}

void draw() {
  background(0);

  // put the values you want to send into the values array
  // for example:

  if (mousePressed) {
    processing_values[0] = 1;
  } else {
    processing_values[0] = 0;
  }
  processing_values[1] = mouseX;
  processing_values[2] = mouseY;

  // send the values to Arduino
  sendSerialData();
}


// the helper function below sends the variables
// in the "processing_values" array to a connected Arduino
// running the "serial_PtoA_arduino" sketch
// (You won't need to change this code.)

void sendSerialData() {
  String data = "";
  for (int i=0; i<processing_values.length; i++) {
    data += processing_values[i];
    // if i is less than the index number of the last element in the values array
    if (i < processing_values.length-1) {
      data += ",";  // add splitter character "," between each values element
    }
    // if it is the last element in the values array
    else {
      data += "\n";  // add the end of data character linefeed "\n"
    }
  }
  // write to Arduino
  serialPort.write(data);
  print("To Arduino: " + data);  // this prints to the console the values going to arduino
}
