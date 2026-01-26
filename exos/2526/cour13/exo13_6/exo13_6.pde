void setup() {
  size(400, 400);
  int t = 25; // taille du bouton
  rUp = new Bouton(width / 2 - 2 * t, height / 2 - t, t, color(255, 0, 0), '+');
  rDown = new Bouton(width / 2 - 2 * t, height / 2 + t, t, color(255, 0, 0), '-');
  gUp = new Bouton(width / 2, height / 2 - t, t, color(0, 255, 0), '+');
  gDown = new Bouton(width / 2, height / 2 + t, t, color(0, 255, 0), '-');
  bUp = new Bouton(width / 2 + 2 * t, height / 2 - t, t, color(0, 0, 255), '+');
  bDown = new Bouton(width / 2 + 2 * t, height / 2 + t, t, color(0, 0, 255), '-');
}

void draw() {
  background(r, g, b);
  noStroke();
  fill(0);
  rectMode(CORNER);
  rect(10, 10, width - 20, 40);

  rgb = "color(" + r + ", " + g + ", " + b + ")";
  fill(255);
  textAlign(CENTER, CENTER);
  text(rgb, width / 2, 30);

  rUp.dessiner();
  rDown.dessiner();
  gUp.dessiner();
  gDown.dessiner();
  bUp.dessiner();
  bDown.dessiner();

  if (mousePressed) {
    if (rUp.sourisDedans()) {
      r++;
    } else if (rDown.sourisDedans()) {
      r--;
    } else if (gUp.sourisDedans()) {
      g++;
    } else if (gDown.sourisDedans()) {
      g--;
    } else if (bUp.sourisDedans()) {
      b++;
    } else if (bDown.sourisDedans()) {
      b--;
    }
    r = constrain(r, 0, 255);
    g = constrain(g, 0, 255);
    b = constrain(b, 0, 255);
  }
}

void keyPressed() {
  println(rgb);
}