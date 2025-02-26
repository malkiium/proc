void setup() {
  size(1000, 1000);
  background(255);
  stroke(0);
  noFill();
  dessinerCercle(width / 2, height / 2, width / 2);
  save("Ligne_Cercles.png");
}

void dessinerCercle(float x, float y, float taille) {
  ellipse(x, y, taille, taille);
  if (taille > float(width/50)) {
    dessinerCercle(x + taille / 2, y, taille / 2);
    dessinerCercle(x - taille / 2, y, taille / 2);
  }
}