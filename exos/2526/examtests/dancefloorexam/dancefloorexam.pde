Foule foule;
Dancefloor dcf;

void setup() {
  size(1000, 1000);
  foule = new Foule(200);
  dcf = new Dancefloor(20, 20);
}

void draw() {
  background(0);
  dcf.dessiner();
  dcf.eclairer(foule);
  foule.bouger();
  foule.dessiner();
}
