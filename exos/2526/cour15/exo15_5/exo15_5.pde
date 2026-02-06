int[] fib;
int x, y, dir;

void setup() {
  size(1597, 987);
  fib = new int[17];
  fib[0] = 0;
  fib[1] = 1;
  for (int i = 2; i < fib.length; i++) {
    fib[i] = fib[i-1] + fib[i-2];
  }
  println(fib);

  noStroke();
  noLoop();

  x = 0;
  y = 0;
  dir = 0;
}

void draw() {
  background(255);
  rectMode(CORNER);

  for (int i = fib.length - 1; i > 0; i--) {
    int size = fib[i];

    fill(random(100, 255), random(100, 255), random(100, 255), 150);

    rect(x, y, size, size);

    if (dir == 0) {
      x += size;
      dir = 1;
    } else if (dir == 1) {
      y += size;
      dir = 2;
    } else if (dir == 2) {
      x -= size;
      dir = 3;
    } else {
      y -= size;
      dir = 0;
    }
  }
}
