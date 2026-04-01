Attrapeur attrapeur;
Chronometre chrono;
ArrayList<Goutte> gouttes = new ArrayList<Goutte>();
int points = 0;

void setup() {
  size(800, 800);
  attrapeur = new Attrapeur(32);
  chrono = new Chronometre(500);
  chrono.lancer();
}

void draw() {
  background(255);

  attrapeur.placer(mouseX, mouseY);
  attrapeur.dessiner();

  if (chrono.estTermine()) {
    chrono.lancer();
    gouttes.add(new Goutte());
  }

  for (int i = gouttes.size() - 1; i >= 0; i--) {
    Goutte g = gouttes.get(i);

    g.dessiner();
    g.bouger();

    if (attrapeur.intersecte(g)) {
      gouttes.remove(i);
      points += 1;
    } else if (g.y > height) {
      attrapeur.r = -2*width;
      textSize(40);
      text("you lost !", width/2-50, height/2);
      text(points + "points", width/2-50, height/2+50);
    }
  }
}
