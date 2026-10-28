import processing.video.*;

String[] cameras = Capture.list();
Capture cam;

void setup() {
  size(640, 480);
  printArray(cameras);
  cam = new Capture(this, 640, 480, cameras[0]); // use if camera trouble: cam = new Capture(this, 640, 480, cameras[0],30);
  cam.start();
}

void draw() {
  if (cam.available()) {
    cam.read();
  }

  image(cam, 0, 0);
}
