int colore = 0;
int ads = 1;

void setup() {
  size(200, 200);
}

void draw() {
    background(255);
    fill(colore);
    ellipse(width/2, height/2, 50, 50);
    colore += ads;
    if (colore == 255 || colore == 0) {
        ads *= -1;
    }
}