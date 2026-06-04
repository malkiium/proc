class Dancefloor {
  Panneau[] panneaux;

  // Crée la grille de panneaux
  Dancefloor(int lignes, int colonnes) {
    panneaux = new Panneau[lignes * colonnes];
    float w = float(width) / colonnes;
    float h = float(height) / lignes;
    int k = 0;
    for (int i = 0; i < lignes; i++) {
      for (int j = 0; j < colonnes; j++) {
        panneaux[k] = new Panneau(w * j, h * i, w, h);
        k++;
      }
    }
  }

  // Dessine tous les panneaux
  void dessiner() {
    for (int i = 0; i<panneaux.length; i++) {
      panneaux[i].dessiner();
    }
  }

  void eclairer(Foule foule) {

    for (int i = 0; i<panneaux.length; i++) {
      float poid = foule.poidsDansRect(panneaux[i].x, panneaux[i].y, panneaux[i].w, panneaux[i].h);
      panneaux[i].appliquerPoids(poid);
    }
  }
}
