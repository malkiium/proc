float gravite = 0.1;

class Balle {
  float x, y;
  float rayon;
  color couleur;
  float elasticite;
  float vitesse;

  Balle(float x, float y, float rayon, color couleur, float elasticite) {
    this.x = x;
    this.y = y;
    this.rayon = rayon;
    this.couleur = couleur;
    this.elasticite = elasticite;
    vitesse = 0;
  }

  void dessiner() {
    noStroke();
    fill(couleur);
    ellipseMode(RADIUS);
    ellipse(x, y, rayon, rayon);
  }

  void bouger() {
    y += vitesse;
    vitesse += gravite;
  }

  void rebondir() {
    if (y > height - rayon) {
      vitesse *= - elasticite;
    }
  }
}