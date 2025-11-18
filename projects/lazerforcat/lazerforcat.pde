float x = 960;
float y = 540;
float r = 20;
float nx = 0;
float ny = 10000;
float nspd = 0.01;
float maxs = 30;
float jit = 4;
float jitspd = 0.5;
float vx = 0;
float vy = 0;

void setup() {
  size(1920, 1080);
  frameRate(170);
}

void draw() {
  background(0);

  nx += nspd;
  ny += nspd;
  vx = (noise(nx) - 0.5) * maxs;
  vy = (noise(ny) - 0.5) * maxs;

  float jx = (noise(frameCount * jitspd) - 0.5) * jit;
  float jy = (noise((frameCount + 5000) * jitspd) - 0.5) * jit;
  x += vx + jx;
  y += vy + jy;

  float rr = r / 2;
  if (x <= rr) {
    x = rr;
    nx += 2000;
  }
  if (x >= width - rr) {
    x = width - rr;
    nx += 2000;
  }
  if (y <= rr) {
    y = rr;
    ny += 2000;
  }
  if (y >= height - rr) {
    y = height - rr;
    ny += 2000;
  }
  noStroke();
  fill(255, 0, 0);
  circle(x, y, r);
}