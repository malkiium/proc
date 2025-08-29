float Fib[] = new float[20];

void setup() {
  size(1597, 987);
  
  Fib[0] = 0;
  Fib[1] = 1;
  
  for (int i = 2; i< Fib.length; i++) {
    Fib[i] = Fib[i-1] + Fib[i-2];
  }
  fill(random(0,256), random(0,256), random(0,256));
}

void draw() {
  background(255);
  rects();
  spiral();
}

void rects() {
  fill(145, 32, 135);
  rect(0, 0 , Fib[16], Fib[16]);
  rect(Fib[16], 0, Fib[15], Fib[15]);
  rect(Fib[16]+Fib[13], Fib[15], Fib[15], Fib[14]);
  rect(Fib[16], Fib[15]+Fib[12], Fib[13], Fib[13]);
  rect(Fib[16], Fib[15], Fib[12], Fib[12]);
  rect(Fib[16]+Fib[12], Fib[15], Fib[11], Fib[11]);
  rect(Fib[16]+Fib[12]+Fib[9], Fib[15]+Fib[11], Fib[10], Fib[10]);
  
}

void spiral() {
  noFill(); // No fill for the arcs
  ellipseMode(CORNER);
  
  float angle = 0; // Start at 0 radians
  
  // Iterate through Fibonacci numbers in reverse order to draw arcs in a spiral pattern
  for (int i = 16; i >= 1; i--) { // Start from 16 and go down to 1
    arc(Fib[i], Fib[i], Fib[i-1], Fib[i-1], angle, angle + HALF_PI); // Draw arc with Fibonacci sizes
    angle += PI / 2; // Gradually increase the angle for the spiral effect
  }
}
