import gab.opencv.*;
import processing.video.*;

//Movie video;
String[] cameras = Capture.list();
Capture cam;
OpenCV opencv;

void setup() {
  size(720, 480);
  //video = new Movie(this, "street.mov");
  
    printArray(cameras);
  //cam = new Capture(this, 640, 480, cameras[1],30); // use if camera trouble: cam = new Capture(this, 640, 480, cameras[0],30);
  cam = new Capture(this, 640, 480, "pipeline:avfvideosrc device-index=0");

  opencv = new OpenCV(this, 720, 480);

  opencv.startBackgroundSubtraction(5, 3, 0.5);

 // video.loop();
  //video.play();
  cam.start();
}

void draw() {
  image(cam, 0, 0);

  //if (video.width == 0 || video.height == 0)
  //  return;

  if (cam.available()) {
    cam.read();
  }
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

void movieEvent(Movie m) {
  m.read();
}
