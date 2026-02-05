String[] sNotes;
int[] notes;
float sommeNotes = 0;
float moyenne = 0;
int[] distrib;
int eMax = 0;

void setup() {
  size(800, 400);

  sNotes = loadStrings("notes.txt");
  notes = int(sNotes);
  distrib = new int[21];

  for (int i = 0; i<sNotes.length; i++) {
    sommeNotes += notes[i];
    distrib[notes[i]] += 1;
  }

  for (int mexmum = 0; mexmum<distrib.length; mexmum++) {
    if (distrib[mexmum] > eMax) {
      eMax = distrib[mexmum];
    }
  }

  moyenne = sommeNotes/sNotes.length;
  println(moyenne, "moyenne");
  println(eMax, "Etudiant Maximum");
}

void draw() {
  background(128);
  fill(255);
  stroke(0);

  float margeHaut = 40;
  float barWidth = width / distrib.length;

  // Barres
  for (int lnt = 0; lnt < distrib.length; lnt++) {
    float barHeight = map(distrib[lnt], 0, eMax, 0, height - margeHaut);
    rect(barWidth * lnt, height, barWidth, -barHeight);
  }

  // Lignes horizontales
  int nbLignes = eMax;
  for (int lin = 0; lin <= nbLignes; lin++) {
    float y = height - map(lin, 0, nbLignes, 0, height - margeHaut);
    line(0, y, width, y);
  }

  // Ligne de moyenne
  stroke(255,0,0);
  float lnpos = barWidth * moyenne + barWidth/2;
  line(lnpos, 0, lnpos, height);
}
