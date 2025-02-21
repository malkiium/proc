boolean left = false;
boolean right = false;
int paddleX;
int paddleY;
int paddleWidth = 75;
int paddleHeight = 10;
int ballX, ballY;
int ballSize = 20;
float speedX;
float speedY;
float ballSpeed = 10;
int brickHeight = 30;
int brickWidth;
int x = 0;
int y = brickHeight / 4;
int[] bricksX;
int[] bricksY;
boolean[] bricksAlive;
float scaler;
float fps = 60;

// Parameters for paddle movement
float paddleSpeed = 9;

void setup() {
  size(1000, 900);
  surface.setResizable(true);
  paddleX = width/2;

  // Initialize bricks
  int brickCount = 45;
  bricksX = new int[brickCount];
  bricksY = new int[brickCount];
  bricksAlive = new boolean[brickCount];

  // Set all bricks as alive initially
  for (int i = 0; i < brickCount; i++) {
    bricksAlive[i] = true;
  }

  // Initialize ball position and speed
  ballX = width / 2;
  ballY = height / 2;
  setInitialBallSpeed();
}

void draw() {
  fps+= 0.03;
  println(fps);
  frameRate(fps);
  background(0);
  paddleX = ballX;
  paddleY = height - 30;

  brickWidth = width / 15; // Update brick width based on current window size

  // Update brick positions dynamically for current window width
  updateBricksLayout();

  // Draw paddle
  fill(255);
  rectMode(CENTER);
  rect(paddleX, paddleY, paddleWidth, paddleHeight);

  // Paddle movement
  if (left) {
    paddleX -= paddleSpeed;
  }
  if (right) {
    paddleX += paddleSpeed;
  }

  // Constrain paddle within screen bounds
  paddleX = constrain(paddleX, paddleWidth / 2, width - paddleWidth / 2);

  // Draw ball
  ellipseMode(CENTER);
  circle(ballX, ballY, ballSize);

  // Ball movement
  ballX += speedX;
  ballY += speedY;

  // Ball collision with walls and paddle
  checkWallCollisions();
  checkPaddleCollision();

  // Ball collision with bricks
  checkBricksCollision();

  // Game over check
  if (ballY - ballSize / 2 >= height) {
    gameOver();
  }

  // Draw bricks
  drawBricks();

  // Check win condition
  checkWinCondition();
}

void updateBricksLayout() {
  int x = 0;
  int y = brickHeight / 4;

  for (int i = 0; i < bricksX.length; i++) {
    if (x + brickWidth > width) { // Move to the next row if reaching screen edge
      x = 0;
      y += brickHeight + (brickHeight / 4);
    }
    bricksX[i] = x;
    bricksY[i] = y;
    x += brickWidth;
  }
}

void drawBricks() {
  for (int i = 0; i < bricksX.length; i++) {
    if (bricksAlive[i]) {  // Only draw bricks that are alive
      fill(200, 0, 0);
      rectMode(CORNER);
      rect(bricksX[i], bricksY[i], brickWidth, brickHeight);
    }
  }
}

void checkBricksCollision() {
  for (int i = 0; i < bricksX.length; i++) {
    if (bricksAlive[i]) {  // Check if the brick is alive

      // Define brick boundaries
      int brickLeft = bricksX[i];
      int brickRight = bricksX[i] + brickWidth;
      int brickTop = bricksY[i];
      int brickBottom = bricksY[i] + brickHeight;

      // Check if ball collides with the brick
      if (ballX + ballSize / 2 > brickLeft && ballX - ballSize / 2 < brickRight &&
        ballY + ballSize / 2 > brickTop && ballY - ballSize / 2 < brickBottom) {

        // "Destroy" the brick by setting its alive status to false
        bricksAlive[i] = false;

        // Calculate the overlap distances from each side
        float overlapLeft = (ballX + ballSize / 2) - brickLeft;
        float overlapRight = brickRight - (ballX - ballSize / 2);
        float overlapTop = (ballY + ballSize / 2) - brickTop;
        float overlapBottom = brickBottom - (ballY - ballSize / 2);

        // Find the smallest overlap to determine collision side
        boolean hitFromLeftOrRight = (overlapLeft < overlapRight && overlapLeft < overlapTop && overlapLeft < overlapBottom) ||
          (overlapRight < overlapLeft && overlapRight < overlapTop && overlapRight < overlapBottom);
        boolean hitFromTopOrBottom = !hitFromLeftOrRight;

        // Reverse the appropriate speed direction
        if (hitFromLeftOrRight) {
          speedX *= -1; // Reverse horizontal direction
        } else if (hitFromTopOrBottom) {
          speedY *= -1; // Reverse vertical direction
        }

        // Shift ball slightly to avoid repeated collisions
        ballX += (speedX > 0) ? 1 : -1;
        ballY += (speedY > 0) ? 1 : -1;

        // Exit loop after handling collision for this brick
        break;
      }
    }
  }
}

void checkWinCondition() {
  boolean allBricksDestroyed = true;
  for (boolean isAlive : bricksAlive) {
    if (isAlive) {
      allBricksDestroyed = false;
      break;
    }
  }

  if (allBricksDestroyed) {
    background(0, 255, 0);
    textAlign(CENTER);
    textSize(75);
    fill(255);
    text("You WIN! Press R to restart", width / 2, height / 2);
    noLoop();
  }
}

void keyPressed() {
  if (key == 'q') {
    left = true;
  } else if (key == 'd') {
    right = true;
  }
  if (key == 'r') {
    restart();
  }
}

void keyReleased() {
  if (key == 'q') {
    left = false;
  } else if (key == 'd') {
    right = false;
  }
}

void gameOver() {
  background(255, 0, 0);
  textAlign(CENTER);
  textSize(75);
  fill(0);
  text("You lost.\nPress R to restart", width / 2, height / 2);
  noLoop();
}

void restart() {
  paddleX = width / 2;
  ballX = width / 2;
  ballY = height / 2;
  setInitialBallSpeed();
  fps = 60;
  loop();

  // Reset all bricks
  for (int i = 0; i < bricksAlive.length; i++) {
    bricksAlive[i] = true;
  }
}

void setInitialBallSpeed() {
  float minAngle = PI / 3;       // 60 degrees
  float maxAngle = 2 * PI / 3;   // 120 degrees
  float angle = random(-minAngle, -maxAngle);

  // Set speedX and speedY based on the angle
  speedX = cos(angle) * ballSpeed;
  speedY = sin(angle) * ballSpeed;

  // Randomly invert the X direction for variation
  if (random(1) < 0.5) {
    speedX *= -1;
  }
}

void checkWallCollisions() {
  // Collision avec le mur gauche
  if (ballX - ballSize / 2 <= 0) {
    ballX = ballSize / 2; // Réajustement pour éviter que la balle reste bloquée
    speedX *= -1;         // Inversion de la direction horizontale
  }

  // Collision avec le mur droit
  else if (ballX + ballSize / 2 >= width) {
    ballX = width - ballSize / 2; // Réajustement pour éviter que la balle reste bloquée
    speedX *= -1;
  }

  // Collision avec le mur supérieur
  if (ballY - ballSize / 2 <= 0) {
    ballY = ballSize / 2; // Réajustement pour éviter que la balle reste bloquée
    speedY *= -1;
  }
}

void checkPaddleCollision() {
  if (ballY + ballSize / 2 >= paddleY - paddleHeight / 2 &&
    ballY - ballSize / 2 <= paddleY + paddleHeight / 2 &&
    ballX >= paddleX - paddleWidth / 2 &&
    ballX <= paddleX + paddleWidth / 2) {
    speedY *= -1;
  }
}
