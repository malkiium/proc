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
    cercleX = abs(mouseX-width/2)*2;
    cercleY = abs(mouseY-width/2)*2;
}