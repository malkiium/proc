class Case {
  float x, y;      // coordonnées du coin supérieur gauche
  float taille;    // taille (largeur et hauteur)
  boolean mine;    // est-ce que la case contient une mine ?
  boolean cachee;  // est-ce que la case est cachée ?
  boolean drapeau; // est-ce que la case est marquée par un drapeau ?
  int minesAutour; // nombre de mines dans les huit cases voisines

  Case(float x, float y, float taille) {
    // TODO (question 1)
    this.x = x;
    this.y = y;
    this.taille = taille;

    cachee = true;
  }

  // Vérifie si la case contient le point (mx, my)

  boolean contient(float mx, float my) {
    return mx > x && mx < x + taille
      && my > y && my < y + taille;
  }

  void dessiner() {
    stroke(1);
    if (cachee) {
      fill(128);
      rect(x, y, taille, taille);
      if (drapeau) {
        noStroke();
        fill(255, 0, 0);
        triangle(x + 0.25 * taille, y + 0.25 * taille,
          x + 0.25 * taille, y + 0.75 * taille,
          x + 0.75 * taille, y + 0.5 * taille);
      }
    } else {
      fill(191);
      rect(x, y, taille, taille);
      if (mine) {
        fill(0);
        ellipse(x + taille / 2, y + taille / 2, taille / 2, taille / 2);
      } else if (minesAutour > 0) {

        if (minesAutour == 1) {
          fill(255, 255, 0);      // yellow
        } else if (minesAutour == 2) {
          fill(255, 165, 0);      // orange
        } else if (minesAutour == 3) {
          fill(255, 0, 0);        // red
        } else if (minesAutour == 4) {
          fill(128, 0, 128);      // purple
        } else if (minesAutour == 5) {
          fill(255);              // white
        } else {
          fill(0);                // black (6+)
        }

        textSize(taille / 2);
        textAlign(CENTER, CENTER);
        text(minesAutour, x + taille / 2, y + taille / 2);
      }
    }
  }
}
