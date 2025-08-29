int cols = 3, rows = 3; // Change this to scale the board
int cellSize = 100;
char[][] board;

void settings() {
  size(cols * cellSize, rows * cellSize);
}

void setup() {
  board = new char[cols][rows];
}

void draw() {
  background(255);
  drawGrid();
  drawBoard();
  checkWin();
}

void drawGrid() {
  stroke(0);
  for (int i = 1; i < cols; i++) {
    line(i * cellSize, 0, i * cellSize, height);
  }
  for (int j = 1; j < rows; j++) {
    line(0, j * cellSize, width, j * cellSize);
  }
}

void drawBoard() {
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      float x = i * cellSize + cellSize / 2;
      float y = j * cellSize + cellSize / 2;
      if (board[i][j] == 'X') {
        drawCross(x, y);
      } else if (board[i][j] == 'O') {
        drawCircle(x, y);
      }
    }
  }
}

void drawCross(float x, float y) {
  stroke(255, 0, 0);
  strokeWeight(4);
  line(x - cellSize / 3, y - cellSize / 3, x + cellSize / 3, y + cellSize / 3);
  line(x + cellSize / 3, y - cellSize / 3, x - cellSize / 3, y + cellSize / 3);
}

void drawCircle(float x, float y) {
  stroke(0, 255, 0);
  strokeWeight(4);
  noFill();
  ellipse(x, y, cellSize / 1.5, cellSize / 1.5);
}

void mousePressed() {
  int i = mouseX / cellSize;
  int j = mouseY / cellSize;
  if (i < cols && j < rows && board[i][j] == '\0') {
    if (mouseButton == LEFT) {
      board[i][j] = 'X';
    } else if (mouseButton == RIGHT) {
      board[i][j] = 'O';
    }
  }
}

void checkWin() {
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      if (board[i][j] != '\0') {
        if (checkDirection(i, j, 1, 0) || checkDirection(i, j, 0, 1) || checkDirection(i, j, 1, 1) || checkDirection(i, j, 1, -1)) {
          println("Winner: " + board[i][j]);
        }
      }
    }
  }
}

boolean checkDirection(int x, int y, int dx, int dy) {
  char symbol = board[x][y];
  for (int k = 1; k < cols; k++) {
    int nx = x + dx * k;
    int ny = y + dy * k;
    if (nx < 0 || nx >= cols || ny < 0 || ny >= rows || board[nx][ny] != symbol) {
      return false;
    }
  }
  return true;
}