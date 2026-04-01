Attrapeur attrapeur;
Chronometre chrono;
ArrayList<Goutte> gouttes = new ArrayList<Goutte>();

void setup() {
  size(800, 800);
  attrapeur = new Attrapeur(32);
  chrono = new Chronometre(200);
  chrono.lancer();
}

void draw() {
  background(255);

  attrapeur.placer(mouseX, mouseY);
  attrapeur.dessiner();

  if (chrono.estTermine()) {
    println("2 secondes se sont écoulées");
    chrono.lancer();
    gouttes.add(new Goutte());
  }

  for (int i = gouttes.size() - 1; i >= 0; i--) {
    Goutte g = gouttes.get(i);

    g.dessiner();
    g.bouger();

    if (attrapeur.intersecte(g)) {
      gouttes.remove(i);
    } else if (g.y > height) {
      gouttes.remove(i);
    }
  }
}
