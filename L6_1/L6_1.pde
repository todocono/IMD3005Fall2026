/* 
* Example coded live IMD3005 - Fall 2026
* Algonquin College
* 
* Step 1 - Gradient on the sky and rotating moon/sun
*/

float time;
void setup(){
  colorMode(HSB, 360, 100, 100);
  size(600,1200);
}

void draw(){
  time = millis() % 2000;
  sky(time);
}


void sky(float t){
  noStroke();
  for (int j=0; j < height; j+=10){
    float c = map (j, height, 0, 0, 60);
    fill(c+t,100,100);
    rect(0,j,width,j+10);
  }
}
