class Candidate {
  float vx;   // initial velocity
  float ax;   // acceleration applied each frame
  float fitness;

  Candidate(float vx, float ax, float fitness) {
    this.vx = vx;
    this.ax = ax;
    this.fitness = fitness;
  }
}
