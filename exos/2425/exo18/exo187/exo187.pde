
class Goutte {
  float x, y;     // Position
  float v;        // Vitesse
  color c;        // Couleur
  float r;        // Rayon

  Goutte() {
    r = 8;      // Nos gouttes ont toutes la même taille pour l'instant.
    x = random(width);
    y = -4 * r; // on commence légèrement au dessus du haut de l'écran.
    v = random(1, 5);
    c = color(50, 100, 150);
  }

  void bouger() {
    y += v;
  }

  boolean enBas() {
    return y > height + 4 * r;
  }

  void dessiner() {
    fill(c);
    noStroke();
    ellipse(x, y, 2 * r, 2 * r);
  }
}

class Attrapeur {
  float r;    // Rayon
  float x, y; // Position

  Attrapeur(float r) {
    this.r = r;
    x = 0;
    y = 0;
  }

  void placer(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void dessiner() {
    stroke(0);
    fill(175);
    ellipse(x, y, 2 * r, 2 * r);
  }
}

class Chronometre {
  int start;
  int tempsTotal;

  Chronometre(int tempsTotal) {
    start = millis();
    this.tempsTotal = tempsTotal;
  }

  void lancer() {
    start = millis();
  }

  boolean estTermine() {
    return millis() - start > tempsTotal;
  }
}

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
  }  
}