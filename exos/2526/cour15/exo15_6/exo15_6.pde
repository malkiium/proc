int[] nbOcc = new int[100];

void setup() {
  size(800, 400);
  frameRate(10000000);

  // On initialise tout à zéro
  for (int i = 0; i < nbOcc.length; i++) {
    nbOcc[i] = 0;
  }
}

void draw() {
  // On génère un nombre aléatoire
  int r = int(random(nbOcc.length));

  // On met à jour le nombre de ses occurrences
  nbOcc[r]++;

  for (int i = 0; i < nbOcc.length; i++) {
    rect((width/nbOcc.length)*i, height, (width/nbOcc.length), -nbOcc[i]);
  }
}