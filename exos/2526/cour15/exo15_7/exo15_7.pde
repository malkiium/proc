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

  float marginHaut = 40;
  float marginLeft = 30;
  float marginBottom = 30;
  float barWidth = (width-marginLeft) / distrib.length;

  for (int lnt = 0; lnt < distrib.length; lnt++) {
    float barHeight = map(distrib[lnt], 0, eMax, 0, height - marginHaut);
    rect(marginLeft + barWidth * lnt, height-marginBottom, barWidth, -barHeight);
    text(lnt, (marginLeft+marginLeft/2)+ barWidth * lnt, height-marginBottom/2);
  }

  int nbLignes = eMax;
  for (int lin = 0; lin <= nbLignes; lin++) {
    float y = height - map(lin, 0, nbLignes, 0, height - marginHaut);
    stroke(0, 50);
    line(marginLeft, y-marginBottom, width, y-marginBottom);
  }

  stroke(255, 0, 0);
  float lnpos = marginLeft + barWidth * moyenne - 1;
  line(lnpos, 0, lnpos, height-marginBottom);

  for (int nmb = eMax; nmb > 0; nmb--) {
    float lnY = map(nmb, 0, eMax, height, marginHaut)+5;
    text(nmb, 10, lnY-marginBottom);
  }
}
