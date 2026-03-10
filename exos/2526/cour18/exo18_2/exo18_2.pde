Balle b1, b2;

void setup() {
  size(400, 400);
  b1 = new Balle(64);
  b2 = new Balle(32);
}

void draw() {
  background(0);
  if (b1.intersecte(b2)) {
    b1.changerColor();
    b2.changerColor();
  }
  b1.dessiner();
  b2.dessiner();
  b1.bouger();
  b2.bouger();
}
