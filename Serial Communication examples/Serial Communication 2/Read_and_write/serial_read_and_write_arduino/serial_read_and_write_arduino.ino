#include <Servo.h>
Servo myservo;  // create servo object to control a servo


#define NUM_OF_VALUES_FROM_PROCESSING 2 /* CHANGE THIS ACCORDING TO YOUR PROJECT */

/* This array stores values from Processing */
int processing_values[NUM_OF_VALUES_FROM_PROCESSING];


void setup() {
  Serial.begin(9600);
  // this example assumes a LED on pin 13, a button on pin 2, and a servo
  // motor on pin 9
  pinMode(13, OUTPUT);
  pinMode(2, INPUT);
  myservo.attach(9);
}

void loop() {
  getSerialData();

  // add your code here using incoming data in the values array
  // and print values to send to Processing

  // example of using received values and turning on an LED
  if (processing_values[0] == 1) {
    digitalWrite(13, HIGH);
  } else {
    digitalWrite(13, LOW);
  }

  // example of using received values to move a servo
  myservo.write(processing_values[1]);

  // example of sending values to Processing
  int sensor0 = analogRead(A0);  // e.g. a photoresistor
  int sensor1 = digitalRead(2);  // the button

  // send the values keeping this format
  Serial.print(sensor0);
  Serial.print(",");  // put comma between sensor values
  Serial.print(sensor1);
  Serial.println();  // add linefeed after sending the last sensor value

  // too fast communication might cause some latency in Processing
  // this delay resolves the issue
  delay(20);
}


/* Receive Serial data from Processing */
/* You won't need to change this code  */

void getSerialData() {
  static int tempValue = 0;  // the "static" makes the local variable retain its value between calls of this function
  static int tempSign = 1;
  static int valueIndex = 0;

  while (Serial.available()) {
    char c = Serial.read();
    if (c >= '0' && c <= '9') {
      // received a digit:
      // multiply the current value by 10, and add the character (converted to a number) as the last digit
      tempValue = tempValue * 10 + (c - '0');
    } else if (c == '-') {
      // received a minus sign:
      // make a note to multiply the final value by -1
      tempSign = -1;
    } else if (c == ',' || c == '\n') {
      // received a comma, or the newline character at the end of the line:
      // update the processing_values array with the temporary value
      if (valueIndex < NUM_OF_VALUES_FROM_PROCESSING) {  // should always be the case, but double-check
        processing_values[valueIndex] = tempValue * tempSign;
      }
      // get ready for the new data by resetting the temporary value and sign
      tempValue = 0;
      tempSign = 1;
      if (c == ',') {
        // move to dealing with the next entry in the processing_values array
        valueIndex = valueIndex + 1;
      } else {
        // except when we reach the end of the line
        // go back to the first entry in this case
        valueIndex = 0;
      }
    }
  }
}
