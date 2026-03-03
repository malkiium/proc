class Cercle {
  float x, y, rayon;
  color couleur;

  Cercle(float x, float y, float rayon, color couleur) {
    this.x = x;
    this.y = y;
    this.rayon = rayon;
    this.couleur = couleur;
  }

  Cercle (float x, float y) {
    this(x, y, random(10, 50), color(random(255), random(255), random(255)));
  }

  void dessiner() {
    noStroke();
    fill(couleur);
    ellipseMode(RADIUS);
    circle(x, y, rayon);
  }

  boolean estDedans(float mx, float my) {
    return dist(x, y, mx, my) < rayon;
  }
}
