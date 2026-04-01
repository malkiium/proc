Chronometre chrono;
Balle b1;

void setup() {
  size(400, 400);
  background(0);
  chrono = new Chronometre(3000);
  chrono.start = -3001;
  b1 = new Balle(20);
}

void draw() {
  background(0);
  b1.dessiner();
  if (chrono.estTermine()) {
    b1.bouger();
  }
}

void mousePressed() {
  chrono.lancer();
}
