ArrayList<Ball> balls;
int initialBalls = 10;
float highScore = initialBalls;            
float availableBalls = initialBalls;  
Peg[] pegs;
int numPegRows = 14;        
int numPegCols = 10;        
Bar bar;

void setup() {
  size(600, 800);
  
  // Initialize balls
  balls = new ArrayList<Ball>();
  for (int i = 0; i < initialBalls; i++) {
    float startX = width / 2 + random(-20, 20);
    balls.add(new Ball(startX, 50));
  }
  
  // Create pegs
  int totalPegs = numPegRows * numPegCols;
  pegs = new Peg[totalPegs];
  
  float pegSpacingX = width / float(numPegCols + 1);
  float pegSpacingY = (height - 200) / float(numPegRows - 1);
  int index = 0;
  
  for (int row = 0; row < numPegRows; row++) {
    for (int col = 0; col < numPegCols; col++) {
      float pegX = (col + 0.5 * (row % 2)) * pegSpacingX + pegSpacingX / 2;
      float pegY = row * pegSpacingY + 100;
      pegs[index++] = new Peg(pegX, pegY);
    }
  }
  
  bar = new Bar(0, height - 50, width, 10);
}

void draw() {
  background(255);
  
  bar.display();
  
  for (Peg peg : pegs) {
    peg.display();
  }
  
  for (Ball ball : balls) {
    ball.update();
    ball.display();
    
    if (!ball.removed) {
      float multiplier = bar.getMultiplierForBall(ball);
      if (multiplier > 0) {
        ball.removed = true;
        highScore = max(highScore, availableBalls);  
        availableBalls = (availableBalls + 1) * multiplier;
      }
    }
    
    if (!ball.removed && ball.y - ball.radius > height) {
      ball.removed = true;
    }
  }
  
  for (int i = balls.size() - 1; i >= 0; i--) {
    if (balls.get(i).removed) {
      balls.remove(i);
    }
  }
  
  textAlign(LEFT, TOP);
  fill(0);
  textSize(20);
   text("High Score: " + nf(highScore, 0, 1), 10, 30);
  text("Balls available: " + nf(availableBalls, 0, 1), 10, 60);
}

void keyPressed() {
  if (key == ' ' && availableBalls >= 1) {
    float startX = width / 2 + random(-20, 20);
    balls.add(new Ball(startX, 50));
    availableBalls -= 1;
  }
}

class Ball {
  float x, y;
  float speedX, speedY;
  float gravity = 0.1;
  float radius = 10;
  boolean removed = false;
  
  Ball(float x, float y) {
    this.x = x;
    this.y = y;
    speedX = random(-1, 1);
    speedY = 2;
  }
  
  void update() {
    speedY += gravity;
    x += speedX;
    y += speedY;
    
    for (Peg peg : pegs) {
      float dx = x - peg.x;
      float dy = y - peg.y;
      float distance = sqrt(dx * dx + dy * dy);
      float minDist = radius + peg.radius;
      if (distance < minDist) {
        float nx = dx / distance;
        float ny = dy / distance;
        float overlap = minDist - distance;
        x += nx * overlap;
        y += ny * overlap;
        float dot = speedX * nx + speedY * ny;
        speedX = speedX - 2 * dot * nx;
        speedY = speedY - 2 * dot * ny;
        speedX *= 0.5;
        speedY *= 0.5;
      }
    }
    
    if (x < radius) {
      x = radius;
      speedX *= -0.5;
    }
    if (x > width - radius) {
      x = width - radius;
      speedX *= -0.5;
    }
  }
  
  void display() {
    fill(0);
    ellipse(x, y, radius * 2, radius * 2);
  }
}

class Peg {
  float x, y;
  float radius = 5;
  
  Peg(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  void display() {
    fill(150);
    ellipse(x, y, radius * 2, radius * 2);
  }
}

class Bar {
  float x, y, w, h;
  int segments = 7;
  float[] segmentValues = new float[]{10, 1, 0.5, 0.1, 0.5, 1, 10};
  
  Bar(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  void display() {
    fill(200);
    rect(x, y, w, h);
    
    stroke(0);
    for (int i = 1; i < segments; i++) {
      float segX = x + i * (w / segments);
      line(segX, y, segX, y + h);
    }
    noStroke();
    
    textAlign(CENTER, CENTER);
    fill(0);
    textSize(14);
    for (int i = 0; i < segments; i++) {
      float segCenter = x + i * (w / segments) + (w / segments) / 2;
      text("x" + segmentValues[i], segCenter, y + h / 2);
    }
  }
  
  float getMultiplierForBall(Ball ball) {
    if (ball.x + ball.radius > x && ball.x - ball.radius < x + w &&
        ball.y + ball.radius > y && ball.y - ball.radius < y + h) {
      int segIndex = int((ball.x - x) / (w / segments));
      segIndex = constrain(segIndex, 0, segments - 1);
      return segmentValues[segIndex];
    }
    return 0;
  }
}
