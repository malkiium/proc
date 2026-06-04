Grille grille;

void setup() {
  size(400, 400);
  grille = new Grille(3, 3);
}

void draw() {
  background(0);
  grille.dessiner();
}

void mousePressed() {
  grille.click(mouseX, mouseY);
}
