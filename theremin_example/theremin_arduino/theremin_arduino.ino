/*
IMD3005 - Example for Theremin
2026/11/24

Arduino Code

Using 2 ultrasound sensors, and sending over serial via CSV

Source of HC-SR04 sensor code: https://psc.byu.edu/ultrasonic

*/


const int trigPin = 7;
const int echoPin = 8;

void setup() {
  Serial.begin(9600);
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
}

void loop() {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  // Timeout in microseconds (e.g., 3000 µs ≈ 51 cm max round-trip)
  unsigned long duration = pulseIn(echoPin, HIGH, 3000);

  if (duration == 0) {
    //Ignore if no valid values.  Serial.println("Out of range / no echo");
  } else {
    int distanceCm = (duration / 2.0) * 0.0343;
    // Serial.print("Distance: ");
    Serial.println(distanceCm);
    // Serial.println(" cm");
  }

  delay(1); //tiny delay
}

