boolean button = false;
Bouton Boutton;


void setup() {
  size(200, 200);
  Boutton = new Bouton(width/2, height/2, 100, 75, color(175, 175, 175));
}

void draw() {
  if (button) {
    background(255);
    stroke(0);
  } else {
    background(0);
    stroke(255);
  }

  Boutton.dessiner();
}

void mousePressed() {
    if (Boutton.sourisDedans()) {
        button = !button;
    }
}