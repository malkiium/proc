int lim = 12; // Profondeur de récursion

void setup() {
  size(800, 800);
  background(255);
  noFill();
  stroke(0);
  sierpinski(width / 2, 100, width / 2, lim); // Position de départ plus haut
}

void sierpinski(float x, float y, float size, int depth) {
  if (depth == 0) {
    drawCircle(x, y, size);
  } else {
    float newSize = size / 2;
    float h = newSize * sqrt(3) / 2;

    sierpinski(x, y, newSize, depth - 1);              // Cercle du haut (maintenant)
    sierpinski(x - newSize, y + h, newSize, depth - 1); // Cercle en bas à gauche
    sierpinski(x + newSize, y + h, newSize, depth - 1); // Cercle en bas à droite
  }
}

void drawCircle(float x, float y, float size) {
  circle(x, y, size); // Cercles qui se touchent
}
