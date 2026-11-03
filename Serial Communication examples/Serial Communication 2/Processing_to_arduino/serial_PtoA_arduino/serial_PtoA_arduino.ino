#define NUM_OF_VALUES_FROM_PROCESSING 3 /* CHANGE THIS ACCORDING TO YOUR PROJECT */

/* This array stores values from Processing */
int processing_values[NUM_OF_VALUES_FROM_PROCESSING];


void setup() {
  Serial.begin(9600);
  pinMode(13, OUTPUT);
}

void loop() {
  getSerialData();

  // add your code here using elements in the values array
  // this example assumes a buzzer is connected to pin 8

  if (processing_values[0] == 1) {
    // turn on an LED when the mouse is pressed
    digitalWrite(13, HIGH);
    // map values from mouseX (0-1200) to an audible frequency (120-1500Hz)
    int f = map(processing_values[1], 0, 1200, 120, 1500);
    // map values from mouseY (0-800) to the duration (10-2000ms)
    int d = map(processing_values[2], 0, 800, 10, 2000);
    // play the pitch
    tone(8, f, d);
    delay(1);  // delay in between reads for stability
  } else {
    digitalWrite(13, LOW);
  }
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
