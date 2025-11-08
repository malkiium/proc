// Tetris in Processing

int cols = 10, rows = 20, blockSize = 30;
int[][] grid = new int[cols][rows];
color[][] colors = new color[cols][rows];
boolean gameOver = false;
Tetromino currentTetromino;

void settings() {
  size(cols * blockSize, rows * blockSize);
}

void setup() {
  currentTetromino = new Tetromino();
}

void draw() {
  background(0);
  drawGrid();
  currentTetromino.show();
  if (frameCount % 30 == 0) {
    currentTetromino.moveDown();
  }
}

void keyPressed() {
  if (keyCode == LEFT) currentTetromino.move(-1);
  if (keyCode == RIGHT) currentTetromino.move(1);
  if (keyCode == DOWN) currentTetromino.moveDown();
  if (keyCode == UP) currentTetromino.rotate();
}

void drawGrid() {
  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      if (grid[x][y] == 1) {
        fill(colors[x][y]);
        rect(x * blockSize, y * blockSize, blockSize, blockSize);
      }
    }
  }
}

class Tetromino {
  int[][] shape;
  int x = cols / 2 - 1, y = 0;
  color pieceColor;
  
  Tetromino() {
    shape = randomShape();
    pieceColor = randomColor();
  }
  
  void show() {
    fill(pieceColor);
    for (int i = 0; i < shape.length; i++) {
      for (int j = 0; j < shape[i].length; j++) {
        if (shape[i][j] == 1) {
          rect((x + i) * blockSize, (y + j) * blockSize, blockSize, blockSize);
        }
      }
    }
  }
  
  void move(int dir) {
    x += dir;
    if (collision()) x -= dir;
  }
  
  void moveDown() {
    y++;
    if (collision()) {
      y--;
      placeTetromino();
      currentTetromino = new Tetromino();
    }
  }
  
  void rotate() {
    int[][] newShape = new int[shape[0].length][shape.length];
    for (int i = 0; i < shape.length; i++) {
      for (int j = 0; j < shape[i].length; j++) {
        newShape[j][shape.length - 1 - i] = shape[i][j];
      }
    }
    
    int[][] kicks = {{0, 0}, {-1, 0}, {1, 0}, {0, -1}, {0, 1}};
    for (int i = 0; i < kicks.length; i++) {
      x += kicks[i][0];
      y += kicks[i][1];
      if (!collision()) {
        shape = newShape;
        return;
      }
      x -= kicks[i][0];
      y -= kicks[i][1];
    }
  }
  
  boolean collision() {
    for (int i = 0; i < shape.length; i++) {
      for (int j = 0; j < shape[i].length; j++) {
        int newX = x + i;
        int newY = y + j;
        if (shape[i][j] == 1) {
          if (newX < 0 || newX >= cols || newY >= rows || (newY >= 0 && grid[newX][newY] == 1)) {
            return true;
          }
        }
      }
    }
    return false;
  }
  
  void placeTetromino() {
    for (int i = 0; i < shape.length; i++) {
      for (int j = 0; j < shape[i].length; j++) {
        if (shape[i][j] == 1) {
          grid[x + i][y + j] = 1;
          colors[x + i][y + j] = pieceColor;
        }
      }
    }
    checkLines();
  }
}

int[][] randomShape() {
  int[][][] shapes = {
    {{1, 1, 1, 1}}, // I shape
    {{1, 1}, {1, 1}}, // O shape
    {{0, 1, 0}, {1, 1, 1}}, // T shape
    {{1, 0, 0}, {1, 1, 1}}, // L shape
    {{0, 0, 1}, {1, 1, 1}} // J shape
  };
  return shapes[(int) random(shapes.length)];
}

color randomColor() {
  color[] colors = {color(255, 0, 0), color(0, 255, 0), color(0, 0, 255), color(255, 255, 0), color(255, 165, 0), color(128, 0, 128)};
  return colors[(int) random(colors.length)];
}

void checkLines() {
  for (int y = rows - 1; y >= 0; y--) {
    boolean full = true;
    for (int x = 0; x < cols; x++) {
      if (grid[x][y] == 0) {
        full = false;
        break;
      }
    }
    if (full) {
      for (int ty = y; ty > 0; ty--) {
        for (int x = 0; x < cols; x++) {
          grid[x][ty] = grid[x][ty - 1];
          colors[x][ty] = colors[x][ty - 1];
        }
      }
      y++;
    }
  }
}