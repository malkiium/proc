class RectA {
  float r;      // Rayon
  float x, y;   // Position
  float vx, vy; // Vitesse
  color coulor;

  RectA(float r) {
    this.r = r;
    x = random(r+2, width-(r+2));
    y = random(r+2, height-(r+2));
    vx = random(-5, 5);
    vy = random(-5, 5);
    this.coulor = color(50, 50, 50);
  }

  void bouger() {
    x += vx;
    y += vy;
    if (x-(r/2) < 0 || x+(r/2) > width) {
      vx *= -1;
    }
    if (y-(r/2) < 0 || y+(r/2) > height) {
      vy *= -1;
    }
  }

  void dessiner() {
    stroke(255);
    rectMode(CENTER);
    fill(coulor, 80);
    rect(x, y, r, r);
  }

  boolean intersecte(RectA b) {
    return abs(x - b.x) < (r/2 + b.r/2) &&
      abs(y - b.y) < (r/2 + b.r/2);
  }

  void changerColor() {
    coulor = color(random(255), random(255), random(255));
  }
}
