Balle[] balon = new Balle[3];

void setup() {
  size(200, 200);
  for(int i=0; i<3; i++) {
    balon[i] = new Balle(width/5+((i*width)/5), height/2, 30, 255/(i+1), 0.8);
  }
}

void draw() {
  background(0);
  for(int i=0; i<3; i++) {
    balon[i].dessiner(); // 1.
    balon[i].bouger();   // 2.
    balon[i].rebondir(); // 3.
  }
}
