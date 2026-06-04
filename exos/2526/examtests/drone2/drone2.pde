int n = 8; // nombre de sites
int siteW; // la largeur d'un site (immeuble)

int droneX, droneY; // position du drone
int tailleDrone;

boolean modeManuel = false; // est-ce que le pilotage manuel est autorisé ?
int siteCible = 0; // numéro du site sélectionné, destination du drone
int nxtSite = 7;

void setup() {
  size(800, 800);

  siteW = width / n;
  tailleDrone = siteW / 2;

  // au début le drone est dans l'entrepôt
  droneX = siteX(0);
  droneY = siteY(0);
}

void draw() {
  background(0);

  dessinerDrone();

  // TODO dessiner les sites - question 1
  for (int dn=0; dn<n; dn++) {
    dessinerSite(dn);
  }

  if (modeManuel) {
    for (int sisel=0; sisel<n; sisel++) {
      if (mouseX>(siteX(sisel)-siteW/2) && mouseX < siteX(sisel)+(siteW/2)
        && mouseY > siteY(sisel) && mouseY <= height && mousePressed) {
        siteCible = sisel;
      }
    }
  } else {
    if (droneX == siteX(0) && droneY == siteY(0)) {
      siteCible = nxtSite;
      nxtSite +=1;
      if (nxtSite == n) {
        nxtSite = 1;
      }
    }
    if (droneX == siteX(siteCible) && droneY == siteY(siteCible)) {
      siteCible = 0;
    }
  }

  avancerVers(siteX(siteCible), siteY(siteCible));
}

// dessine un site
void dessinerSite(int site) {
  int x = siteX(site);
  int y = siteY(site);
  stroke(0);
  fill(128);
  rect(x - siteW / 2, y, siteW, width - y);
  if (site == siteCible) {
    noStroke();
    fill(0);
    triangle(x, y, x - 10, y + 20, x + 10, y + 20);
  }

  // TODO dessiner les fenêtres - question 2
  int windSpace = siteW/9;
  fill(255, 255, 0);
  if (site != 0) {
    for (int rep=1; rep<5; rep+=1) {
      for (int hr=1; hr<((height-y)/(windSpace*2)); hr++) {
        square((((windSpace*2)*rep)+(siteW*(x/siteW))-windSpace), height-((windSpace*2)*hr), windSpace);
      }
    }
  }
}

// dessine le drone
void dessinerDrone() {
  noStroke();
  fill(255, 117, 24);
  rect(droneX - tailleDrone / 2, droneY - tailleDrone / 2, tailleDrone, tailleDrone / 2);

  // les hélices
  int r = tailleDrone / 4;
  dessinerHelice(droneX - r, droneY - 3 * r, r);
  dessinerHelice(droneX + r, droneY - 3 * r, r);

  // la lumière
  noStroke();
  fill(255, 255, 0, 64);
  int h = min(distToGround(droneX, droneY), 2 * tailleDrone);
  float delta = h * tan(PI / 12);
  triangle(droneX, droneY, droneX - delta, droneY + h, droneX + delta, droneY + h);
}

// dessine une hélice
void dessinerHelice(int x, int y, int rayon) {
  stroke(255);
  noFill();
  ellipseMode(RADIUS);
  circle(x, y, rayon);
  line(x - rayon, y, x + rayon, y);
  line(x, y - rayon, x, y + rayon);
}

// fait avancer le drone vers la position (x, y)
void avancerVers(int x, int y) {
  // TODO - question 4

  if (droneX < x) {
    if (!envoyerCommande('R')) {
      envoyerCommande('U');
    }
  } else if (droneX > x) {
    if (!envoyerCommande('L')) {
      envoyerCommande('U');
    }
  } else if (droneY > y) {
    envoyerCommande('U');
  } else if (droneY < y) {
    envoyerCommande('D');
  }
  // /!\ Ne pas modifier droneX et droneY directement
}

/*
 * /!\ Les fonctions permettant de récupérer les coordonnées d'un site
 * utilisent de la trigonomagie de Noël !
 * Ne cherchez pas à comprendre, utilisez siteX() et siteY() comme des boîtes noires.
 */

// renvoie l'abscisse d'un site
int siteX(int site) {
  return int((0.5 + site) * siteW);
}

// renvoie l'ordonnée d'un site
int siteY(int site) {
  return height / 2 + (1 - 2 * (site % 2)) * getH(site);
}

int magic = int(random(8, 13));

int getH(int site) {
  String s = nf(sin(site + 1), 0, magic);
  return int((1 + 2 * float("0." + s.substring(s.length() - 6))) * height / 8);
}

/*
 * Firmware du drone. Ne cherchez pas à comprendre,
 * utilisez envoyerCommande() comme une boîte noire.
 * Vous n'aurez pas besoin d'utiliser les autres fonctions
 */

// Transmet une des commandes U, D, L ou R au drone
// Renvoie true si le drone a bougé dans la direction indiquée
// Si le drone est resté sur place pour des raisons de sécurité, renvoie false
boolean envoyerCommande(char commande) {
  if (commande == 'U') {
    if (!checkUp(droneY - 1)) return false;
    droneY--;
  } else if (commande == 'D') {
    if (!checkDown(droneX, droneY + 1)) return false;
    droneY++;
  } else if (commande == 'L') {
    if (!checkRL(droneX - 1, droneY)) return false;
    droneX--;
  } else if (commande == 'R') {
    if (!checkRL(droneX + 1, droneY)) return false;
    droneX++;
  }
  return true;
}

boolean checkUp(int y) {
  return y > tailleDrone;
}

boolean checkDown(int x, int y) {
  return distToGround(x - tailleDrone / 2, y) >= 0
    && distToGround(x + tailleDrone / 2, y) >= 0;
}

boolean checkRL(int x, int y) {
  return distToGround(x - tailleDrone / 2, y) >= tailleDrone
    && distToGround(x + tailleDrone / 2, y) >= tailleDrone
    && distToGround(x - 3 * tailleDrone / 4, y) >= tailleDrone
    && distToGround(x + 3 * tailleDrone / 4, y) >= tailleDrone;
}

int distToGround(int x, int y) {
  return siteY(x / siteW) - y;
}
