class Balle {
  float x;
  float y;
  float vx;
  float ax;       // acceleration
  float fitness;
  int size = 20;

  Balle(float initialSpeed) {
    reset();
    vx = initialSpeed;
    ax = 0;
  }

  void reset() {
    x = width/2;
    y = height * 2/3;
    vx = 0;
    ax = 0;
    fitness = 0;
  }

  void move() {
    vx += ax;
    x += vx;

    float distance = abs(x - targetX);
    float reward = 1.0 / (distance + 1);

    // punish overshoot
    if ((x - targetX) * vx > 0) reward *= 0.5;

    fitness += reward;
  }


  void display() {
    stroke(0);
    fill(255);
    circle(x, y, size);
  }
}
