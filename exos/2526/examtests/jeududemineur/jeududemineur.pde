Demineur jeu;

void setup() {
  size(800, 850);
  jeu = new Demineur(16, 16, 50, 40);
}

void draw() {
  background(255);
  jeu.dessiner();
}

void mousePressed() {
  jeu.click();
}
