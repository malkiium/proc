class Demineur {
  int lignes, colonnes; // nombre de lignes et colonnes de la grille
  int mines;            // nombre total de mines
  Case[][] grille;      // la grille représentant le champ de mines

  // Ces attributs sont utilisés pour suivre la progression du jeu
  int casesRevelees; // nombre de cases révélées
  int casesMarquees; // nombre de cases marquées par un drapeau
  boolean boom;      // true si le joueur a cliqué sur une case contenant une mine
  int minePoser = 0;
  float tailleCase;

  Demineur(int lignes, int colonnes, float tailleCase, int mines) {
    this.lignes = lignes;
    this.colonnes = colonnes;
    this.mines = mines;
    casesRevelees = 0;
    casesMarquees = 0;
    boom = false;
    this.tailleCase = tailleCase;

    // TODO (question 4)
    // 4.1. Créez la grille et les cases.
    // Placez grille[i][j] à la position (j * tailleCase, 50 + i * tailleCase).
    // Ainsi une bande sera disponible en haut de la fenêtre pour afficher des messages.
    grille = new Case[lignes][colonnes];

    for (int i = 0; i < lignes; i++) {
      for (int j = 0; j < colonnes; j++) {
        grille[i][j] = new Case(j * tailleCase, 50 + i * tailleCase, tailleCase);
      }
    }

    // 4.2.Posez le nombre nécessaire de mines.
    // Vous pouvez vous servir de la méthode poserMine().

    while (minePoser<mines) {
      poserMine();
    }

    // 4.3. Calculez le nombre de mines autour de chaque case vide.
    // Vous pouvez vous servir de la méthode minesAutour().

    for (int i = 0; i < lignes; i++) {
      for (int j = 0; j < colonnes; j++) {
        if (!grille[i][j].mine) {
          grille[i][j].minesAutour = minesAutour(i, j);
        }
      }
    }
  }


  // Vérifie si ligne et colonne sont des indices valides d'une case de la grille
  boolean indicesValides(int ligne, int colonne) {
    return 0 <= ligne && ligne < lignes && 0 <= colonne && colonne < colonnes;
  }

  // Choisit au hasard une case vide et pose une mine dedans
  void poserMine() {
    // TODO (question 2)
    int i = int(random(0, lignes));
    int j = int(random(0, colonnes));
    if (grille[i][j].mine) {
      poserMine();
    } else {
      grille[i][j].mine = true;
      minePoser+=1;
    }
  }

  // Renvoie le nombre de mines dans les cases voisines de grille[ligne][colonne]
  int minesAutour(int ligne, int colonne) {
    // TODO (question 3)
    int nbMine = 0;

    for (int i = ligne-1; i <= ligne+1; i++) {
      for (int j = colonne-1; j <= colonne+1; j++) {
        if (indicesValides(i, j) && grille[i][j] != grille[ligne][colonne]) {
          if (grille[i][j].mine) {
            nbMine +=1;
          }
        }
      }
    }
    return nbMine;
  }

  void dessiner() {
    // On affiche un message indiquant la progression du jeu eh haut de la fenêtre
    String message;
    if (boom) {
      message = "Perdu !";
    } else if (casesRevelees == lignes * colonnes - mines) {
      // le joueur gagne s'il révèle toutes les cases vides
      message = "Gagné !";
    } else {
      message = "Mines restantes : " + (mines - casesMarquees);
    }
    textSize(30);
    textAlign(LEFT, CENTER);
    fill(0);
    text(message, 10, 25);
    fill(0, 0, 0, 0);

    // TODO : dessinez toutes les cellules (question 5)
    for (int i=0; i<lignes; i++) {
      for (int j=0; j<colonnes; j++) {
        grille[i][j].dessiner();
      }
    }
  }

  // Gère les clicks de la souris
  void click() {
    for (int i = 0; i < lignes; i++) {
      for (int j = 0; j < colonnes; j++) {
        if (grille[i][j].contient(mouseX, mouseY)) {
          if (mouseButton == LEFT) {
            revelerCase(i, j);
          } else if (mouseButton == RIGHT) {
            marquerCase(i, j);
          }
        }
      }
    }
  }

  // Cette méthode est appelée lorsque le joueur fait un click gauche sur une case.
  // Elle révèle la case et si elle est vide et il n'y a pas de mines autour d'elle,
  // elle révèle récursivement toutes les cases voisines.
  void revelerCase(int ligne, int colonne) {
    Case c = grille[ligne][colonne];
    if (c.cachee && !c.drapeau) {
      c.cachee = false;
      casesRevelees++;
      if (c.mine) {
        boom = true;
      } else if (c.minesAutour == 0) {
        // s'il n'y a aucune mine autour de cette case, on révèle toutes les cases voisines
        for (int i = ligne - 1; i <= ligne + 1; i++) {
          for (int j = colonne - 1; j <= colonne + 1; j++) {
            if (indicesValides(i, j)) {
              revelerCase(i, j);
            }
          }
        }
      }
    }
  }

  // Cette méthode est appelée lorsque le joueur fait un click droit sur une case.
  // Si la case est cachée, elle met/enlève un drapeau sur celle-ci.
  void marquerCase(int ligne, int colonne) {
    Case c = grille[ligne][colonne];

    if (c.cachee) {
      c.drapeau = !c.drapeau;

      if (c.drapeau) {
        casesMarquees++;
      } else {
        casesMarquees--;
      }
    }
  }
}
