int cells = 450;
int[] t = new int[cells];
int[] nextt = new int[cells];
int regle = 18; // 18, 73, 
int taille = 900/cells;
int ligne = 0;

void setup() {
  size(900, 900);
  t[t.length/2] = 1;
}


void draw() {
  for (int i = 0; i < t.length; i++) {
    int bit = (cellule(t, i-1) << 2) | (cellule(t, i) << 1) | (cellule(t, i+1));
    int resulat = (regle >> bit) & 1;
    nextt[i] = resulat;
    if (t[i] == 1) {
      fill(0);
    }
    else {
      fill(255);
    }
    noStroke();
    rect(i*taille, ligne*taille, taille, taille);
  }

  for (int i = 0; i < t.length; i++) {
    t[i] = nextt[i];
  }
  ligne+= 1;

  /*
  if (ligne >= cells) {
    background(255);
    regle +=1;
    ligne = 0;
    for (int i=0; i < t.length; i++) {
      t[i] = 0;
      t[t.length/2] = 1;
    }
    println(regle);
  } 
  */
}

int cellule(int[] etat, int i) {
  return etat[(i + etat.length) % etat.length];
}
