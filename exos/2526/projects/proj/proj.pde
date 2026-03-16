/*
Simulation simple d'evolution
 */

Balle[] balles;
Evolution evolution;

int ballCount = 1000;
int bestCount = 10;
float minAccel = -0.001;
float maxAccel = 0.001;
int frameRateValue = 120;
int generationTime = 3; // in seconds
int timer = 0;
int generationDuration;
float targetX;
int padding = 30;

void setup() {
  size(1000, 600);
  frameRate(frameRateValue);

  generationDuration = generationTime * frameRateValue;
  targetX = random(padding, width - padding);

  balles = new Balle[ballCount];
  evolution = new Evolution(bestCount, minAccel, maxAccel);

  for (int i = 0; i < balles.length; i++) {
    balles[i] = new Balle(random(-0.2, 0.2));
  }
}

void draw() {
  background(0);

  stroke(255, 0, 0);
  line(targetX, 0, targetX, height);

  updateTimer();

  for (Balle b : balles) {
    b.move();
    b.display();
  }
}

void updateTimer() {
  timer++;
  if (timer >= generationDuration) {
    timer = 0;
    evolution.evolveGeneration(balles);
  }
}
