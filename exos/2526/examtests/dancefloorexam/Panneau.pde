final float POIDS_MAX = 500;

class Panneau {
  float x, y; // position
  float w, h; // largeur et hauteur

  // entre 0 et 1, 0 = éteint, 1 = allumé à pleine puissance
  float luminosite;

  // Crée un panneau éteint avec position et taille données en paramètre
  Panneau(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  void dessiner() {
    rectMode(CORNER);
    stroke(255);
    fill(lerpColor(color(0), color(255, 255, 0), luminosite));
    rect(x, y, w, h);
  }

  // Change la luminosité de ce panneau en fonction du poids appliqué.
  // Si le poids est supérieur ou égal au POIDS_MAX, luminosité 1
  // sinon, luminosité entre 0 et 1 proportionnelle au poids
  void appliquerPoids(float poids) {
    if (luminosite > POIDS_MAX) {
      luminosite = 1;
    } else {
      luminosite = map(poids, 0, POIDS_MAX, 0, 1);
    }
  }
}
