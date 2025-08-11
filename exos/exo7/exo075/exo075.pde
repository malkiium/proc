// Niveau de gris pour chaque carré (255 = blanc, 0 = noir)
float gray1 = 255;
float gray2 = 255;
float gray3 = 255;
float gray4 = 255;

void setup() {
  size(200, 200);
}

void draw() {
  background(255);

  stroke(0);
  line(width / 2, 0, width / 2, height);
  line(0, height / 2, width, height / 2);
  noStroke();

  // Détection des positions de la souris
  boolean in1 = mouseX < width/2 && mouseY < height/2;
  boolean in2 = mouseX >= width/2 && mouseY < height/2;
  boolean in3 = mouseX < width/2 && mouseY >= height/2;
  boolean in4 = mouseX >= width/2 && mouseY >= height/2;

  // Mise à jour du niveau de gris pour chaque carré
  if (in1) {
    gray1 = 0;
  } else {
    gray1 = min(gray1 + 5, 255);
  }

  if (in2) {
    gray2 = 0;
  } else {
    gray2 = min(gray2 + 5, 255);
  }

  if (in3) {
    gray3 = 0;
  } else {
    gray3 = min(gray3 + 5, 255);
  }

  if (in4) {
    gray4 = 0;
  } else {
    gray4 = min(gray4 + 5, 255);
  }

  // Affichage des carrés
  fill(gray1);
  rect(0, 0, width/2, height/2);

  fill(gray2);
  rect(width/2, 0, width/2, height/2);

  fill(gray3);
  rect(0, height/2, width/2, height/2);

  fill(gray4);
  rect(width/2, height/2, width/2, height/2);
}
