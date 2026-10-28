PImage photo;

void setup() {
  size(600, 500);
  photo = requestImage("https://images.baklol.com/6_jpegcaa1a4ecf04c355a818b4cf29af2dd87.jpeg");
}

void draw() {
  if (photo.width > 0) {
    image(photo, 0, 0, width,height);
  }
}
