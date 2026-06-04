class Foule {
  Danseur[] danseurs;

  // Crée une foule de nombreDeDanseurs danseurs
  Foule(int nombreDeDanseurs) {
    danseurs = new Danseur[nombreDeDanseurs];
    for (int i = 0; i<nombreDeDanseurs; i++) {
      danseurs[i] = new Danseur();
    }
  }

  // Dessine tous les danseurs
  void dessiner() {
    for (int i = 0; i<danseurs.length; i++) {
      danseurs[i].dessiner();
    }
  }

  // Bouge tous les danseurs
  void bouger() {
    for (int i = 0; i<danseurs.length; i++) {
      danseurs[i].bouger();
    }
  }

  float poidsDansRect(float x, float y, float w, float h) {
    float poidtot = 0;
    for (int i = 0; i<danseurs.length; i++) {
      if (danseurs[i].x > x && danseurs[i].x < x+w && danseurs[i].y > y && danseurs[i].y < y+h) {
        poidtot += danseurs[i].poids;
      }
    }
    return poidtot;
  }
}
