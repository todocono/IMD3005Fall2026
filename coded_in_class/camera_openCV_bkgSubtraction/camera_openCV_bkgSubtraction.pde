import gab.opencv.*;
import processing.video.*;

Capture cam;
OpenCV opencv;

void setup() {
  size(720, 480);
 
  cam = new Capture(this, 640, 480);
  cam.start();
  opencv = new OpenCV(this, 640, 480);

  opencv.startBackgroundSubtraction(5, 3, 0.5);

}

void draw() {
  //image(cam, 0, 0);

  //if (cam.width == 0 || cam.height == 0)
    //return;
if (cam.available()) {
    cam.read();
  }
  image(cam, 0, 0);
  
  opencv.loadImage(cam);
  opencv.updateBackground();

  opencv.dilate();
  opencv.erode();

  noFill();
  stroke(255, 0, 0);
  strokeWeight(3);
  for (Contour contour : opencv.findContours()) {
    contour.draw();
  }
}

//void movieEvent(Movie m) {
//  m.read();
//}
