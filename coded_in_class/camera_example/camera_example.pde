import processing.video.*;

Capture cam;

void setup() {
  size(640, 480);
  String[] cameras = Capture.list();
  
  if (cameras.length > 0) {
    cam = new Capture(this, cameras[0]);
    cam.start();
    
    // Print active properties of the running camera
    println("Active Camera Width: " + cam.width);
    println("Active Camera Height: " + cam.height);
    println("Active Camera Framerate: " + cam.frameRate);
  }
}

void draw() {
  if (cam.available()) {
    cam.read();
    image(cam, 0, 0);
  }
}
