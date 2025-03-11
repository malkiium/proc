void setup() {
  size(1000, 250);
  background(255);
  stroke(0);
  noFill();
  dessinerRegle(width / 2, height / 2, width / 2);
  save("Regle.png");
}

void dessinerRegle(float x, float y, float taille) {
  line(x, y+height/2, x, (y+height/2) - taille/4);
  if (taille > 2) {
    dessinerRegle(x + taille / 2, y, taille / 2);
    dessinerRegle(x - taille / 2, y, taille / 2);
  }
}