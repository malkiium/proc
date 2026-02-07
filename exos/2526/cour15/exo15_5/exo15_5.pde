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
  textAlign(CENTER, CENTER);
  fill(128);


  for (int i = fib.length - 1; i > 0; i--) {

    // fill pour les rect
    fill(random(100, 255), random(100, 255), random(100, 255), 150);
    stroke(1);
    
    rect(x, y, fib[i], fib[i]);
    
    fill(0); // text noir
    text(fib[i], x + fib[i]/2, y + fib[i]/2);

    //reset des fill pour les arc
    noFill();

    if (dir == 0) { // Le premier carré
      arc(x+fib[i], y+fib[i], fib[i]*2, fib[i]*2, PI, PI+HALF_PI);
      x += fib[i];
      dir = 1;
    } else if (dir == 1) { // Le second
      arc(x, y+fib[i], fib[i]*2, fib[i]*2, PI+HALF_PI, TWO_PI);
      x += fib[i-2];
      y += fib[i];
      dir = 2;
    } else if (dir == 2) { // Le Troieme
      arc(x, y, fib[i]*2, fib[i]*2, 0, HALF_PI);
      x -= fib[i-1];
      y += fib[i-2];
      dir = 3;
    } else { // Le quatrieme
      arc(x+fib[i], y, fib[i]*2, fib[i]*2, HALF_PI, PI);
      y -= fib[i-1];
      dir = 0;
    }
  }
}
