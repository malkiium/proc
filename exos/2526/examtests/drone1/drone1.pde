// car en octale, le 31, est le meme chifre que le 25 en décimale., doit Dec (decembre) 25 == Oct (octobre) 31
int n = 10; // nombre de sites

int tailleSite = 100;
int tailleDrone = 3 * tailleSite / 4;

int droneX, droneY; // position du drone

boolean modeManuel = false; // est-ce que le pilotage manuel est autorisé ?
int siteSelection = 0; // numéro du site sélectionné, destination du drone
float siteOnMouse;
boolean retourBase = true;
int nextSite = 0;

void setup() {
  size(800, 800);

  // au début le drone est dans l'entrepôt
  droneX = siteX(0);
  droneY = siteY(0);
}

void draw() {
  background(0, 120, 80);
  dessinerSapins();


  for (int i = 0; i<n; i++) {
    dessinerSite(i);
    if (modeManuel) {
      siteOnMouse = dist(mouseX, mouseY, siteX(i), siteY(i));
      if ((siteOnMouse<(tailleSite/2)) && (mousePressed)) {
        siteSelection = i;
      }
    }
  }
  if (!modeManuel) {
    if (retourBase) {
      siteSelection = 0;

      println(nextSite);
      if (nextSite == n) {
        nextSite=1;
      }
    } else {
      siteSelection = nextSite;
    }
  }
  if (dist(droneX, droneY, siteX(siteSelection), siteY(siteSelection)) < tailleSite/10) {
    retourBase = !retourBase;
    if (retourBase) {
      nextSite+=1;
    }
  }


  dessinerDrone();
  avancerVers(siteX(siteSelection), siteY(siteSelection));
}

// dessine un motif qui rappelle des sapins
void dessinerSapins() {
  stroke(255);
  strokeWeight(1);
  for (int w=0; w<width/10; w+=2) {
    for (int h=0; h<height/10; h+=1) {
      line((w+2)*10, (h-1)*13, (w+1)*10, h*13); //totop
      line(w*10, (h-1)*13, (w+1)*10, h*13); //tobottom
    }
  }
}

// fait avancer le drone vers la position (x, y)
void avancerVers(int x, int y) {
  if (x>droneX) {
    envoyerCommande('E');
  } else if (x<droneX) {
    envoyerCommande('O');
  }
  if (y>droneY) {
    envoyerCommande('S');
  } else if (y<droneY) {
    envoyerCommande('N');
  }
  // /!\ Ne pas modifier droneX et droneY directement
}

// Transmet une des commandes N, S, O ou E au drone qui change sa position
void envoyerCommande(char commande) {
  if (commande == 'N' && droneY > 0) {
    droneY--;
  } else if (commande == 'S' && droneY < height) {
    droneY++;
  } else if (commande == 'O' && droneX > 0) {
    droneX--;
  } else if (commande == 'E' && droneX < width) {
    droneX++;
  }
}

// dessine le drone
void dessinerDrone() {
  noStroke();
  fill(255, 117, 24);
  rectMode(CENTER);
  rect(droneX, droneY, tailleDrone, tailleDrone / 2);

  // c'est un quadricoptère
  int r = tailleDrone / 8;
  int dx = tailleDrone / 2 + r;
  int dy = tailleDrone / 4 + r;
  for (int s = 0; s < 4; s++) {
    int sx = 2 * (s % 2) - 1;
    int sy = 2 * (s / 2) - 1;
    dessinerHelice(droneX + sx * dx, droneY + sy * dy, r);
  }
}

// dessine une hélice
void dessinerHelice(int x, int y, int rayon) {
  stroke(0);
  noFill();
  ellipseMode(RADIUS);
  circle(x, y, rayon);
  line(x - rayon, y, x + rayon, y);
  line(x, y - rayon, x, y + rayon);
}

// dessine un site
void dessinerSite(int site) {
  int x = siteX(site);
  int y = siteY(site);

  if (site == siteSelection) {
    strokeWeight(3);
    stroke(255, 0, 0);
  } else {
    strokeWeight(1);
    stroke(0);
  }
  if (dist(x, y, droneX, droneY) < tailleSite / 2) {
    fill(191);
  } else {
    fill(255);
  }
  ellipseMode(CENTER);
  circle(x, y, tailleSite);
}

/*
 * /!\ Ce qui suit est de la trigonomagie de Noël !
 * Ne cherchez pas à comprendre, utilisez siteX() et siteY() comme des boîtes noires.
 */

// renvoie l'abscisse d'un site
int siteX(int site) {
  return int(width / 2 + getR(site) * cos(TWO_PI * site / (n - 1)));
}

// renvoie l'ordonnée d'un site
int siteY(int site) {
  return int(height / 2 + getR(site) * sin(TWO_PI * site / (n - 1)));
}

int magic = int(random(8, 13));

float getR(int site) {
  if (site == 0) return 0;
  String s = nf(sin(site), 0, magic);
  return width / 4 + float("0." + s.substring(s.length() - 6)) * (width / 4 - tailleSite / 2);
}
