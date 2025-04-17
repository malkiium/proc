PVector center;
float bigRadius = 500;
float ballRadius = 10;
PVector ballPos;
PVector ballVel;
PVector gravity;
float currentHue = 0;

void setup() {
  size(1080, 1920);
  background(0);
  smooth(128);
  colorMode(HSB, 255);  // HSB for easy hue cycling
  center = new PVector(width/2, height/2);
  ballPos = center.copy();
  ballVel = new PVector(2, -2);
  gravity = new PVector(0, 0.03);
}

void draw() {
  frameRate(240);

  // Draw the outer boundary
  noFill();
  stroke(100);  // Light gray outline
  strokeWeight(10);
  ellipse(center.x, center.y, bigRadius*2, bigRadius*2);

  // Gravity + motion
  ballVel.add(gravity);
  ballPos.add(ballVel);

  // Collision with border
  PVector toBall = PVector.sub(ballPos, center);
  float dist = toBall.mag();
  if (dist >= bigRadius - ballRadius) {
    toBall.normalize();
    float dot = ballVel.dot(toBall);
    ballVel = PVector.sub(ballVel, PVector.mult(toBall, 2 * dot));
    ballVel.mult(1.01);
    ballRadius += 1;
    ballPos = center.copy().add(toBall.mult(bigRadius - ballRadius));
  }

  // 🔄 Update hue over time
  currentHue = (currentHue + 0.025) % 255;

  // Draw the ball with time-based hue
  strokeWeight(5);
  stroke(currentHue, 255, 255);  // Full saturation & brightness
  fill(0);
  ellipse(ballPos.x, ballPos.y, ballRadius*2, ballRadius*2);
}
