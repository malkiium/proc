class Balle {
  float r;      // Rayon
  float x, y;   // Position
  float vx, vy; // Vitesse
  color coulor;

  Balle(float r) {
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
    if (x-r < 0 || x+r > width) {
      vx *= -1;
    }
    if (y-r < 0 || y+r > height) {
      vy *= -1;
    }
  }

  void dessiner() {
    stroke(255);
    fill(coulor, 80);
    ellipse(x, y, 2 * r, 2 * r);
  }
  
  boolean intersecte(Balle b) {
    return dist(x, y, b.x, b.y) < r + b.r;
  }
  
  void changerColor() {
    coulor = color(random(255), random(255), random(255));
  }
}
