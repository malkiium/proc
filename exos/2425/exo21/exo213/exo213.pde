void setup() {
  size(800, 400);
  background(255);
  stroke(0);
  frameRate(1);
}

void draw() {
  background(255);
  int depth = frameCount;
  branche(width / 2, height, 200, depth);
}

void branche(float x, float y, float h, int depth) {
  if (depth > 0) {
    line(x, y, x - h, y - h);
    line(x, y, x + h, y - h);
    if (h > 1) {
      branche(x - h, y - h, h / 2, depth - 1);
      branche(x + h, y - h, h / 2, depth - 1);
    }
  }
}
