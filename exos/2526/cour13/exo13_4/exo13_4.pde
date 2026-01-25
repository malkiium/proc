Balle balon;

void setup() {
  size(200, 200);
  balon = new Balle();
}

void draw() {
  background(0);
  balon.dessiner(); // 1.
  balon.bouger();   // 2.
  balon.rebondir(); // 3.
}
