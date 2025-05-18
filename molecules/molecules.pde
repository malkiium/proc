class Molecule {
  float x, y;
  float vx, vy;
  float r;
  color col;

  Molecule(float x, float y, float r) {
    this.x = x;
    this.y = y;
    this.r = r;
    this.vx = random(-1, 1);
    this.vy = random(-1, 1);
    this.col = color(random(255), random(255), random(255));
  }

  void deplacer() {
    this.x += this.vx;
    this.y += this.vy;

    // Rebonds sur les bords
    if (this.x > width - r || this.x < r) {
      this.vx *= -1;
    }
    if (this.y > height - r || this.y < r) {
      this.vy *= -1;
    }
  }

  void afficher() {
    fill(col);
    noStroke();
    circle(x, y, 2*r);
  }
}

Molecule m;
Molecule y;

void setup() {
  size(400, 400);
  background(255);
  m = new Molecule(random(width), random(height), random(10, 50));
  y = new Molecule(random(width), random(height), random(10, 50));
}

void draw() {
  background(255);
  m.deplacer();
  m.afficher();
}
