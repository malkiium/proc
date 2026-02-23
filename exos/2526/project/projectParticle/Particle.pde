class Particle {

  float x, y;
  float vx = 0;
  float vy = 0;
  float size = 12;

  int type;

  Particle(int t) {
    type = t;
    x = random(width);
    y = random(height);
  }

  void look() {
    if (type == 0) fill(0, 0, 255);
    else if (type == 1) fill(255, 0, 0);
    else fill(0, 255, 0);

    circle(x, y, size);
  }

  void move() {
    vx *= 0.98;
    vy *= 0.98;

    x += vx;
    y += vy;
  }

  void checkBounds() {
    if (x < 0) x += width;
    if (x > width) x -= width;
    if (y < 0) y += height;
    if (y > height) y -= height;
  }

  void interact(Particle other) {

    if (other == this) return;

    float dx = other.x - x;
    float dy = other.y - y;

    float distSq = dx*dx + dy*dy;
    float vision = 50;

    if (distSq < vision*vision && distSq > 0) {

      float distance = sqrt(distSq);

      dx /= distance;
      dy /= distance;

      // B O G
      if (type == 0 && other.type == 2) {
        float force = 0.04;
        vx += dx * force;
        vy += dy * force;
      }
      
      // G v B
      else if (type == 2 && other.type == 0) {
        float force = 0.04;
        vx -= dx * force;
        vy -= dy * force;
      }

      // G O R
      else if (type == 2 && other.type == 1) {
        float force = 0.04;
        vx += dx * force;
        vy += dy * force;
      }

      // R v G
      else if (type == 1 && other.type == 2) {
        float force = 0.04;
        vx -= dx * force;
        vy -= dy * force;
      } else if (type == other.type) {

        float inner = size;      
        float outer = 40;        


        float nx = dx;
        float ny = dy;


        if (distance < inner && distance > 0) {

          float force = 0.4;
          vx -= nx * force;
          vy -= ny * force;
        } else if (distance < outer) {

          float force = 0.02;
          vx += nx * force;
          vy += ny * force;
        }
      }
    }
  }
}
