Snake predator;
Snake[] followers = new Snake[10];
int CSIndex = 0;

void setup() {
  size(800, 800);
  predator = new Snake(50, color(255, 0, 0), random(2, 4), random(width), random(height));
  for (int i = 0; i < followers.length; i++) {
    followers[i] = new Snake(int(random(20, 80)),
      color(255), random(2, 10),
      random(width), random(height));
  }
}

void draw() {
  background(0);

  int i = 0;
  float closestS = 100000;

  while ( i < followers.length) {

    // detecter qui est le plus proche du preda
    float temp = dist(
      followers[i].getXTete(), followers[i].getYTete(),
      predator.getXTete(), predator.getYTete());

    if (temp < closestS) {
      closestS = temp;
      CSIndex = i;
    }

    // calcul direction oposée au preda
    if (temp < 100 && temp > 0) {
      float dx = followers[i].getXTete() - predator.getXTete();
      float dy = followers[i].getYTete() - predator.getYTete();

      // calcul point de poursuite oposée au preda
      float fleeX = followers[i].getXTete() + dx;
      float fleeY = followers[i].getYTete() + dy;

      // arret au bord. (pas contrain car il fiatu n arret net. pas de glissement)
      if (fleeX < 0) fleeX = 0;
      if (fleeX > width) fleeX = width;
      if (fleeY < 0) fleeY = 0;
      if (fleeY > height) fleeY = height;


      followers[i].avancerVers(fleeX, fleeY);
    }

    followers[i].dessiner();

    if (temp < 2) {
      float newX = random(width);
      float newY = random(height);

      for (int j = 0; j < followers[i].taille; j++) {
        followers[i].xpos[j] = newX;
        followers[i].ypos[j] = newY;
      }
    }

    i++;
  }
  predator.dessiner();
  predator.avancerVers(followers[CSIndex].getXTete(), followers[CSIndex].getYTete());
}
