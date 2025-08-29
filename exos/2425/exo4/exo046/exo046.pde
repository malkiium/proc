int cercleX = 0;
int cercleY = 100;
float angle = 0;

void setup() {
  size(200, 200);
}

void draw() {
  background(255);
  fill(127);
  ellipse(cercleX, cercleY, 50, 50);

  // Ligne 1 (angle normal)
  line(cercleX - 25 * cos(angle), cercleY - 25 * sin(angle), 
       cercleX + 25 * cos(angle), cercleY + 25 * sin(angle));
  
  // Ligne 2 (angle + 90°)
  line(cercleX - 25 * cos(angle + HALF_PI), cercleY - 25 * sin(angle + HALF_PI), 
       cercleX + 25 * cos(angle + HALF_PI), cercleY + 25 * sin(angle + HALF_PI));

  // Incrémentations
  cercleX += 1;
  angle += 0.018;
}
