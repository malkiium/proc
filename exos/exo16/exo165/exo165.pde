class Snake {
  int taille;
  color couleur;
  float vitesse;
  float[] xpos;
  float[] ypos;

  Snake(int taille, color couleur, float vitesse, float x0, float y0) {
    this.taille = taille;
    this.couleur = couleur;
    this.vitesse = vitesse;

    xpos = new float[taille];
    ypos = new float[taille];
    for (int i = 0; i < taille; i++) {
      xpos[i] = x0;
      ypos[i] = y0;
    }
  }

  void dessiner() {
    noStroke();
    for (int i = 0; i < taille; i++) {
      fill(lerpColor(color(255), couleur, i / (taille - 1.0)));
      ellipse(xpos[i], ypos[i], i, i);
    }
    dessinerBouche();
  }

  void dessinerBouche() {
    float xTete = xpos[taille - 1];
    float yTete = ypos[taille - 1];
    fill(255, 0, 0);
    ellipse(xTete, yTete, taille / 5, taille / 5); // Mouth size scales with snake size
  }

  void deplacer(float x, float y) {
    for (int i = 0; i < taille - 1; i++) {
      xpos[i] = xpos[i + 1];
      ypos[i] = ypos[i + 1];
    }
    xpos[taille - 1] = x;
    ypos[taille - 1] = y;
  }

  void avancerVers(float x, float y) {
    float xTete = xpos[taille - 1];
    float yTete = ypos[taille - 1];
    float d = dist(xTete, yTete, x, y);
    float vx = vitesse * (x - xTete) / d;
    float vy = vitesse * (y - yTete) / d;
    deplacer(xTete + vx, yTete + vy);
  }

  void grandir() {
    int nouvelleTaille = int(taille * 1.25);
    float[] newXpos = new float[nouvelleTaille];
    float[] newYpos = new float[nouvelleTaille];
    for (int i = 0; i < taille; i++) {
      newXpos[i] = xpos[i];
      newYpos[i] = ypos[i];
    }
    for (int i = taille; i < nouvelleTaille; i++) {
      newXpos[i] = xpos[taille - 1];
      newYpos[i] = ypos[taille - 1];
    }
    xpos = newXpos;
    ypos = newYpos;
    taille = nouvelleTaille;
  }

  float getXTete() {
    return xpos[taille - 1];
  }

  float getYTete() {
    return ypos[taille - 1];
  }

  float getXQueue() {
    return xpos[0];
  }

  float getYQueue() {
    return ypos[0];
  }
}

class Prey {
  float x, y;
  float vitesse;
  color couleur;

  Prey(float x, float y, float vitesse, color couleur) {
    this.x = x;
    this.y = y;
    this.vitesse = vitesse;
    this.couleur = couleur;
  }

  void dessiner() {
    fill(couleur);
    ellipse(x, y, 10, 10);
  }

  void eviter(Snake predator) {
    float d = dist(x, y, predator.getXTete(), predator.getYTete());
    if (d < 100) {
      float vx = vitesse * (x - predator.getXTete()) / d;
      float vy = vitesse * (y - predator.getYTete()) / d;
      x += vx;
      y += vy;
    }
    teleportIfOutOfMap();
  }

  void teleportIfOutOfMap() {
    if (x < 0) x = width/2;
    if (x > width) x = width/2;
    if (y < 0) y = height/2;
    if (y > height) y = height/2;
  }
}

Snake predator;
Prey[] preys = new Prey[20];
float targetX, targetY;

void setup() {
  size(800, 800);
  frameRate(120);
  predator = new Snake(50, color(255, 0, 0), 4, width / 2, height / 2); // Reduced speed
  for (int i = 0; i < preys.length; i++) {
    preys[i] = new Prey(random(width), random(height), random(2, 5), color(0, 255, 0));
  }
  targetX = random(width);
  targetY = random(height);
}

void draw() {
  background(0);

  // Find the nearest prey
  float minDist = Float.MAX_VALUE;
  Prey nearestPrey = null;
  for (Prey prey : preys) {
    float d = dist(predator.getXTete(), predator.getYTete(), prey.x, prey.y);
    if (d < minDist) {
      minDist = d;
      nearestPrey = prey;
    }
  }

  // Set the target to the nearest prey
  if (nearestPrey != null) {
    targetX = nearestPrey.x;
    targetY = nearestPrey.y;
  }

  predator.avancerVers(targetX, targetY);
  predator.dessiner();

  // Check if the predator has reached the target prey
  if (nearestPrey != null && dist(predator.getXTete(), predator.getYTete(), targetX, targetY) < 10) {
    predator.grandir();
    // Remove the eaten prey
    Prey[] newPreys = new Prey[preys.length - 1];
    int index = 0;
    for (Prey prey : preys) {
      if (prey != nearestPrey) {
        newPreys[index++] = prey;
      }
    }
    preys = newPreys;
  }

  // Draw and update the preys
  for (Prey prey : preys) {
    prey.eviter(predator);
    prey.dessiner();
  }
}