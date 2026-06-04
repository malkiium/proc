class Danseur {
  float x, y;    // position
  float v;       // vitesse de déplacement
  float poids;   // poids
  color couleur; // couleur

  Danseur() {
    x = random(width);
    y = random(height);
    poids = random(40, 120);
    v = random(1, 3);
    couleur = color(random(255), random(255), random(255));
  }

  void dessiner() {
    ellipseMode(RADIUS);
    noStroke();
    fill(couleur);
    circle(x, y, 0.1 * poids);
  }

  void bouger() {
    float dir = random(TWO_PI);
    x = constrain(x + v * cos(dir), 0, width);
    y = constrain(y + v * sin(dir), 0, height);
  }
}
