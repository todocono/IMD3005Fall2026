/*
IMD3005 - Example for Theremin
2026/11/24

Arduino Code

Using 2 ultrasound sensors, and sending over serial via CSV

Source of HC-SR04 sensor code: https://psc.byu.edu/ultrasonic

*/


const int trigPin1 = 8;
const int echoPin1 = 9;

const int trigPin2 = 5;
const int echoPin2 = 6;

void setup() {
  Serial.begin(9600);
  pinMode(trigPin1, OUTPUT);
  pinMode(echoPin1, INPUT);
  pinMode(trigPin2, OUTPUT);
  pinMode(echoPin2, INPUT);
  pinMode(11, OUTPUT);  //for my setup, I replaced the Vcc with P11 on HIGH
  digitalWrite(11, HIGH);
}

void loop() {
  digitalWrite(trigPin1, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin1, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin1, LOW);
    // Timeout in microseconds (e.g., 10000 µs ≈ 510 cm max round-trip)
  unsigned long duration1 = pulseIn(echoPin1, HIGH, 10000);

  digitalWrite(trigPin2, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin2, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin2, LOW);

  // Timeout in microseconds (e.g., 10000 µs ≈ 510 cm max round-trip)
  unsigned long duration2 = pulseIn(echoPin2, HIGH, 10000);

  if ((duration1 == 0) || (duration2 == 0)) {
    //Ignore if no valid values.  
    //Serial.println("Out of range / no echo");
  } else {
     int distanceCm1 = (duration1 / 2.0) * 0.0343;
    int distanceCm2 = (duration2 / 2.0) * 0.0343;

    Serial.print(distanceCm1);
    Serial.print(",");
    Serial.println(distanceCm2);
 }

  //delay(1); //tiny delay is sometimes needed to avoid overflowing the hardware port of the computer
}
