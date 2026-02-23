class BB {
  float x, y;
  float vx = 0;
  float vy = 0;
  float size = 10;

  BB() {
    x = random(width);
    y = random(height);
  }

  void look() {
    fill(0, 0, 255);
    circle(x, y, size);
  }

  void move() {
    vx *= 0.98;
    vy *= 0.98;

    x += vx;
    y += vy;
  }

  void repelFrom(RB other) {
    float dx = x - other.x;
    float dy = y - other.y;

    float distance = sqrt(dx*dx + dy*dy);

    if (distance < 50 && distance > 0) {

      dx /= distance;
      dy /= distance;

      float force = 0.5;
      vx += dx * force;
      vy += dy * force;
    }
  }

  void checkBounds() {
    if (x <= 2 || x >= width-2 || y <= 2 || y >= height-2) {
      x = random(width);
      y = random(height);
      vx = 0;
      vy = 0;
    }
  }
}
