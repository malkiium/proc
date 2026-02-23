Particle[] particles;
int total = 75;

void setup() {
  size(800, 600);

  particles = new Particle[total];

  for (int i = 0; i < total; i++) {

    if (i < total/3)
      particles[i] = new Particle(0); // Blue
    else if (i < 2*total/3)
      particles[i] = new Particle(1); // Red
    else
      particles[i] = new Particle(2); // Green
  }
}

void draw() {
  background(0);

  for (int i = 0; i < total; i++) {
    for (int j = 0; j < total; j++) {
      particles[i].interact(particles[j]);
    }

    particles[i].move();
    particles[i].checkBounds();
    particles[i].look();
  }
}
