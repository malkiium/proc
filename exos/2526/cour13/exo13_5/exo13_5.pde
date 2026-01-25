Balle balon;

void setup() {
  size(200, 200);
  balon = new Balle(width/2, height/2, 10, 255, 0.8);
}

void draw() {
  background(0);
  balon.dessiner(); // 1.
  balon.bouger();   // 2.
  balon.rebondir(); // 3.
}
