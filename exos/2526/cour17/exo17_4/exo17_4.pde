ArrayList<Cercle> circle = new ArrayList();

void setup() {
  size(900, 900);
}

void draw() {
  background(0);
  for (int i = 0; i<circle.size(); i++) {
    circle.get(i).dessiner();
  }
}

void mousePressed() {
  if (mouseButton == LEFT) {
    circle.add(new Cercle(mouseX, mouseY));
  } else if (mouseButton == RIGHT) {
    for (int i = circle.size()-1; i>= 0; i--) {
      if (circle.get(i).estDedans(mouseX, mouseY)) {
        circle.remove(i);
      }
    }
  }
}
