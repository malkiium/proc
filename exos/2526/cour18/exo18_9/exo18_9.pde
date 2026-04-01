Attrapeur attrapeur;
Chronometre chrono;
Goutte[] gouttes = new Goutte[1000];
int totalGouttes = 0;

void setup() {
  size(800, 800);
  attrapeur = new Attrapeur(32);
  chrono = new Chronometre(2000);
  chrono.lancer();
}

void draw() {
  background(255);

  // De la partie 1
  attrapeur.placer(mouseX, mouseY);
  attrapeur.dessiner();


  // De la partie 3
  if (chrono.estTermine()) {
    println("2 secondes se sont écoulées");
    chrono.lancer();
  }


  // De la partie 4
  gouttes[totalGouttes] = new Goutte();
  totalGouttes++;
  if (totalGouttes >= gouttes.length) {
    totalGouttes = 0;
  }

  for (int i = 0; i < totalGouttes; i++) {
    gouttes[i].dessiner();
    gouttes[i].bouger();
    if (attrapeur.intersecte(gouttes[i])) {
      gouttes[i].y -= height;
    }
  }
}
