void setup() {
  size(800, 400);
  background(255);
  stroke(0);
  branche(width / 2, height, height / 2);
  save("Arbre.png");
}

void branche(float x, float y, float h) {
  line(x, y, x - h, y - h);
  line(x, y, x + h, y - h);
  if (h > 1) {
    branche(x - h, y - h, h / 2);
    branche(x + h, y - h, h / 2);
  }
}
