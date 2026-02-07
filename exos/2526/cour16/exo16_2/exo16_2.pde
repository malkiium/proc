Bandes[] bandes = new Bandes[10];
Voiture[] voitures = new Voiture[100];

void setup() {
  size(200, 200);
  for (int i = 0; i < bandes.length; i++) {
    bandes[i] = new Bandes();
  }
  for (int i = 0; i < voitures.length; i++) {
    voitures[i] = new Voiture(0, i * 4, random(1, 5), color(i * 2), 8);
  }
}

void draw() {
  background(100);

  for (int i = 0; i < bandes.length; i++) {
    bandes[i].bouger();
    bandes[i].mouse = false;

    for (int j = 0; j < voitures.length; j++) {
      bandes[i].rollover(voitures[j].x);
    }

    bandes[i].dessiner();
  }

  for (int i = 0; i < voitures.length; i++) {
    voitures[i].dessiner();
    voitures[i].bouger();
  }
}
