class Voiture {
    // attributs
    float x, y;
    float vitesse;
    color couleur;
    float taille;

    // constructeurs
    Voiture() {
        x = 0;
        y = height / 2;
        vitesse = random(1, 5); // Random speed between 1 and 5
        couleur = color(255, 0, 0);
        taille = 50;
    }

    Voiture(float x, float y, float vitesse, color couleur, float taille) {
        this.x = x;
        this.y = y;
        this.vitesse = vitesse;
        this.couleur = couleur;
        this.taille = taille;
    }

    // méthodes
    void dessiner() {
        rectMode(CENTER);
        fill(couleur);
        rect(x, y, taille, taille / 2);
    }

    void bouger() {
        x = (x + vitesse) % width;
    }
}

class Bande {
  float x;
  float v;
  float w;
  boolean mouse;

  Bande() {
    x = 0;
    v = random(1);
    w = random(10, 30);
    mouse = false;
  }

  void dessiner() {
    if(mouse) {
      fill(255);
    } else {
      fill(255, 100);
    }
    noStroke();
    rectMode(CORNER);
    rect(x, 0, w, height);
  }

  void bouger() {
    x += v;
    if(x > width) x = -w;
  }

  void rollover(Voiture[] voitures) {
    mouse = false;
    for (int i = 0; i < voitures.length; i++) {
      if (voitures[i].x > x && voitures[i].x < x + w) {
        mouse = true;
        break;
      }
    }
  }
}

Voiture[] voitures = new Voiture[30];
Bande[] bandes = new Bande[50];

void setup() {
    size(800, 800);
    for (int i = 0; i < voitures.length; i++) {
        float randomY = random(height);
        float randomSpeed = random(1, 5); // Random speed between 1 and 5
        voitures[i] = new Voiture(0, randomY, randomSpeed, color(255, 0, 0), 50);
    }
    for (int i = 0; i < bandes.length; i++) {
        bandes[i] = new Bande();
    }
}

void draw() {
    background(100);
    for (int i = 0; i < voitures.length; i++) {
        voitures[i].bouger();
        voitures[i].dessiner();
    }
    for (int i = 0; i < bandes.length; i++) {
        bandes[i].bouger();
        bandes[i].rollover(voitures);
        bandes[i].dessiner();
    }
}