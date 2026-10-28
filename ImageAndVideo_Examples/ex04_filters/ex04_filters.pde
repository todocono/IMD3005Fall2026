PImage photo;
photo = loadImage("yao.gif");

size(600, 600);
image(photo, 0, 0);
filter(INVERT);

//filter(BLUR);
//filter(BLUR, 6);
//filter(GRAY);
//filter(THRESHOLD);
