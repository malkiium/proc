int cercleX = 0;
int cercleY = 0;

void setup() {
  size(200, 200);
}

void draw() {
  background(255);
  fill(127);
  ellipse(width/2, height/2, cercleX, cercleY);

  // on incrémente cercleX
    cercleX += 1;
    cercleY += 1;

    if (cercleX-(cercleX/PI) > width && cercleY-(cercleY/PI) > height) {
        cercleX = 0;
        cercleY = 0;
    }
}