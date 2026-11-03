import processing.serial.*;

Serial serialPort;

int NUM_OF_VALUES_FROM_PROCESSING = 2;  /* CHANGE THIS ACCORDING TO YOUR PROJECT */
/* This array stores values you might want to send to Arduino */
int processing_values[] = new int[NUM_OF_VALUES_FROM_PROCESSING];

int NUM_OF_VALUES_FROM_ARDUINO = 2;  /* CHANGE THIS ACCORDING TO YOUR PROJECT */
/* This array stores values from Arduino */
int arduino_values[] = new int[NUM_OF_VALUES_FROM_ARDUINO];


void setup() {
  size(500, 500);

  printArray(Serial.list());
  // put the name of the serial port your Arduino is connected
  // to in the line below - this should be the same as you're
  // using in the "Port" menu in the Arduino IDE
  serialPort = new Serial(this, "/dev/cu.usbmodem1101", 9600);
}

void draw() {
  background(0);

  // receive the values from Arduino
  getSerialData();

  // arduino_values[0] are the values from the photoresistor
  float r = map(arduino_values[0], 0, 1023, 0, width);
  circle(width/2, height/2, r);

  // arduino_values[1] are the values from the button
  if (arduino_values[1] == 1) {
    fill(random(255), random(255), random(255));
  }

  // put the values you want to send into the values array
  // for example:
  if (mousePressed) {
    processing_values[0] = 1;
  } else {
    processing_values[0] = 0;
  }
  processing_values[1] = int(map(mouseX, 0, width, 0, 180));

  // send the values to Arduino
  sendSerialData();
}


// the helper function below receives the values from arduino
// in the "arduino_values" array from a connected Arduino
// running the "serial_read_and_write_arduino" sketch
// (You won't need to change this code.)

void getSerialData() {
  while (serialPort.available() > 0) {
    String in = serialPort.readStringUntil( 10 ); // 10 = '\n'  Linefeed in ASCII
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

// the helper function below sends the variables
// in the "processing_values" array to a connected Arduino
// running the "serial_read_and_write_arduino" sketch
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
      data += "\n";  // add the end of data character "n"
    }
  }
  // write to Arduino
  serialPort.write(data);
  print("To Arduino: " + data);  // this prints to the console the values going to Arduino
}
