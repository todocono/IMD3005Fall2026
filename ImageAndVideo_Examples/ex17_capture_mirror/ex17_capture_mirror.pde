import processing.video.*; 

String[] cameras = Capture.list();
Capture cam;

void setup() { 
  size(1280, 480); 
  cam = new Capture(this, cameras[0]);  // use if camera trouble: cam = new Capture(this, 640, 480, cameras[0],30);

  cam.start();
} 

void draw() { 
  if (cam.available()) { 
    cam.read();
  } 
  
  scale(-1, 1);
  image(cam, -640, 0);
  scale(-1, 1);
  image(cam, 640, 0);
}
