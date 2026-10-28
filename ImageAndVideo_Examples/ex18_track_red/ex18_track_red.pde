

import processing.video.*;

String[] cameras = Capture.list();
Capture cam;

int THRES = 150;

void setup() {
  size(640, 480);
  printArray(cameras);
  //cam = new Capture(this, 640, 480, cameras[1],30); // use if camera trouble: cam = new Capture(this, 640, 480, cameras[0],30);
  cam = new Capture(this, 640, 480, "pipeline:avfvideosrc device-index=0");

  cam.start();
}

void draw() {
  if (cam.available()) {
    cam.read();
  }


  for (int j=0; j < height; j++) {
    for (int i=0; i < width; i++) {

      int p = i + j *width;
      color currentColor = cam.pixels[p];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);

      float d = dist (r1, g1, b1, 255, 0, 0);

      if ( d < THRES ) {
        cam.pixels[p] = color (255, 0, 0);
      } else {
        cam.pixels[p] = color(255, 255, 255);
      }
    }
  }
  cam.updatePixels();
  image(cam, 0, 0);
}
